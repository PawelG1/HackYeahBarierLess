/// Węzeł w grafie przestrzeni miejskiej.
class RouteNode {
  final String id;
  final double lat;
  final double lon;

  const RouteNode({
    required this.id,
    required this.lat,
    required this.lon,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RouteNode &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          lat == other.lat &&
          lon == other.lon;

  @override
  int get hashCode => id.hashCode ^ lat.hashCode ^ lon.hashCode;
}
