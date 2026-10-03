import 'observation.dart';
import 'route_edge.dart';

/// Wynikowy status trasy wg specyfikacji HackYeah.
enum RouteStatus {
  confirmed,
  uncertain,
  rejected;

  String get displayName {
    switch (this) {
      case RouteStatus.confirmed:
        return 'Potwierdzona';
      case RouteStatus.uncertain:
        return 'Niepewna';
      case RouteStatus.rejected:
        return 'Odrzucona';
    }
  }
}

/// Pojedynczy krok (odcinek) w planie trasy.
class RouteStep {
  final RouteEdge edge;
  final List<Observation> observations;
  final bool hasConflict;
  final bool isExcludedBarrier;
  final String? barrierReason;

  const RouteStep({
    required this.edge,
    required this.observations,
    this.hasConflict = false,
    this.isExcludedBarrier = false,
    this.barrierReason,
  });

  /// Zwraca najnowszą datę ze wszystkich obserwacji na tym odcinku.
  DateTime? get latestObservationDate {
    if (observations.isEmpty) return null;
    return observations
        .map((o) => o.observedAt)
        .reduce((a, b) => a.isAfter(b) ? a : b);
  }
}

/// Pełny plan trasy z wyliczonym statusem i uzasadnieniem.
class RouteResult {
  final String id;
  final String title;
  final RouteStatus status;
  final int totalDistanceM;
  final List<RouteStep> steps;
  final List<String> reasons;
  final bool isDemoData;
  final int unresolvedBarriersCount;

  const RouteResult({
    required this.id,
    required this.title,
    required this.status,
    required this.totalDistanceM,
    required this.steps,
    required this.reasons,
    required this.isDemoData,
    required this.unresolvedBarriersCount,
  });

  DateTime? get lastObservedDate {
    DateTime? latest;
    for (final step in steps) {
      final d = step.latestObservationDate;
      if (d != null) {
        if (latest == null || d.isAfter(latest)) {
          latest = d;
        }
      }
    }
    return latest;
  }
}
