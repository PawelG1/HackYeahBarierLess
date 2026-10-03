import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:krakow_bez_barier/app.dart';
import 'package:krakow_bez_barier/core/design_system/design_system.dart';
import 'package:krakow_bez_barier/core/di/providers.dart';
import 'package:krakow_bez_barier/domain/entities/observation.dart';
import 'package:krakow_bez_barier/domain/entities/place.dart';
import 'package:krakow_bez_barier/domain/entities/route_edge.dart';
import 'package:krakow_bez_barier/domain/entities/route_node.dart';
import 'package:krakow_bez_barier/domain/entities/route_result.dart';
import 'package:krakow_bez_barier/domain/repositories/observation_repository.dart';
import 'package:krakow_bez_barier/domain/repositories/route_repository.dart';
import 'package:krakow_bez_barier/presentation/screens/place_detail_screen.dart';
import 'package:krakow_bez_barier/presentation/screens/route_comparison_screen.dart';
import 'package:krakow_bez_barier/presentation/screens/route_setup_screen.dart';
import 'package:krakow_bez_barier/presentation/viewmodels/route_comparison_vm.dart';
import 'package:krakow_bez_barier/presentation/viewmodels/route_setup_vm.dart';
import 'package:krakow_bez_barier/presentation/widgets/route_card.dart';
import 'package:krakow_bez_barier/presentation/widgets/route_steps.dart';
import 'package:krakow_bez_barier/presentation/widgets/source_row.dart';

class FakeHttpClient extends Fake implements HttpClient {
  @override
  Future<HttpClientRequest> getUrl(Uri url) async => FakeHttpClientRequest();
  @override
  Future<HttpClientRequest> openUrl(String method, Uri url) async =>
      FakeHttpClientRequest();
  @override
  void close({bool force = false}) {}
}

class FakeHttpClientRequest extends Fake implements HttpClientRequest {
  @override
  final HttpHeaders headers = FakeHttpHeaders();
  @override
  bool followRedirects = true;
  @override
  int maxRedirects = 5;
  @override
  int contentLength = 0;
  @override
  Future<HttpClientResponse> close() async => FakeHttpClientResponse();
}

class FakeHttpHeaders extends Fake implements HttpHeaders {
  @override
  void set(String name, Object value, {bool preserveHeaderCase = false}) {}
  @override
  void add(String name, Object value, {bool preserveHeaderCase = false}) {}
  @override
  void remove(String name, Object value) {}
  @override
  void removeAll(String name) {}
}

class FakeHttpClientResponse extends Fake implements HttpClientResponse {
  @override
  int get statusCode => 200;
  @override
  int get contentLength => 0;
  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;
  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return const Stream<List<int>>.empty().listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}

class FakeHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) => FakeHttpClient();
}

class DemoTestRouteRepository implements RouteRepository {
  @override
  Future<AreaGraph> loadArea() async {
    return AreaGraph(
      areaId: 'demo-area',
      areaName: 'Obszar demonstracyjny Kraków',
      dataKind: 'demo',
      places: const [
        Place(
          id: 'p-teatr-slowackiego',
          name: 'Teatr im. Juliusza Słowackiego w Krakowie',
          nodeId: 'n-teatr',
        ),
      ],
      nodes: const [
        RouteNode(id: 'n-dworzec', lat: 50.0665, lon: 19.9482),
        RouteNode(id: 'n-tunel', lat: 50.0655, lon: 19.9460),
        RouteNode(id: 'n-planty', lat: 50.0645, lon: 19.9440),
        RouteNode(id: 'n-teatr', lat: 50.0638, lon: 19.9425),
      ],
      edges: const [
        RouteEdge(
          id: 'e-tunel-schody',
          from: 'n-dworzec',
          to: 'n-tunel',
          distanceM: 85,
          feature: 'stairs',
        ),
        RouteEdge(
          id: 'e-tunel-teatr',
          from: 'n-tunel',
          to: 'n-teatr',
          distanceM: 100,
          feature: 'flat_pavement',
        ),
        RouteEdge(
          id: 'e-planty-naziemne',
          from: 'n-dworzec',
          to: 'n-planty',
          distanceM: 120,
          feature: 'curb_ramp',
        ),
        RouteEdge(
          id: 'e-planty-teatr',
          from: 'n-planty',
          to: 'n-teatr',
          distanceM: 150,
          feature: 'asphalt_path',
        ),
      ],
      baseObservations: [
        Observation(
          id: 'o-tunel-schody',
          targetType: 'edge',
          targetId: 'e-tunel-schody',
          feature: 'stairs',
          value: 'present',
          sourceName: 'Audyt ZDMK',
          observedAt: DateTime.now().subtract(const Duration(days: 10)),
          verification: VerificationStatus.demo,
        ),
        Observation(
          id: 'o-planty-stairs-absent',
          targetType: 'edge',
          targetId: 'e-planty-teatr',
          feature: 'stairs',
          value: 'absent',
          sourceName: 'Zarząd Zieleni Miejskiej Kraków',
          observedAt: DateTime.now().subtract(const Duration(days: 15)),
          verification: VerificationStatus.demo,
        ),
        Observation(
          id: 'o-teatr-wejscie-rampa',
          targetType: 'place',
          targetId: 'p-teatr-slowackiego',
          feature: 'wheelchair_ramp',
          value: 'present',
          sourceName: 'Audyt Dostępności Teatru',
          observedAt: DateTime.now().subtract(const Duration(days: 5)),
          verification: VerificationStatus.confirmed,
        ),
      ],
    );
  }
}

