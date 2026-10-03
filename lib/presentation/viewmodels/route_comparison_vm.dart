import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/providers.dart';
import '../../domain/entities/observation.dart';
import '../../domain/entities/route_result.dart';

/// Stan widoku porównania tras.
class RouteComparisonState {
  final List<RouteResult> routes;
  final int selectedRouteIndex;
  final String startNodeId;
  final String destinationPlaceId;
  final bool avoidStairs;

  const RouteComparisonState({
    required this.routes,
    this.selectedRouteIndex = 0,
    required this.startNodeId,
    required this.destinationPlaceId,
    required this.avoidStairs,
  });

  RouteResult? get selectedRoute {
    if (routes.isEmpty || selectedRouteIndex >= routes.length) return null;
    return routes[selectedRouteIndex];
  }

  RouteComparisonState copyWith({
    List<RouteResult>? routes,
    int? selectedRouteIndex,
    String? startNodeId,
    String? destinationPlaceId,
    bool? avoidStairs,
  }) {
    return RouteComparisonState(
      routes: routes ?? this.routes,
      selectedRouteIndex: selectedRouteIndex ?? this.selectedRouteIndex,
      startNodeId: startNodeId ?? this.startNodeId,
      destinationPlaceId: destinationPlaceId ?? this.destinationPlaceId,
      avoidStairs: avoidStairs ?? this.avoidStairs,
    );
  }
}

/// ViewModel zarządzający wyznaczaniem tras, wyborem alternatywy i odświeżaniem.
class RouteComparisonVm extends AsyncNotifier<RouteComparisonState?> {
  @override
  Future<RouteComparisonState?> build() async {
    return null; // Początkowo przed wywołaniem evaluate
  }

  /// Wylicza warianty tras dla wybranych punktów i preferencji.
  Future<void> evaluate({
    required String startNodeId,
    required String destinationPlaceId,
    required bool avoidStairs,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final compareRoutes = ref.read(compareRoutesUseCaseProvider);
      final routes = await compareRoutes(
        startNodeId: startNodeId,
        destinationPlaceId: destinationPlaceId,
        avoidStairs: avoidStairs,
      );

      return RouteComparisonState(
        routes: routes,
        selectedRouteIndex: 0,
        startNodeId: startNodeId,
        destinationPlaceId: destinationPlaceId,
        avoidStairs: avoidStairs,
      );
    });
  }

  /// Zmienia zaznaczoną trasę (np. kliknięcie w kartę Trasy B).
  void selectRoute(int index) {
    final current = state.value;
    if (current != null && index >= 0 && index < current.routes.length) {
      state = AsyncValue.data(current.copyWith(selectedRouteIndex: index));
    }
  }

  /// Dodaje lokalną obserwację użytkownika i natychmiast przelicza trasy.
  Future<void> addLocalObservation(Observation observation) async {
    final current = state.value;
    if (current == null) return;

    final addObs = ref.read(addObservationUseCaseProvider);
    await addObs(observation);
    ref.invalidate(pointObservationsProvider);

    // Ponowne przeliczenie tras z nową obserwacją w pamięci
    await evaluate(
      startNodeId: current.startNodeId,
      destinationPlaceId: current.destinationPlaceId,
      avoidStairs: current.avoidStairs,
    );
  }

  /// Czyści lokalne zgłoszenia demonstracyjne i przywraca stan pierwotny.
  Future<void> clearDemoData() async {
    final obsRepo = ref.read(observationRepositoryProvider);
    await obsRepo.clearDemoData();

    final current = state.value;
    if (current != null) {
      // Ponowne przeliczenie po wyczyszczeniu
      await evaluate(
        startNodeId: current.startNodeId,
        destinationPlaceId: current.destinationPlaceId,
        avoidStairs: current.avoidStairs,
      );
    }
  }
}

final routeComparisonVmProvider =
    AsyncNotifierProvider<RouteComparisonVm, RouteComparisonState?>(
  RouteComparisonVm.new,
);
