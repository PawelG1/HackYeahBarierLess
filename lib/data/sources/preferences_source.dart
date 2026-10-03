import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/observation.dart';

/// Źródło danych obsługujące trwały zapis preferencji i lokalnych zgłoszeń w pamięci urządzenia.
class PreferencesSource {
  static const String _keyLocalObservations = 'local_observations_json';
  static const String _keyAvoidStairs = 'pref_avoid_stairs';

  final SharedPreferencesAsync preferences;

  PreferencesSource({SharedPreferencesAsync? preferences})
      : preferences = preferences ?? SharedPreferencesAsync();

  /// Pobiera listę lokalnych obserwacji dodanych przez użytkownika.
  Future<List<Observation>> getLocalObservations() async {
    final rawJson = await preferences.getString(_keyLocalObservations);
    if (rawJson == null || rawJson.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> decoded = jsonDecode(rawJson);
      return decoded.map((item) {
        final map = item as Map<String, dynamic>;
        return Observation(
          id: map['id'] as String,
          targetType: map['target_type'] as String,
          targetId: map['target_id'] as String,
          feature: map['feature'] as String,
          value: map['value'] as String,
          sourceName: map['source_name'] as String,
          sourceUrl: map['source_url'] as String?,
          observedAt: DateTime.parse(map['observed_at'] as String),
          verification:
              VerificationStatus.fromString(map['verification'] as String),
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }

  /// Zapisuje nową obserwację na liście.
  Future<void> addObservation(Observation observation) async {
    final current = await getLocalObservations();
    current.add(observation);

    final rawJson = jsonEncode(current
        .map((o) => {
              'id': o.id,
              'target_type': o.targetType,
              'target_id': o.targetId,
              'feature': o.feature,
              'value': o.value,
              'source_name': o.sourceName,
              'source_url': o.sourceUrl,
              'observed_at': o.observedAt.toIso8601String(),
              'verification': o.verification.name,
            })
        .toList());

    await preferences.setString(_keyLocalObservations, rawJson);
  }

  /// Czyści lokalne obserwacje (przywracanie stanu demonstracyjnego).
  Future<void> clearDemoData() async {
    await preferences.remove(_keyLocalObservations);
  }

  /// Odczyt preferencji „Unikam schodów”.
  Future<bool> getAvoidStairsPreference() async {
    final val = await preferences.getBool(_keyAvoidStairs);
    return val ?? true; // Domyślnie włączone dla profilu wózka
  }

  /// Zapis preferencji „Unikam schodów”.
  Future<void> setAvoidStairsPreference(bool avoid) async {
    await preferences.setBool(_keyAvoidStairs, avoid);
  }
}