class DemoTestObservationRepository implements ObservationRepository {
  final List<Observation> _local = [];
  bool _avoid = true;

  @override
  Future<List<Observation>> getLocalObservations() async =>
      List.unmodifiable(_local);

  @override
  Future<void> addObservation(Observation observation) async {
    _local.add(observation);
  }

  @override
  Future<void> clearDemoData() async {
    _local.clear();
  }

  @override
  Future<bool> getAvoidStairsPreference() async => _avoid;

  @override
  Future<void> setAvoidStairsPreference(bool avoid) async {
    _avoid = avoid;
  }
}

void _noop() {}

void main() {
  setUpAll(() {
    HttpOverrides.global = FakeHttpOverrides();
  });

  group('RouteSetupVm', () {
    test('TC-VM-01: Inicjalizacja pobiera graf i preferencje', () async {
      final routeRepo = DemoTestRouteRepository();
      final obsRepo = DemoTestObservationRepository();
      final container = ProviderContainer(
        overrides: [
          routeRepositoryProvider.overrideWithValue(routeRepo),
          observationRepositoryProvider.overrideWithValue(obsRepo),
        ],
      );

      expect(container.read(routeSetupVmProvider).isLoading, isTrue);
      await Future.delayed(const Duration(milliseconds: 50));

      final state = container.read(routeSetupVmProvider);
      expect(state.isLoading, isFalse);
      expect(state.areaGraph, isNotNull);
      expect(state.selectedStartNodeId, equals('n-dworzec'));
      expect(state.selectedDestinationPlaceId, equals('p-teatr-slowackiego'));
    });

    test('TC-VM-02: Zmiana preferencji unikaj schodów', () async {
      final routeRepo = DemoTestRouteRepository();
      final obsRepo = DemoTestObservationRepository();
      final container = ProviderContainer(
        overrides: [
          routeRepositoryProvider.overrideWithValue(routeRepo),
          observationRepositoryProvider.overrideWithValue(obsRepo),
        ],
      );

      final vm = container.read(routeSetupVmProvider.notifier);
      await Future.delayed(const Duration(milliseconds: 50));

      await vm.toggleAvoidStairs(false);
      expect(container.read(routeSetupVmProvider).avoidStairs, isFalse);

      await vm.toggleAvoidStairs(true);
      expect(container.read(routeSetupVmProvider).avoidStairs, isTrue);
    });
  });

  group('TC-UI: Responsywność, a11y i Skalowanie Czcionki', () {
    testWidgets('RouteCard renders without error at 200% text scale',
        (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      const route = RouteResult(
        id: 'r1',
        title: 'Trasa A: Przez tunel pod dworcem (wariant najkrótszy)',
        status: RouteStatus.rejected,
        totalDistanceM: 100,
        steps: [],
        reasons: ['Schody na odcinku e-tunel-schody'],
        isDemoData: true,
        unresolvedBarriersCount: 1,
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const MediaQuery(
            data: MediaQueryData(
              size: Size(360, 800),
              textScaler: TextScaler.linear(2.0),
            ),
            child: Scaffold(
              body: SingleChildScrollView(
                child: RouteCard(
                  route: route,
                  isSelected: true,
                  onTap: _noop,
                ),
              ),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.textContaining('Trasa A'), findsOneWidget);
    });

    testWidgets('SourceRow renders without RenderFlex overflow at 200% text scale',
        (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final obs = Observation(
        id: 'o1',
        targetType: 'edge',
        targetId: 'e1',
        feature: 'stairs',
        value: 'absent',
        sourceName: 'Zarząd Dróg Miasta Krakowa Audyt Dostępności',
        sourceUrl: 'https://www.krakow.pl/dostepnosc',
        observedAt: DateTime(2026, 9, 20),
        verification: VerificationStatus.demo,
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: MediaQuery(
            data: const MediaQueryData(
              size: Size(360, 800),
              textScaler: TextScaler.linear(2.0),
            ),
            child: Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SourceRow(observation: obs),
              ),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('RouteSteps renders without RenderFlex overflow at 200% text scale',
        (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final route = RouteResult(
        id: 'r1',
        title: 'Trasa A',
        status: RouteStatus.rejected,
        totalDistanceM: 85,
        steps: [
          RouteStep(
            edge: const RouteEdge(
              id: 'e1',
              from: 'n-dworzec',
              to: 'n-tunel',
              distanceM: 85,
              feature: 'stairs',
            ),
            observations: [
              Observation(
                id: 'o1',
                targetType: 'edge',
                targetId: 'e1',
                feature: 'stairs',
                value: 'present',
                sourceName: 'Audyt Miejski',
                observedAt: DateTime(2026, 9, 20),
                verification: VerificationStatus.demo,
              ),
            ],
            hasConflict: true,
            isExcludedBarrier: true,
            barrierReason: 'Schody bez windy na odcinku',
          ),
        ],
        reasons: const ['Schody'],
        isDemoData: true,
        unresolvedBarriersCount: 1,
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: MediaQuery(
            data: const MediaQueryData(
              size: Size(360, 800),
              textScaler: TextScaler.linear(2.0),
            ),
            child: Scaffold(
              body: SingleChildScrollView(
                child: RouteSteps(
                  route: route,
                  onReportConflict: (id) {},
                ),
              ),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets(
        'TC-UI-01: Responsywny układ (Telefon < 600 px vs Tablet >= 600 px)',
        (tester) async {
      final routeRepo = DemoTestRouteRepository();
      final obsRepo = DemoTestObservationRepository();

      // 1. Widok telefonu (< 600 px): pojedyncza kolumna z SegmentedButton
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final containerPhone = ProviderContainer(
        overrides: [
          routeRepositoryProvider.overrideWithValue(routeRepo),
          observationRepositoryProvider.overrideWithValue(obsRepo),
        ],
      );

      await containerPhone
          .read(routeComparisonVmProvider.notifier)
          .evaluate(
            startNodeId: 'n-dworzec',
            destinationPlaceId: 'p-teatr-slowackiego',
            avoidStairs: true,
          );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: containerPhone,
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const RouteComparisonScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final texts = find
          .byType(Text)
          .evaluate()
          .map((e) => (e.widget as Text).data ?? (e.widget as Text).textSpan?.toPlainText())
          .toList();
      // ignore: avoid_print
      print('DEBUG TC-UI-01 texts on screen: $texts');

      // Na telefonie jest przełącznik SegmentedButton (Tekst vs Mapa)
      final segmentedFinder = find.byType(SegmentedButton<int>);
      await tester.scrollUntilVisible(segmentedFinder, 100);
      expect(segmentedFinder, findsOneWidget);
      expect(find.byType(VerticalDivider), findsNothing);

      // 2. Widok tabletu (>= 600 px): dwa panele obok siebie z VerticalDivider
      tester.view.physicalSize = const Size(800, 800);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: containerPhone,
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const RouteComparisonScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Na tablecie jest VerticalDivider oddzielający lewy panel od prawego
      expect(find.byType(VerticalDivider), findsOneWidget);
    });

    testWidgets(
        'TC-UI-02: Dostępność tekstowa i zachowanie w widoku krok po kroku',
        (tester) async {
      final routeRepo = DemoTestRouteRepository();
      final obsRepo = DemoTestObservationRepository();
      final container = ProviderContainer(
        overrides: [
          routeRepositoryProvider.overrideWithValue(routeRepo),
          observationRepositoryProvider.overrideWithValue(obsRepo),
        ],
      );

      await container
          .read(routeComparisonVmProvider.notifier)
          .evaluate(
            startNodeId: 'n-dworzec',
            destinationPlaceId: 'p-teatr-slowackiego',
            avoidStairs: true,
          );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const RouteComparisonScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Sprawdzenie, że kroki są w pełni dostępne w trybie tekstowym
      expect(find.byType(RouteSteps), findsOneWidget);
      expect(find.textContaining('Długość odcinka:'), findsWidgets);
    });

    testWidgets('TC-UI-03: Audyt Semantics na ekranie głównym i formularzu',
        (tester) async {
      final routeRepo = DemoTestRouteRepository();
      final obsRepo = DemoTestObservationRepository();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            routeRepositoryProvider.overrideWithValue(routeRepo),
            observationRepositoryProvider.overrideWithValue(obsRepo),
          ],
          child: const MaterialApp(
            home: RouteSetupScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Semantics dla przełącznika i przycisków w drzewie widgetów
      expect(
        find.byWidgetPredicate((w) =>
            w is Semantics &&
            w.properties.label == 'Przełącznik: Unikam schodów'),
        findsOneWidget,
      );
      expect(
        find.byWidgetPredicate((w) =>
            w is Semantics &&
            w.properties.label == 'Przycisk: Porównaj warianty trasy'),
        findsOneWidget,
      );
    });
  });

  group('TC-JURY-01: Kompletna ścieżka demonstracyjna z transparentnością barier', () {
    testWidgets('Pełny scenariusz jurorski (kroki 1 do 7)', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final routeRepo = DemoTestRouteRepository();
      final obsRepo = DemoTestObservationRepository();

      // Krok 1: Uruchomienie aplikacji z demonstracyjnymi danymi
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            routeRepositoryProvider.overrideWithValue(routeRepo),
            observationRepositoryProvider.overrideWithValue(obsRepo),
          ],
          child: const KrakowBezBarierApp(),
        ),
      );
      await tester.pumpAndSettle();

      final attractionBtn = find.text('Teatr im. Juliusza Słowackiego');
      expect(attractionBtn, findsOneWidget);
      await tester.tap(attractionBtn);
      await tester.pumpAndSettle();

      expect(find.text('Unikam schodów'), findsOneWidget);


      // Krok 2: Kliknięcie „Porównaj warianty tras”
      final compareBtn = find.text('Porównaj warianty tras');
      expect(compareBtn, findsOneWidget);
      await tester.ensureVisible(compareBtn);
      await tester.tap(compareBtn);
      await tester.pumpAndSettle();

      // Weryfikacja ekranu porównania tras
      expect(find.text('Porównanie tras'), findsOneWidget);
      expect(find.text('ODRZUCONA'), findsOneWidget);
      expect(find.text('NIEPEWNA'), findsWidgets);

      // Krok 3: Otwarcie szczegółów miejsca docelowego
      final placeDetailsBtn =
          find.text('Sprawdź dostępność wejścia i spektakle');
      await tester.scrollUntilVisible(
        placeDetailsBtn,
        150,
        scrollable: find.byType(Scrollable).first,
      );
      expect(placeDetailsBtn, findsOneWidget);
      await tester.tap(placeDetailsBtn);
      await tester.pumpAndSettle();

      // Weryfikacja ekranu szczegółów obiektu
      expect(find.byType(PlaceDetailScreen), findsOneWidget);
      expect(find.textContaining('Audyt dostępności wejścia'), findsOneWidget);
      expect(find.text('Cecha: wheelchair_ramp'), findsOneWidget);
      expect(find.text('Wartość: present'), findsOneWidget);
      expect(find.text('Potwierdzone źródło'), findsOneWidget);

      // Powrót do porównania tras
      Navigator.of(tester.element(find.byType(PlaceDetailScreen))).pop();
      await tester.pumpAndSettle();
      expect(find.byType(RouteComparisonScreen), findsOneWidget);

      // Krok 4 & 5: Zgłoszenie sprzeczności
      // Przewijamy w górę
      await tester.fling(find.byType(Scrollable).first, const Offset(0, 500), 1000);
      await tester.pumpAndSettle();
      final routeCards = find.byType(RouteCard);
      expect(routeCards, findsWidgets);
      await tester.tap(routeCards.first);
      await tester.pumpAndSettle();

      // Przewijamy w dół, aby zobaczyć przyciski zgłoszenia
      await tester.fling(find.byType(Scrollable).first, const Offset(0, -500), 1000);
      await tester.pumpAndSettle();
      
      final reportBtn = find.text('Zgłoś barierę / sprzeczność').first;
      expect(reportBtn, findsOneWidget);
      await tester.tap(reportBtn);
      await tester.pumpAndSettle();

      // Dialog zgłoszenia
      expect(find.text('Zgłoś barierę na odcinku'), findsOneWidget);
      final saveReportBtn = find.text('Zapisz zgłoszenie');
      await tester.tap(saveReportBtn);
      await tester.pumpAndSettle();

      // Sprawdzenie, że obserwacja została dodana do repozytorium
      final localObs = await obsRepo.getLocalObservations();
      expect(localObs.isNotEmpty, isTrue);

      // Krok 6: Krok po kroku w trybie tekstowym działa
      expect(find.byType(RouteSteps), findsOneWidget);

      // Krok 7: Czyszczenie danych demonstracyjnych
      final restoreBtn = find.byTooltip('Wyczyść dane demonstracyjne');
      expect(restoreBtn, findsOneWidget);
      await tester.tap(restoreBtn);
      await tester.pumpAndSettle();

      // Weryfikacja, że lokalne zgłoszenia zostały wyczyszczone
      final clearedObs = await obsRepo.getLocalObservations();
      expect(clearedObs.isEmpty, isTrue);
    });
  });
}
