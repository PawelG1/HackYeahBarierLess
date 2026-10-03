import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/providers.dart';
import '../../domain/entities/observation.dart';
import '../../domain/entities/place.dart';

/// Informacje o dostępności obiektu docelowego i wydarzeniach.
class PlaceDetailState {
  final Place? place;
  final List<Observation> observations;
  final bool isLoading;
  final String? errorMessage;

  const PlaceDetailState({
    this.place,
    this.observations = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  PlaceDetailState copyWith({
    Place? place,
    List<Observation>? observations,
    bool? isLoading,
    String? errorMessage,
  }) {
    return PlaceDetailState(
      place: place ?? this.place,
      observations: observations ?? this.observations,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

/// ViewModel obsługujący szczegóły miejsca docelowego i wydarzeń kulturalnych.
class PlaceDetailVm extends FamilyNotifier<PlaceDetailState, String> {
  @override
  PlaceDetailState build(String placeId) {
    Future.microtask(() => _loadPlaceDetails(placeId));
    return const PlaceDetailState(isLoading: true);
  }

  Future<void> _loadPlaceDetails(String placeId) async {
    try {
      final loadArea = ref.read(loadAreaUseCaseProvider);
      final obsRepo = ref.read(observationRepositoryProvider);

      final graph = await loadArea();
      final localObs = await obsRepo.getLocalObservations();

      final place = graph.places.firstWhere(
        (p) => p.id == placeId,
        orElse: () => throw ArgumentError('Nie znaleziono miejsca: $placeId'),
      );

      final allPlaceObs = [
        ...graph.baseObservations
            .where((o) => o.targetType == 'place' && o.targetId == placeId),
        ...localObs
            .where((o) => o.targetType == 'place' && o.targetId == placeId),
      ];

      state = PlaceDetailState(
        place: place,
        observations: allPlaceObs,
        isLoading: false,
      );
    } catch (e) {
      state = PlaceDetailState(
        isLoading: false,
        errorMessage: 'Błąd podczas odczytu danych miejsca: $e',
      );
    }
  }
}

final placeDetailVmProvider =
    NotifierProvider.family<PlaceDetailVm, PlaceDetailState, String>(
  PlaceDetailVm.new,
);
