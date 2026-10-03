import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/providers.dart';
import '../../domain/repositories/route_repository.dart';

/// Stan formularza wyboru trasy i preferencji barierowych.
class RouteSetupState {
  final AreaGraph? areaGraph;
  final String? selectedStartNodeId;
  final String? selectedDestinationPlaceId;
  final bool avoidStairs;
  final bool isLoading;
  final String? errorMessage;

  const RouteSetupState({
    this.areaGraph,
    this.selectedStartNodeId,
    this.selectedDestinationPlaceId,
    this.avoidStairs = true,
    this.isLoading = false,
    this.errorMessage,
  });

  RouteSetupState copyWith({
    AreaGraph? areaGraph,
    String? selectedStartNodeId,
    String? selectedDestinationPlaceId,
    bool? avoidStairs,
    bool? isLoading,
    String? errorMessage,
  }) {
    return RouteSetupState(
      areaGraph: areaGraph ?? this.areaGraph,
      selectedStartNodeId: selectedStartNodeId ?? this.selectedStartNodeId,
      selectedDestinationPlaceId:
          selectedDestinationPlaceId ?? this.selectedDestinationPlaceId,
      avoidStairs: avoidStairs ?? this.avoidStairs,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

/// ViewModel obsługujący ekran wyboru potrzeb i parametrów trasy.
class RouteSetupVm extends Notifier<RouteSetupState> {
  @override
  RouteSetupState build() {
    Future.microtask(_init);
    return const RouteSetupState(isLoading: true);
  }

  Future<void> _init() async {
    try {
      final loadArea = ref.read(loadAreaUseCaseProvider);
      final obsRepo = ref.read(observationRepositoryProvider);

      final graph = await loadArea();
      final prefAvoidStairs = await obsRepo.getAvoidStairsPreference();

      // Domyślny start: n-dworzec, cel: Teatr Słowackiego (p-teatr-slowackiego)
      state = state.copyWith(
        areaGraph: graph,
        selectedStartNodeId:
            graph.nodes.isNotEmpty ? graph.nodes.first.id : null,
        selectedDestinationPlaceId:
            graph.places.isNotEmpty ? graph.places.first.id : null,
        avoidStairs: prefAvoidStairs,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Błąd podczas ładowania danych demonstracyjnych: $e',
      );
    }
  }

  void selectStartNode(String nodeId) {
    state = state.copyWith(selectedStartNodeId: nodeId);
  }

  void selectDestinationPlace(String placeId) {
    state = state.copyWith(selectedDestinationPlaceId: placeId);
  }

  Future<void> toggleAvoidStairs(bool value) async {
    state = state.copyWith(avoidStairs: value);
    final obsRepo = ref.read(observationRepositoryProvider);
    await obsRepo.setAvoidStairsPreference(value);
  }

  Future<void> reload() async {
    await _init();
  }
}

final routeSetupVmProvider =
    NotifierProvider<RouteSetupVm, RouteSetupState>(RouteSetupVm.new);
