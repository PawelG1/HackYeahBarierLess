import '../entities/observation.dart';
import '../entities/route_edge.dart';
import '../entities/route_result.dart';
import '../repositories/observation_repository.dart';
import '../repositories/route_repository.dart';

/// Przypadek użycia wyznaczający i porównujący alternatywne trasy w grafie.
class CompareRoutes {
  /// Demonstracyjny próg dezaktualizacji danych w dniach (zgodnie ze specyfikacją).
  static const int maxObservationAgeDays = 90;

  final RouteRepository routeRepository;
  final ObservationRepository observationRepository;

  const CompareRoutes({
    required this.routeRepository,
    required this.observationRepository,
  });

  Future<List<RouteResult>> call({
    required String startNodeId,
    required String destinationPlaceId,
    required bool avoidStairs,
    DateTime? referenceDate,
  }) async {
    final now = referenceDate ?? DateTime.now();

    // 1. Pobranie danych bazowych i lokalnej nakładki
    final areaGraph = await routeRepository.loadArea();
    final localObservations =
        await observationRepository.getLocalObservations();

    // 2. Znalezienie węzła docelowego miejsca
    final place = areaGraph.places.firstWhere(
      (p) => p.id == destinationPlaceId,
      orElse: () =>
          throw ArgumentError('Nie znaleziono miejsca: $destinationPlaceId'),
    );
    final destNodeId = place.nodeId;

    // 3. Połączenie obserwacji bazowych z lokalnymi
    final allObservations = <Observation>[
      ...areaGraph.baseObservations,
      ...localObservations,
    ];

    // 4. Znalezienie wszystkich prostych ścieżek bez cykli (DFS)
    final allPaths = _findAllSimplePaths(
      startNodeId: startNodeId,
      destNodeId: destNodeId,
      edges: areaGraph.edges,
    );

    if (allPaths.isEmpty) {
      return [];
    }

    // 5. Ewaluacja każdej ścieżki
    final evaluatedRoutes = <RouteResult>[];
    for (int i = 0; i < allPaths.length; i++) {
      final pathEdges = allPaths[i];
      final route = _evaluatePath(
        routeIndex: i,
        edges: pathEdges,
        observations: allObservations,
        destinationPlaceId: destinationPlaceId,
        avoidStairs: avoidStairs,
        now: now,
        isDemoArea: areaGraph.isDemoArea,
      );
      evaluatedRoutes.add(route);
    }

    // 6. Deterministyczne sortowanie tras:
    // 1) nieodrzucone przed odrzuconymi
    // 2) mniej nierozstrzygniętych barier
    // 3) krótszy dystans
    evaluatedRoutes.sort((a, b) {
      final aRejected = a.status == RouteStatus.rejected ? 1 : 0;
      final bRejected = b.status == RouteStatus.rejected ? 1 : 0;
      if (aRejected != bRejected) return aRejected.compareTo(bRejected);

      if (a.unresolvedBarriersCount != b.unresolvedBarriersCount) {
        return a.unresolvedBarriersCount.compareTo(b.unresolvedBarriersCount);
      }

      return a.totalDistanceM.compareTo(b.totalDistanceM);
    });

    // Zwracamy alternatywy (maksymalnie 3 pierwsze warianty z etykietami A, B, C)
    final letterPrefixes = ['A', 'B', 'C', 'D', 'E'];
    return evaluatedRoutes.asMap().entries.map((entry) {
      final idx = entry.key;
      final r = entry.value;
      final label =
          idx < letterPrefixes.length ? letterPrefixes[idx] : '${idx + 1}';
      return RouteResult(
        id: r.id,
        title: 'Trasa $label (${r.totalDistanceM} m)',
        status: r.status,
        totalDistanceM: r.totalDistanceM,
        steps: r.steps,
        reasons: r.reasons,
        isDemoData: r.isDemoData,
        unresolvedBarriersCount: r.unresolvedBarriersCount,
      );
    }).toList();
  }

