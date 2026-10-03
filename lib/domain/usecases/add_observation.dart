import '../entities/observation.dart';
import '../repositories/observation_repository.dart';

/// Przypadek użycia dodający lokalną obserwację na urządzeniu.
class AddObservation {
  final ObservationRepository observationRepository;

  const AddObservation({required this.observationRepository});

  Future<void> call(Observation observation) async {
    await observationRepository.addObservation(observation);
  }
}
