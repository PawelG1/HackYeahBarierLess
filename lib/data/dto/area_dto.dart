import '../../core/errors/app_error.dart';
import '../../domain/entities/observation.dart';
import '../../domain/entities/place.dart';
import '../../domain/entities/route_edge.dart';
import '../../domain/entities/route_node.dart';
import '../../domain/repositories/route_repository.dart';

/// DTO odpowiedzialne za parsowanie i rygorystyczną walidację pliku JSON demo_area.json.
class AreaDto {
  static AreaGraph fromJson(Map<String, dynamic> json) {
    // 1. Walidacja wersji schematu
    final schemaVersion = json['schema_version'];
    if (schemaVersion != 1) {
      throw ValidationError(
        'Nieobsługiwana wersja schematu: $schemaVersion. Wymagana wersja: 1',
      );
    }

    // 2. Obszar (Area)
    final areaMap = json['area'] as Map<String, dynamic>?;
    if (areaMap == null || areaMap['id'] == null || areaMap['name'] == null) {
      throw const ValidationError('Brak wymaganych danych w obiekcie "area"');
    }
    final areaId = areaMap['id'] as String;
    final areaName = areaMap['name'] as String;
    final dataKind = areaMap['data_kind'] as String? ?? 'demo';

    // 3. Węzły (Nodes)
    final nodesRaw = json['nodes'] as List<dynamic>?;
    if (nodesRaw == null || nodesRaw.isEmpty) {
      throw const ValidationError('Brak węzłów w pliku danych ("nodes")');
    }
    final nodes = <RouteNode>[];
    final nodeIds = <String>{};
    for (final n in nodesRaw) {
      final map = n as Map<String, dynamic>;
      final id = map['id'] as String?;
      final lat = (map['lat'] as num?)?.toDouble();
      final lon = (map['lon'] as num?)?.toDouble();
      if (id == null || lat == null || lon == null) {
        throw ValidationError('Niekompletny węzeł: $map');
      }
      if (nodeIds.contains(id)) {
        throw ValidationError('Zduplikowany identyfikator węzła: $id');
      }
      nodeIds.add(id);
      nodes.add(RouteNode(id: id, lat: lat, lon: lon));
    }

    // 4. Miejsca (Places)
    final placesRaw = json['places'] as List<dynamic>? ?? [];
    final places = <Place>[];
    final placeIds = <String>{};
    for (final p in placesRaw) {
      final map = p as Map<String, dynamic>;
      final id = map['id'] as String?;
      final name = map['name'] as String?;
      final nodeId = map['node_id'] as String?;
      if (id == null || name == null || nodeId == null) {
        throw ValidationError('Niekompletne miejsce: $map');
      }
      if (!nodeIds.contains(nodeId)) {
        throw ValidationError(
            'Miejsce $id odwołuje się do nieznanego węzła $nodeId');
      }
      placeIds.add(id);
      places.add(Place(id: id, name: name, nodeId: nodeId));
    }

    // 5. Krawędzie (Edges)
    final edgesRaw = json['edges'] as List<dynamic>? ?? [];
    final edges = <RouteEdge>[];
    final edgeIds = <String>{};
    for (final e in edgesRaw) {
      final map = e as Map<String, dynamic>;
      final id = map['id'] as String?;
      final from = map['from'] as String?;
      final to = map['to'] as String?;
      final dist = (map['distance_m'] as num?)?.toInt();
      final feature = map['feature'] as String? ?? 'path';

      if (id == null || from == null || to == null || dist == null) {
        throw ValidationError('Niekompletna krawędź: $map');
      }
      if (!nodeIds.contains(from)) {
        throw ValidationError(
            'Krawędź $id odwołuje się do nieznanego węzła from: $from');
      }
      if (!nodeIds.contains(to)) {
        throw ValidationError(
            'Krawędź $id odwołuje się do nieznanego węzła to: $to');
      }
      edgeIds.add(id);
      edges.add(RouteEdge(
        id: id,
        from: from,
        to: to,
        distanceM: dist,
        feature: feature,
      ));
    }

    // 6. Obserwacje (Observations) - wyłącznie najwyższy poziom
    final observationsRaw = json['observations'] as List<dynamic>? ?? [];
    final observations = <Observation>[];
    for (final o in observationsRaw) {
      final map = o as Map<String, dynamic>;
      final id = map['id'] as String?;
      final targetType = map['target_type'] as String?;
      final targetId = map['target_id'] as String?;
      final feature = map['feature'] as String?;
      final value = map['value'] as String?;
      final sourceName = map['source_name'] as String?;
      final sourceUrl = map['source_url'] as String?;
      final observedAtStr = map['observed_at'] as String?;
      final verificationStr = map['verification'] as String?;

      if (id == null ||
          targetType == null ||
          targetId == null ||
          feature == null ||
          value == null ||
          sourceName == null ||
          observedAtStr == null ||
          verificationStr == null) {
        throw ValidationError('Niekompletna obserwacja: $map');
      }

      final observedAt = DateTime.tryParse(observedAtStr);
      if (observedAt == null) {
        throw ValidationError(
            'Niepoprawny format daty w obserwacji $id: $observedAtStr');
      }

      if (targetType == 'edge' && !edgeIds.contains(targetId)) {
        throw ValidationError(
            'Obserwacja $id wskazuje na nieistniejącą krawędź: $targetId');
      }
      if (targetType == 'place' && !placeIds.contains(targetId)) {
        throw ValidationError(
            'Obserwacja $id wskazuje na nieistniejące miejsce: $targetId');
      }

      observations.add(Observation(
        id: id,
        targetType: targetType,
        targetId: targetId,
        feature: feature,
        value: value,
        sourceName: sourceName,
        sourceUrl: sourceUrl,
        observedAt: observedAt,
        verification: VerificationStatus.fromString(verificationStr),
      ));
    }

    return AreaGraph(
      areaId: areaId,
      areaName: areaName,
      dataKind: dataKind,
      places: places,
      nodes: nodes,
      edges: edges,
      baseObservations: observations,
    );
  }
}
