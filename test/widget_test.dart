import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:krakow_bez_barier/app.dart';
import 'package:krakow_bez_barier/core/di/providers.dart';
import 'package:krakow_bez_barier/domain/entities/observation.dart';
import 'package:krakow_bez_barier/domain/entities/place.dart';
import 'package:krakow_bez_barier/domain/entities/route_node.dart';
import 'package:krakow_bez_barier/domain/repositories/observation_repository.dart';
import 'package:krakow_bez_barier/domain/repositories/route_repository.dart';

class _MockRouteRepository implements RouteRepository {
  @override
  Future<AreaGraph> loadArea() async {
    return const AreaGraph(
      areaId: 'test',
      areaName: 'Test Area',
      dataKind: 'demo',
      places: [Place(id: 'p1', name: 'Place 1', nodeId: 'n1')],
      nodes: [RouteNode(id: 'n1', lat: 10, lon: 20)],
      edges: [],
      baseObservations: [],
    );
  }
}

class _MockObservationRepository implements ObservationRepository {
  @override
  Future<List<Observation>> getLocalObservations() async => [];
  @override
  Future<void> addObservation(Observation observation) async {}
  @override
  Future<void> clearDemoData() async {}
  @override
  Future<bool> getAvoidStairsPreference() async => true;
  @override
  Future<void> setAvoidStairsPreference(bool avoid) async {}
}

void main() {
  testWidgets('KrakowBezBarierApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          routeRepositoryProvider.overrideWithValue(_MockRouteRepository()),
          observationRepositoryProvider
              .overrideWithValue(_MockObservationRepository()),
        ],
        child: const KrakowBezBarierApp(),
      ),
    );
    expect(find.byType(KrakowBezBarierApp), findsOneWidget);
  });
}
