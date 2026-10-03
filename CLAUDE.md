# Instrukcje dla Agentów AI: „Trasa bez domysłów” (HackYeah 2026)

Projekt **„Trasa bez domysłów”** w kategorii *Kraków bez barier* (HackYeah 2026).
Architektura: **Enterprise Clean Architecture + MVVM + Riverpod (No-Codegen) + SOLID + TDD**.
Specyfikacja nadrzędna: `SPEC_KRAKOW_BEZ_BARIER_AI(1).md`.

---

## 1. Kluczowe Polecenia (Commands)
```bash
# Pobranie zależności
flutter pub get

# Uruchomienie pełnego pakietu testów (domena, DTO, przepływ UI)
flutter test

# Uruchomienie statycznej analizy kodu
flutter analyze

# Uruchomienie aplikacji na telefonie / tablecie / webie
flutter run
flutter run -d chrome
```

---

## 2. Nienaruszalne Zasady Architektury i Kodu (Golden Rules)

1. **Stos Technologiczny i Zakazy:**
   - **UI:** Flutter/Dart, Material 3, semantyczne widgety.
   - **Stan & DI:** `flutter_riverpod` **bez generatora kodu**: `ConsumerWidget` jako View, `Notifier`/`AsyncNotifier` jako ViewModel, `Provider` w `lib/core/di/providers.dart`.
   - **Mapa:** `flutter_map` + `latlong2` (wyłącznie wizualizacja geometrii; trasa tekstowa działa w 100% bez mapy).
   - **Pamięć lokalna:** `shared_preferences` przez **`SharedPreferencesAsync`**.
   - **Kategoryczny zakaz:** Nie dodawaj `freezed`, generatorów kodu (`build_runner`), `go_router`, Firebase, Supabase, SQLite ani klienta HTTP.
2. **Czystość Domeny (Domain Purity):**
   - Kod w `lib/domain/` to **czysty Dart**.
   - Kierunek zależności: `presentation → domain ← data`. Domena nie importuje Fluttera, Riverpoda, mapy ani platformowych bibliotek.
3. **Reguły Ewaluacji Tras:**
   - Brak fikcyjnych procentów (zakaz etykiet typu „dostępna w 80%”). Statusy to wyłącznie: `potwierdzona`, `niepewna`, `odrzucona`.
   - Schody przy `avoidStairs = true` bezwzględnie wykluczają odcinek (status: `odrzucona`).
   - Sprzeczne obserwacje generują stan `conflict` i wykluczają etykietę trasy potwierdzonej.
   - Informacja starsza niż **90 dni** oznacza status „nie wiemy” (stan `niepewna`).
4. **Kontrakt Danych (`assets/data/demo_area.json`):**
   - `schema_version: 1`, top-level `observations` z polami `target_type` (`"edge"` lub `"place"`) i `target_id`.
   - Na Trasie A umieszczone są schody oznaczone `demo`.
   - Na Trasie B umieszczona jest obserwacja `stairs: absent` (`demo`), aby lokalne zgłoszenie `stairs: present` tworzyło czytelny konflikt.
5. **Dostępność i Responsywność:**
   - Telefon (<600 px): jedna kolumna; Tablet (>=600 px): dwa panele obok siebie.
   - Każda kontrolka posiada `Semantics(label: ..., button: true)`.
   - Rozmiar celu klikalnego $\ge 48\times 48\text{ dp}$, odporność na powiększenie tekstu o 200%.

---

## 3. Struktura Katalogów
```text
krakow_bez_barier/
├─ assets/data/demo_area.json
├─ lib/
│  ├─ core/di/providers.dart
│  ├─ core/errors/app_error.dart
│  ├─ domain/entities/, repositories/, usecases/
│  ├─ data/dto/, sources/, repositories/
│  └─ presentation/viewmodels/, screens/, widgets/
└─ test/
   ├─ domain/compare_routes_test.dart
   ├─ data/area_dto_test.dart
   └─ presentation/route_flow_test.dart
```

Więcej szczegółów w plikach:
- [docs/REQUIREMENTS.md](file:///home/mecharolnik/HackYeahCracowApp/docs/REQUIREMENTS.md)
- [docs/ARCHITECTURE.md](file:///home/mecharolnik/HackYeahCracowApp/docs/ARCHITECTURE.md)
- [docs/TEST_SCENARIOS.md](file:///home/mecharolnik/HackYeahCracowApp/docs/TEST_SCENARIOS.md)
- [docs/AGENT_ORCHESTRATION.md](file:///home/mecharolnik/HackYeahCracowApp/docs/AGENT_ORCHESTRATION.md)
