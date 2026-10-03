import '../repositories/route_repository.dart';

/// Przypadek użycia ładujący dane obszaru demonstracyjnego.
class LoadArea {
  final RouteRepository routeRepository;

  const LoadArea({required this.routeRepository});

  Future<AreaGraph> call() async {
    return await routeRepository.loadArea();
  }
}
