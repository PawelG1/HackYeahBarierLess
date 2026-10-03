import '../entities/observation.dart';
import '../entities/place.dart';
import '../entities/route_edge.dart';
import '../entities/route_node.dart';

/// Spójny model grafu obszaru demonstracyjnego.
class AreaGraph {
  final String areaId;
  final String areaName;
  final String dataKind;
  final List<Place> places;
  final List<RouteNode> nodes;
  final List<RouteEdge> edges;
  final List<Observation> baseObservations;

  const AreaGraph({
    required this.areaId,
    required this.areaName,
    required this.dataKind,
    required this.places,
    required this.nodes,
    required this.edges,
    required this.baseObservations,
  });

  bool get isDemoArea => dataKind == 'demo';
}

/// Port dostępu do danych grafu demonstracyjnego.
abstract class RouteRepository {
  Future<AreaGraph> loadArea();
}
