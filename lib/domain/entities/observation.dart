/// Status weryfikacji informacji o cechach i barierach.
enum VerificationStatus {
  confirmed,
  // ignore: constant_identifier_names
  community_unverified,
  conflict,
  missing,
  demo;

  static VerificationStatus fromString(String val) {
    return VerificationStatus.values.firstWhere(
      (e) => e.name == val,
      orElse: () => VerificationStatus.missing,
    );
  }

  String get displayName {
    switch (this) {
      case VerificationStatus.confirmed:
        return 'Potwierdzona';
      case VerificationStatus.community_unverified:
        return 'Zapisano na tym urządzeniu';
      case VerificationStatus.conflict:
        return 'Konflikt danych';
      case VerificationStatus.missing:
        return 'Brak informacji';
      case VerificationStatus.demo:
        return 'Dane demonstracyjne';
    }
  }
}

/// Obserwacja przypisana do krawędzi lub miejsca docelowego.
class Observation {
  final String id;
  final String targetType; // 'edge' lub 'place'
  final String targetId;
  final String feature;
  final String value;
  final String sourceName;
  final String? sourceUrl;
  final DateTime observedAt;
  final VerificationStatus verification;

  const Observation({
    required this.id,
    required this.targetType,
    required this.targetId,
    required this.feature,
    required this.value,
    required this.sourceName,
    this.sourceUrl,
    required this.observedAt,
    required this.verification,
  });

  /// Sprawdza, czy obserwacja jest przeterminowana względem zadanego progu dni.
  bool isExpired({int thresholdDays = 90, DateTime? referenceDate}) {
    final now = referenceDate ?? DateTime.now();
    return now.difference(observedAt).inDays > thresholdDays;
  }

  Observation copyWith({
    String? id,
    String? targetType,
    String? targetId,
    String? feature,
    String? value,
    String? sourceName,
    String? sourceUrl,
    DateTime? observedAt,
    VerificationStatus? verification,
  }) {
    return Observation(
      id: id ?? this.id,
      targetType: targetType ?? this.targetType,
      targetId: targetId ?? this.targetId,
      feature: feature ?? this.feature,
      value: value ?? this.value,
      sourceName: sourceName ?? this.sourceName,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      observedAt: observedAt ?? this.observedAt,
      verification: verification ?? this.verification,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Observation &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          targetType == other.targetType &&
          targetId == other.targetId &&
          feature == other.feature &&
          value == other.value &&
          sourceName == other.sourceName &&
          sourceUrl == other.sourceUrl &&
          observedAt == other.observedAt &&
          verification == other.verification;

  @override
  int get hashCode =>
      id.hashCode ^
      targetType.hashCode ^
      targetId.hashCode ^
      feature.hashCode ^
      value.hashCode ^
      sourceName.hashCode ^
      sourceUrl.hashCode ^
      observedAt.hashCode ^
      verification.hashCode;
}
