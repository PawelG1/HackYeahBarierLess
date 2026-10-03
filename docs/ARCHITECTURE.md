# Architektura Repozytorium i Wytyczne Inżynierskie
**Standard:** Enterprise Clean Architecture + MVVM + Riverpod (No-Codegen) + SOLID  
**Framework:** Flutter / Dart (Material 3)  
**Specyfikacja źródłowa:** `SPEC_KRAKOW_BEZ_BARIER_AI(1).md`

---

## 1. Ustalony Stos Technologiczny i Granice Zależności

| Rola w architekturze | Konkretna decyzja technologiczna |
| :--- | :--- |
| **UI** | Flutter / Dart, Material 3, własne semantyczne widgety |
| **MVVM, stan, DI** | `flutter_riverpod` **bez generatora kodu**: `ConsumerWidget` jako View, `Notifier`/`AsyncNotifier` jako ViewModel, `Provider` jako composition root |
| **Wizualizacja mapy** | `flutter_map` + `latlong2` (tylko wizualizacja geometrii, brak logiki biznesowej) |
| **Zapis lokalny** | `shared_preferences` przez **`SharedPreferencesAsync`** (preferencja barier oraz lokalne obserwacje) |
| **Testy** | `flutter_test` (czysta logika domenowa testowana bez widgetów) |

> [!IMPORTANT]
> **Twarde Ograniczenia Zależności:**
> Kategoryczny zakaz dodawania: `freezed`, generatorów kodu (`build_runner`), `go_router`, Firebase, Supabase, SQLite ani klienta HTTP.
> Kierunek zależności: `presentation → domain ← data`.
> Domena jest czystym kodem Dart — nie importuje Fluttera, Riverpoda, `flutter_map` ani pamięci urządzenia.

---

## 2. Kanoniczna Struktura Katalogów i Plików

```text
krakow_bez_barier/
├─ pubspec.yaml
├─ README.md
├─ assets/data/demo_area.json
├─ lib/
│  ├─ main.dart
│  ├─ app.dart
│  ├─ core/
│  │  ├─ di/providers.dart              # Składanie zależności (composition root)
│  │  └─ errors/app_error.dart          # Hierarchia błędów aplikacji
│  ├─ domain/
│  │  ├─ entities/
│  │  │  ├─ place.dart                  # Miejsce docelowe (POI)
│  │  │  ├─ route_node.dart             # Węzeł grafu (lat, lon)
│  │  │  ├─ route_edge.dart             # Odcinek trasy
│  │  │  ├─ observation.dart            # Obserwacja barier / cech
│  │  │  └─ route_result.dart           # Wynik oceny trasy (status, uzasadnienie)
│  │  ├─ repositories/
│  │  │  ├─ route_repository.dart       # Port zwracający graf i źródła
│  │  │  └─ observation_repository.dart  # Port na lokalną nakładkę obserwacji
│  │  └─ usecases/
│  │     ├─ load_area.dart              # Pobranie i walidacja obszaru
│  │     ├─ compare_routes.dart         # Wyszukiwanie i ewaluacja tras
│  │     └─ add_observation.dart        # Dodanie lokalnego zgłoszenia
│  ├─ data/
│  │  ├─ dto/area_dto.dart              # Parsowanie i ścisła walidacja JSON
│  │  ├─ sources/
│  │  │  ├─ asset_json_source.dart      # Odczyt demo_area.json z assets
│  │  │  └─ preferences_source.dart     # Odczyt/zapis przez SharedPreferencesAsync
│  │  └─ repositories/
│  │     ├─ asset_route_repository.dart
│  │     └─ local_observation_repository.dart
│  └─ presentation/
│     ├─ viewmodels/
│     │  ├─ route_setup_vm.dart         # Wybór startu/celu, preferencje
│     │  ├─ route_comparison_vm.dart    # Stan porównania (loading/ready/error)
│     │  └─ place_detail_vm.dart        # Dostępność miejsca i wydarzenia
│     ├─ screens/
│     │  ├─ route_setup_screen.dart
│     │  ├─ route_comparison_screen.dart
│     │  └─ place_detail_screen.dart
│     └─ widgets/
│        ├─ route_card.dart             # Karta trasy (potwierdzona/niepewna/odrzucona)
│        ├─ status_badge.dart           # Etykieta statusu odporna na brak koloru
│        ├─ source_row.dart             # Wiersz źródła i daty
│        ├─ route_steps.dart            # Widok krok po kroku (text-first)
│        └─ map_preview.dart            # Podgląd mapy z fallbackiem offline
└─ test/
   ├─ domain/compare_routes_test.dart   # Czyste testy algorytmów i wykluczeń
   ├─ data/area_dto_test.dart           # Testy walidacji JSON i DTO
   └─ presentation/route_flow_test.dart # Testy przepływu UI i widoków
```

---

## 3. Szczegółowy Przepływ i Odpowiedzialności Warstw

