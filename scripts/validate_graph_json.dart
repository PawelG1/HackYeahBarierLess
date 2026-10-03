// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';

/// Narzędzie CLI do walidacji spójności danych demonstracyjnych: demo_area.json.
/// Uruchomienie: `dart run scripts/validate_graph_json.dart`
void main(List<String> args) {
  final filePath = args.isNotEmpty ? args[0] : 'assets/data/demo_area.json';
  final file = File(filePath);

  if (!file.existsSync()) {
    stderr.writeln('BŁĄD: Plik danych nie istnieje pod ścieżką: $filePath');
    exit(1);
  }

  print('🔍 Walidacja pliku danych: $filePath');
  try {
    final content = file.readAsStringSync();
    final Map<String, dynamic> json = jsonDecode(content);

    // 1. Sprawdzenie nagłówka i schematu
    final schemaVersion = json['schema_version'];
    if (schemaVersion != 1) {
      throw FormatException(
          'Pole schema_version musi wynosić 1 (odczytano: $schemaVersion)');
    }
    final area = json['area'] as Map<String, dynamic>?;
    if (area == null ||
        !area.containsKey('id') ||
        !area.containsKey('data_kind')) {
      throw const FormatException(
          'Brak poprawnego obiektu area z polami id i data_kind');
    }

    // 2. Węzły
    final nodesList = json['nodes'] as List<dynamic>? ?? [];
    final nodeIds = <String>{};
    for (final node in nodesList) {
      final id = node['id'] as String?;
      final lat = node['lat'];
      final lon = node['lon'];
      if (id == null || id.isEmpty || lat == null || lon == null) {
        throw FormatException(
            'Węzeł nie posiada kompletnych danych (id, lat, lon): $node');
      }
      if (nodeIds.contains(id)) {
        throw FormatException('Zduplikowany identyfikator węzła: $id');
      }
      nodeIds.add(id);
    }
    print('✅ Węzły poprawne: ${nodeIds.length} wierzchołków');

    // 3. Miejsca (Places)
    final placesList = json['places'] as List<dynamic>? ?? [];
    final placeIds = <String>{};
    for (final place in placesList) {
      final placeId = place['id'] as String?;
      final nodeId = place['node_id'] as String?;
      if (placeId == null || nodeId == null) {
        throw FormatException(
            'Miejsce $place ma brakujące dane id lub node_id');
      }
      if (!nodeIds.contains(nodeId)) {
        throw FormatException(
            'Miejsce $placeId odwołuje się do nieistniejącego node_id: $nodeId');
      }
      placeIds.add(placeId);
    }
    print('✅ Miejsca (POI) poprawne: ${placesList.length} obiektów');

    // 4. Krawędzie (Edges)
    final edgesList = json['edges'] as List<dynamic>? ?? [];
    final edgeIds = <String>{};
    for (final edge in edgesList) {
      final edgeId = edge['id'] as String?;
      final from = edge['from'] as String?;
      final to = edge['to'] as String?;
      final dist = edge['distance_m'];

      if (edgeId == null || from == null || to == null || dist == null) {
        throw FormatException(
            'Krawędź $edge ma niekompletne dane (id, from, to, distance_m)');
      }
      if (!nodeIds.contains(from)) {
        throw FormatException(
            'Krawędź $edgeId odwołuje się do nieznanego węzła from: $from');
      }
      if (!nodeIds.contains(to)) {
        throw FormatException(
            'Krawędź $edgeId odwołuje się do nieznanego węzła to: $to');
      }
      edgeIds.add(edgeId);
    }
    print(
        '✅ Krawędzie poprawne: ${edgesList.length} odcinków ze spójnymi referencjami');

    // 5. Obserwacje (Top-level Observations)
    final observationsList = json['observations'] as List<dynamic>? ?? [];
    final allowedStatuses = {
      'confirmed',
      'community_unverified',
      'conflict',
      'missing',
      'demo'
    };
    for (final obs in observationsList) {
      final obsId = obs['id'] as String?;
      final targetType = obs['target_type'] as String?;
      final targetId = obs['target_id'] as String?;
      final verification = obs['verification'] as String?;
      final observedAt = obs['observed_at'] as String?;

      if (obsId == null ||
          targetType == null ||
          targetId == null ||
          verification == null) {
        throw FormatException('Obserwacja $obs ma brakujące pola kluczowe');
      }
      if (!allowedStatuses.contains(verification)) {
        throw FormatException(
            'Nieprawidłowy status weryfikacji: "$verification"');
      }
      if (observedAt != null && DateTime.tryParse(observedAt) == null) {
        throw FormatException(
            'Niepoprawny format daty observed_at: "$observedAt"');
      }

      if (targetType == 'edge' && !edgeIds.contains(targetId)) {
        throw FormatException(
            'Obserwacja $obsId wskazuje na nieistniejącą krawędź target_id: $targetId');
      }
      if (targetType == 'place' && !placeIds.contains(targetId)) {
        throw FormatException(
            'Obserwacja $obsId wskazuje na nieistniejące miejsce target_id: $targetId');
      }
    }
    print(
        '✅ Obserwacje najwyższego poziomu poprawne: ${observationsList.length} wpisów');

    print(
        '\n🎉 SUKCES: Plik $filePath spełnia w 100% zaktualizowany kontrakt danych HackYeah 2026!');
  } catch (e, stack) {
    stderr.writeln('❌ BŁĄD WALIDACJI: $e');
    stderr.writeln(stack);
    exit(1);
  }
}
