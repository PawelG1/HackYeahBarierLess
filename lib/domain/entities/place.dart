/// Obiekt docelowy / punkt użyteczności publicznej (POI).
class Place {
  final String id;
  final String name;
  final String nodeId;

  const Place({
    required this.id,
    required this.name,
    required this.nodeId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Place &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          nodeId == other.nodeId;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ nodeId.hashCode;
}
