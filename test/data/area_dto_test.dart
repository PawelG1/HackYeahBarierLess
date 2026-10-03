import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:krakow_bez_barier/core/errors/app_error.dart';
import 'package:krakow_bez_barier/data/dto/area_dto.dart';
import 'package:krakow_bez_barier/domain/entities/observation.dart';

void main() {
  group('AreaDto - TC-DATA: Walidacja danych i schematu JSON', () {
    test('TC-DATA-01: Prawidłowe parsowanie pliku assets/data/demo_area.json',
        () {
      final file = File('assets/data/demo_area.json');
      expect(file.existsSync(), isTrue);

      final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      final graph = AreaDto.fromJson(json);

      expect(graph.areaId, equals('demo-area'));
      expect(graph.isDemoArea, isTrue);
      expect(graph.nodes.length, equals(13));
      expect(graph.places.length, equals(5));
      expect(graph.edges.length, equals(14));
      expect(graph.baseObservations.length, equals(10));

      // Sprawdzenie obecności Teatru Słowackiego i audytu wejścia
      final slowacki =
          graph.places.firstWhere((p) => p.id == 'p-teatr-slowackiego');
      expect(slowacki.name, contains('Słowackiego'));
      expect(slowacki.nodeId, equals('n-teatr-slowackiego'));

      // Sprawdzenie obserwacji demonstracyjnych schodów na Trasie A
      final tunnelObs = graph.baseObservations
          .firstWhere((o) => o.targetId == 'e-tunel-schody');
      expect(tunnelObs.feature, equals('stairs'));
      expect(tunnelObs.value, equals('present'));
      expect(tunnelObs.verification, equals(VerificationStatus.demo));

      // Sprawdzenie obserwacji stairs: absent na Trasie B
      final plantyObs = graph.baseObservations
          .firstWhere((o) => o.targetId == 'e-planty-slowacki');
      expect(plantyObs.feature, equals('stairs'));
      expect(plantyObs.value, equals('absent'));
      expect(plantyObs.verification, equals(VerificationStatus.demo));
    });

    test(
        'TC-DATA-02: Błąd walidacji przy niewłaściwej wersji schematu (schema_version != 1)',
        () {
      final invalidJson = {
        'schema_version': 2,
        'area': {'id': 'test', 'name': 'Test', 'data_kind': 'demo'},
        'nodes': [
          {'id': 'n1', 'lat': 50.0, 'lon': 19.0}
        ],
        'places': [],
        'edges': [],
        'observations': [],
      };

      expect(
        () => AreaDto.fromJson(invalidJson),
        throwsA(isA<ValidationError>().having(
          (e) => e.message,
          'message',
          contains('Nieobsługiwana wersja schematu: 2'),
        )),
      );
    });

    test('TC-DATA-03: Wykrycie wiszącego węzła (dangling reference) w krawędzi',
        () {
      final invalidJson = {
        'schema_version': 1,
        'area': {'id': 'test', 'name': 'Test', 'data_kind': 'demo'},
        'nodes': [
          {'id': 'n1', 'lat': 50.0, 'lon': 19.0}
        ],
        'places': [],
        'edges': [
          {
            'id': 'e1',
            'from': 'n1',
            'to': 'n-nieistniejacy',
            'distance_m': 50,
            'feature': 'stairs'
          }
        ],
        'observations': [],
      };

      expect(
        () => AreaDto.fromJson(invalidJson),
        throwsA(isA<ValidationError>().having(
          (e) => e.message,
          'message',
          contains('odwołuje się do nieznanego węzła to: n-nieistniejacy'),
        )),
      );
    });

    test('TC-DATA-04: Wykrycie zduplikowanego identyfikatora węzła', () {
      final invalidJson = {
        'schema_version': 1,
        'area': {'id': 'test', 'name': 'Test', 'data_kind': 'demo'},
        'nodes': [
          {'id': 'n1', 'lat': 50.0, 'lon': 19.0},
          {'id': 'n1', 'lat': 50.1, 'lon': 19.1},
        ],
        'places': [],
        'edges': [],
        'observations': [],
      };

      expect(
        () => AreaDto.fromJson(invalidJson),
        throwsA(isA<ValidationError>().having(
          (e) => e.message,
          'message',
          contains('Zduplikowany identyfikator węzła: n1'),
        )),
      );
    });
  });
}
