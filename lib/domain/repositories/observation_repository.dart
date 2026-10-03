import '../entities/observation.dart';

/// Port dostępu do lokalnej pamięci obserwacji i preferencji użytkownika na urządzeniu.
abstract class ObservationRepository {
  /// Pobiera listę lokalnie dodanych obserwacji.
  Future<List<Observation>> getLocalObservations();

  /// Zapisuje nową lokalną obserwację.
  Future<void> addObservation(Observation observation);

  /// Czyści lokalne zgłoszenia demonstracyjne i przywraca stan pierwotny.
  Future<void> clearDemoData();

  /// Pobiera zapisaną preferencję „Unikam schodów”.
  Future<bool> getAvoidStairsPreference();

  /// Zapisuje preferencję „Unikam schodów”.
  Future<void> setAvoidStairsPreference(bool avoid);
}
