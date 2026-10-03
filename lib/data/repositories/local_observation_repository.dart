import '../../domain/entities/observation.dart';
import '../../domain/repositories/observation_repository.dart';
import '../sources/preferences_source.dart';

/// Implementacja ObservationRepository korzystająca z PreferencesSource.
class LocalObservationRepository implements ObservationRepository {
  final PreferencesSource preferencesSource;

  const LocalObservationRepository({required this.preferencesSource});

  @override
  Future<List<Observation>> getLocalObservations() async {
    return await preferencesSource.getLocalObservations();
  }

  @override
  Future<void> addObservation(Observation observation) async {
    await preferencesSource.addObservation(observation);
  }

  @override
  Future<void> clearDemoData() async {
    await preferencesSource.clearDemoData();
  }

  @override
  Future<bool> getAvoidStairsPreference() async {
    return await preferencesSource.getAvoidStairsPreference();
  }

  @override
  Future<void> setAvoidStairsPreference(bool avoid) async {
    await preferencesSource.setAvoidStairsPreference(avoid);
  }
}