  /// Ewaluacja pojedynczej ścieżki złożonej z krawędzi.
  RouteResult _evaluatePath({
    required int routeIndex,
    required List<RouteEdge> edges,
    required List<Observation> observations,
    required String destinationPlaceId,
    required bool avoidStairs,
    required DateTime now,
    required bool isDemoArea,
  }) {
    final steps = <RouteStep>[];
    final reasons = <String>[];
    bool isRejected = false;
    bool hasAnyConflict = false;
    bool hasMissingOrExpired = false;
    bool hasDemoData = isDemoArea;
    int unresolvedBarriers = 0;
    int totalDistance = 0;

    for (final edge in edges) {
      totalDistance += edge.distanceM;

      // Obserwacje dla danego odcinka
      final edgeObs = observations
          .where((o) => o.targetType == 'edge' && o.targetId == edge.id)
          .toList();

      if (edgeObs.any((o) => o.verification == VerificationStatus.demo)) {
        hasDemoData = true;
      }

      // Sprawdzenie konfliktu dla cech
      final featureValues = <String, Set<String>>{};
      for (final obs in edgeObs) {
        featureValues.putIfAbsent(obs.feature, () => {}).add(obs.value);
      }

      bool edgeHasConflict = false;
      for (final entry in featureValues.entries) {
        if (entry.value.length > 1) {
          edgeHasConflict = true;
          hasAnyConflict = true;
          unresolvedBarriers++;
          final sources = edgeObs
              .where((o) => o.feature == entry.key)
              .map((o) =>
                  '${o.value} (${o.sourceName}, ${o.observedAt.toIso8601String().substring(0, 10)})')
              .join(' vs ');
          reasons.add(
              'Konflikt obserwacji cechy "${entry.key}" na odcinku ${edge.id}: $sources');
        }
      }

      // Sprawdzenie schodów i wykluczeń
      bool isExcludedBarrier = false;
      String? barrierReason;

      final stairsObs = edgeObs.where((o) => o.feature == 'stairs').toList();
      final hasStairsPresent = stairsObs.any((o) => o.value == 'present');

      if (avoidStairs && (hasStairsPresent || edge.feature == 'stairs')) {
        final obs = stairsObs.firstWhere(
          (o) => o.value == 'present',
          orElse: () => edgeObs.isNotEmpty
              ? edgeObs.first
              : Observation(
                  id: 'virtual-${edge.id}',
                  targetType: 'edge',
                  targetId: edge.id,
                  feature: 'stairs',
                  value: 'present',
                  sourceName: 'Geometria bazowa',
                  observedAt: now,
                  verification: VerificationStatus.demo,
                ),
        );

        isExcludedBarrier = true;
        isRejected = true;
        unresolvedBarriers++;
        barrierReason =
            'Schody na odcinku ${edge.id} (źródło: ${obs.sourceName}, data: ${obs.observedAt.toIso8601String().substring(0, 10)}, status: ${obs.verification.name})';
        reasons.add(barrierReason);
      }

      // Sprawdzenie wieku informacji (> 90 dni) lub braku obserwacji
      if (edgeObs.isEmpty) {
        hasMissingOrExpired = true;
        unresolvedBarriers++;
        reasons.add('Brak danych o barierach na odcinku ${edge.id}');
      } else {
        final allExpired = edgeObs.every((o) => o.isExpired(
            thresholdDays: maxObservationAgeDays, referenceDate: now));
        if (allExpired) {
          hasMissingOrExpired = true;
          unresolvedBarriers++;
          reasons.add(
              'Nieaktualne dane (> $maxObservationAgeDays dni) na odcinku ${edge.id}');
        }
      }

      steps.add(RouteStep(
        edge: edge,
        observations: edgeObs,
        hasConflict: edgeHasConflict,
        isExcludedBarrier: isExcludedBarrier,
        barrierReason: barrierReason,
      ));
    }

    // Sprawdzenie wejścia do miejsca docelowego
    final placeObs = observations
        .where(
            (o) => o.targetType == 'place' && o.targetId == destinationPlaceId)
        .toList();
    if (placeObs.any((o) => o.verification == VerificationStatus.demo)) {
      hasDemoData = true;
    }

    // Wyznaczenie ostatecznego statusu trasy
    final RouteStatus status;
    if (isRejected) {
      status = RouteStatus.rejected;
    } else if (hasAnyConflict || hasMissingOrExpired || hasDemoData) {
      status = RouteStatus.uncertain;
    } else {
      status = RouteStatus.confirmed;
    }

    return RouteResult(
      id: 'route-$routeIndex',
      title: 'Wariant ${routeIndex + 1}',
      status: status,
      totalDistanceM: totalDistance,
      steps: steps,
      reasons: reasons,
      isDemoData: hasDemoData,
      unresolvedBarriersCount: unresolvedBarriers,
    );
  }

  /// Wyszukuje wszystkie proste ścieżki w grafie bez cykli.
  List<List<RouteEdge>> _findAllSimplePaths({
    required String startNodeId,
    required String destNodeId,
    required List<RouteEdge> edges,
  }) {
    final results = <List<RouteEdge>>[];
    final visitedNodes = <String>{startNodeId};
    final currentPath = <RouteEdge>[];

    void dfs(String currentNodeId) {
      if (currentNodeId == destNodeId) {
        results.add(List<RouteEdge>.from(currentPath));
        return;
      }

      // Wyszukujemy krawędzie wychodzące z currentNodeId
      // Uwzględniamy połączenia dwukierunkowe w przestrzeni pieszej
      for (final edge in edges) {
        String? nextNode;
        if (edge.from == currentNodeId) {
          nextNode = edge.to;
        } else if (edge.to == currentNodeId) {
          nextNode = edge.from;
        }

        if (nextNode != null && !visitedNodes.contains(nextNode)) {
          visitedNodes.add(nextNode);
          currentPath.add(edge);
          dfs(nextNode);
          currentPath.removeLast();
          visitedNodes.remove(nextNode);
        }
      }
    }

    dfs(startNodeId);
    return results;
  }
}
