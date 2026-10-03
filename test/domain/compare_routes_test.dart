import 'package:flutter_test/flutter_test.dart';
import 'package:krakow_bez_barier/domain/entities/observation.dart';
import 'package:krakow_bez_barier/domain/entities/place.dart';
import 'package:krakow_bez_barier/domain/entities/route_edge.dart';
import 'package:krakow_bez_barier/domain/entities/route_node.dart';
import 'package:krakow_bez_barier/domain/entities/route_result.dart';
import 'package:krakow_bez_barier/domain/repositories/observation_repository.dart';
import 'package:krakow_bez_barier/domain/repositories/route_repository.dart';
import 'package:krakow_bez_barier/domain/usecases/compare_routes.dart';

class FakeRouteRepository implements RouteRepository {
  @override
  Future<AreaGraph> loadArea() async {
    return AreaGraph(
      areaId: 'test-area',
      areaName: 'Test Area',
      dataKind: 'demo',
      places: [
        const Place(id: 'p-dest', name: 'Cel', nodeId: 'n-dest'),
      ],
      nodes: [
        const RouteNode(id: 'n-start', lat: 0, lon: 0),
        const RouteNode(id: 'n-mid', lat: 1, lon: 1),
        const RouteNode(id: 'n-dest', lat: 2, lon: 2),
      ],
      edges: [
        const RouteEdge(
            id: 'e-1',
            from: 'n-start',
            to: 'n-mid',
            distanceM: 10,
            feature: 'path'),
        const RouteEdge(
            id: 'e-2',
            from: 'n-mid',
            to: 'n-dest',
            distanceM: 10,
            feature: 'path'),
        const RouteEdge(
            id: 'e-direct',
            from: 'n-start',
            to: 'n-dest',
            distanceM: 15,
            feature: 'stairs'),
      ],
      baseObservations: [
        Observation(
          id: 'o-1',
          targetType: 'edge',
          targetId: 'e-1',
          feature: 'surface',
          value: 'smooth',
          sourceName: 'Base',
          observedAt: DateTime(2023, 1, 1), // Old observation
          verification: VerificationStatus.demo,
        ),
      ],
    );
  }
}

class FakeObservationRepository implements ObservationRepository {
  final List<Observation> _local = [];
  bool _avoidStairs = true;

  @override
  Future<void> addObservation(Observation observation) async {
    _local.add(observation);
  }

  @override
  Future<void> clearDemoData() async {
    _local.clear();
  }

  @override
  Future<bool> getAvoidStairsPreference() async => _avoidStairs;

  @override
  Future<List<Observation>> getLocalObservations() async => _local;

  @override
  Future<void> setAvoidStairsPreference(bool avoid) async {
    _avoidStairs = avoid;
  }
}

void main() {
  group('CompareRoutes UseCase', () {
    late FakeRouteRepository routeRepo;
    late FakeObservationRepository obsRepo;
    late CompareRoutes useCase;

    setUp(() {
      routeRepo = FakeRouteRepository();
      obsRepo = FakeObservationRepository();
      useCase = CompareRoutes(
        routeRepository: routeRepo,
        observationRepository: obsRepo,
      );
    });

    test(
        'TC-DOMAIN-01: Znalezienie tras i uwzględnienie wieku obserwacji (expired)',
        () async {
      final results = await useCase(
        startNodeId: 'n-start',
        destinationPlaceId: 'p-dest',
        avoidStairs: false,
        referenceDate:
            DateTime(2023, 6, 1), // More than 90 days after base observation
      );

      expect(results.length, 2); // path 1: e-1 -> e-2, path 2: e-direct
      final indirectPath = results.firstWhere((r) => r.steps.length == 2);

      // Old observation on e-1 should trigger uncertain status
      expect(indirectPath.status, RouteStatus.uncertain);
      expect(indirectPath.reasons.any((r) => r.contains('Nieaktualne dane')),
          isTrue);
    });

    test('TC-DOMAIN-02: Odrzucenie trasy przez preferencje avoidStairs',
        () async {
      final results = await useCase(
        startNodeId: 'n-start',
        destinationPlaceId: 'p-dest',
        avoidStairs: true,
        referenceDate: DateTime(2023, 1, 10),
      );

      final directPath = results.firstWhere((r) => r.steps.length == 1);
      expect(directPath.status, RouteStatus.rejected);
      expect(directPath.reasons.any((r) => r.contains('Schody')), isTrue);
    });

    test('TC-DOMAIN-03: Konflikt lokalnej obserwacji', () async {
      // Add a conflicting observation on e-1
      await obsRepo.addObservation(Observation(
        id: 'local-1',
        targetType: 'edge',
        targetId: 'e-1',
        feature: 'surface',
        value: 'cobblestone',
        sourceName: 'User',
        observedAt: DateTime(2023, 1, 15),
        verification: VerificationStatus.community_unverified,
      ));

      final results = await useCase(
        startNodeId: 'n-start',
        destinationPlaceId: 'p-dest',
        avoidStairs: false,
        referenceDate: DateTime(2023, 1, 16),
      );

      final indirectPath = results.firstWhere((r) => r.steps.length == 2);
      expect(indirectPath.status, RouteStatus.uncertain);
      expect(indirectPath.reasons.any((r) => r.contains('Konflikt obserwacji')),
          isTrue);
    });
  });
}