### 3.1. Warstwa Domenowa (`domain/`)
- **Czysty kod Dart:** Bez importów z Fluttera ani platformowych bibliotek.
- **Porty Repozytoriów:**
  - `RouteRepository`: Zwraca zweryfikowany graf oraz metadane źródeł z pliku danych.
  - `ObservationRepository`: Pobiera i zapisuje lokalne obserwacje (jako nakładkę nadpisującą lub uzupełniającą dane bazowe).
- **Use Case: `CompareRoutes`:**
  - Pobiera graf z `RouteRepository` oraz lokalne wpisy z `ObservationRepository`.
  - Scalanie obserwacji: obserwacje o tym samym `target_id` i `feature` są analizowane łącznie.
  - Jeśli wartości są sprzeczne (np. `stairs: absent` z bazy oraz `stairs: present` ze zgłoszenia lokalnego), odcinek otrzymuje status `VerificationStatus.conflict`.
  - Sprawdza próg **90 dni** — obserwacje starsze niż 90 dni traktowane są jako `missing`/niepewne.
  - Wyszukuje proste ścieżki w grafie bez cykli.
  - Sortuje warianty: nieodrzucone, mniej nierozstrzygniętych barier, krótszy dystans.

### 3.2. Warstwa Danych (`data/`)
- **`AreaDto` (`data/dto/area_dto.dart`):**
  - Deserializacja pliku `assets/data/demo_area.json`.
  - Sprawdzenie `schema_version == 1`.
  - Walidacja spójności: unikalne ID węzłów, istnienie węzłów krańcowych krawędzi (`from`, `to`), istnienie węzłów dla `places`, poprawne wartości `verification` i daty ISO.
- **`PreferencesSource` (`data/sources/preferences_source.dart`):**
  - Wykorzystuje `SharedPreferencesAsync` do asynchronicznego, stabilnego zapisu JSON z listą lokalnych obserwacji oraz preferencją `avoid_stairs`.
  - Zawiera metodę `clearDemoData()` czyszczącą wszystkie lokalne obserwacje i przywracającą stan początkowy.

### 3.3. Warstwa Prezentacji (`presentation/`)
- **Wzorzec MVVM z Riverpod:**
  - `ConsumerWidget` jako pasywny View.
  - ViewModele jako `Notifier` / `AsyncNotifier`:
    - `RouteSetupVm`: trzyma wybrane węzły oraz preferencję `avoidStairs`.
    - `RouteComparisonVm`: zarządza stanem `AsyncValue<RouteComparisonState>`, reaguje na dodanie obserwacji i automatycznie odświeża porównanie tras.
    - `PlaceDetailVm`: zarządza audytem wejścia do obiektu docelowego oraz listą dostępnych wydarzeń kulturalnych.
- **Responsywność (Telefon vs Tablet):**
  - Układ zależny od szerokości ekranu (próg 600 px):
    - **< 600 px (Telefon):** Jedna kolumna, pionowy przepływ ekranów.
    - **>= 600 px (Tablet):** Układ dwupanelowy — po lewej lista porównania tras, po prawej szczegóły wybranej trasy i widok krok po kroku. Karty nie są sztucznie rozciągane.
- **Dostępność Tekst-First:**
  - `map_preview.dart` jest komponentem opcjonalnym — przy błędzie sieci lub wyłączeniu kafelków widok `route_steps.dart` działa w 100% samodzielnie.
  - Etykiety `Semantics` na wszystkich interaktywnych elementach.

---

## 4. Wstrzykiwanie Zależności (`core/di/providers.dart`)

```dart
// 1. Źródła danych
final assetJsonSourceProvider = Provider<AssetJsonSource>((ref) {
  return AssetJsonSource();
});

final preferencesSourceProvider = Provider<PreferencesSource>((ref) {
  return PreferencesSource(preferences: SharedPreferencesAsync());
});

// 2. Repozytoria
final routeRepositoryProvider = Provider<RouteRepository>((ref) {
  final jsonSource = ref.watch(assetJsonSourceProvider);
  return AssetRouteRepository(jsonSource: jsonSource);
});

final observationRepositoryProvider = Provider<ObservationRepository>((ref) {
  final prefSource = ref.watch(preferencesSourceProvider);
  return LocalObservationRepository(preferencesSource: prefSource);
});

// 3. Przypadki użycia (Use Cases)
final compareRoutesUseCaseProvider = Provider<CompareRoutes>((ref) {
  final routeRepo = ref.watch(routeRepositoryProvider);
  final obsRepo = ref.watch(observationRepositoryProvider);
  return CompareRoutes(routeRepository: routeRepo, observationRepository: obsRepo);
});

final addObservationUseCaseProvider = Provider<AddObservation>((ref) {
  final obsRepo = ref.watch(observationRepositoryProvider);
  return AddObservation(observationRepository: obsRepo);
});

// 4. ViewModele
final routeComparisonVmProvider = 
    AsyncNotifierProvider<RouteComparisonVm, RouteComparisonState>(RouteComparisonVm.new);
```
W testach jednostkowych i widgetowych podmieniamy repozytoria przez `ProviderScope(overrides: [...])` na wersje w pamięci (`InMemoryRouteRepository`, `InMemoryObservationRepository`).
