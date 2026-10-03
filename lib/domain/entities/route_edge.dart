/// Odcinek (krawędź) łączący dwa węzły grafu.
class RouteEdge {
  final String id;
  final String from;
  final String to;
  final int distanceM;
  final String feature;

  const RouteEdge({
    required this.id,
    required this.from,
    required this.to,
    required this.distanceM,
    required this.feature,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RouteEdge &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          from == other.from &&
          to == other.to &&
          distanceM == other.distanceM &&
          feature == other.feature;

  @override
  int get hashCode =>
      id.hashCode ^
      from.hashCode ^
      to.hashCode ^
      distanceM.hashCode ^
      feature.hashCode;
}
