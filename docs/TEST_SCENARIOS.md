# Szczegółowe Scenariusze Testowe (Enterprise Test Suite)
**Projekt:** „Trasa bez domysłów” — Kraków bez barier (HackYeah 2026)  
**Standard:** Czyste testy domenowe bez widgetów, testy DTO i walidacji JSON, testy przepływu UI, a11y i scenariusz jurorski  
**Specyfikacja źródłowa:** `SPEC_KRAKOW_BEZ_BARIER_AI(1).md`

---

## 1. Macierz Kluczowych Reguł Ewaluacji Tras (`CompareRoutes`)

| Sytuacja na odcinku / w wejściu | Obserwacja w bazie | Lokalne zgłoszenie | avoidStairs = true | Wynikowy status trasy | Powód i transparentność |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Schody na Trasie A** | `stairs: present` (`demo`/`confirmed`) | brak | **ODRZUCONA** | `odrzucona` | Jawny powód: schody na odcinku, źródło i data, etykieta demo |
| **Brak barier na Trasie B** | `stairs: absent` (`demo`) | brak | Dopuszczona | `niepewna` (dane demo) | Informacja o danych demonstracyjnych |
| **Zgłoszenie sprzeczności na Trasie B** | `stairs: absent` (`demo`) | `stairs: present` (`community_unverified`) | **KONFLIKT** | `niepewna` (zamiast odrzuconej bez weryfikacji) | Prezentacja OBU sprzecznych źródeł obok siebie |
| **Informacja > 90 dni** | Obserwacja sprzed 120 dni | brak | Niepewna | `niepewna` | Status „nie wiemy” (przekroczony próg 90 dni) |
| **Brak jakichkolwiek danych** | brak wpisu w `observations` | brak | Niepewna | `niepewna` | Status „nie wiemy”, informacja co należy sprawdzić przed wyjściem |

---

## 2. Testy Domenowe (`test/domain/compare_routes_test.dart`)

### TC-DOM-01: Wykluczenie trasy ze schodami dla profilu wózka
- **Plik:** `test/domain/compare_routes_test.dart`
- **Scenariusz:** Trasa A zawiera odcinek ze schodami (`stairs: present`). Profil użytkownika: `avoidStairs = true`.
- **Weryfikacja:**
  - Status Trasy A to `RouteStatus.rejected`.
  - Powód odrzucenia zawiera identyfikator odcinka, cechę `stairs`, źródło i datę.

### TC-DOM-02: Generowanie konfliktu przy sprzecznych obserwacjach na Trasie B
- **Plik:** `test/domain/compare_routes_test.dart`
- **Scenariusz:**
  - W danych bazowych na odcinku Trasy B zapisano: `stairs: absent` (`demo`).
  - Użytkownik dodaje lokalną obserwację na tym samym odcinku: `stairs: present` (`community_unverified`).
- **Weryfikacja:**
  - Odcinek otrzymuje status `VerificationStatus.conflict`.
  - Trasa B nie może otrzymać statusu `confirmed`. Zwracany status to `RouteStatus.uncertain`.
  - Wynik zawiera obie obserwacje: bazową i lokalną („zapisano tylko na tym urządzeniu”).

### TC-DOM-03: Próg 90 dni dezaktualizacji danych (Obsolescence Threshold)
- **Plik:** `test/domain/compare_routes_test.dart`
- **Scenariusz:** Obserwacja ma datę starszą niż 90 dni od daty ewaluacji (np. sprzed 100 dni).
- **Weryfikacja:**
  - Informacja jest traktowana jako nieaktualna (`missing`/brak pewności).
  - Trasa nie otrzymuje statusu `potwierdzona`; status to `niepewna` z powodem wskazującym na przeterminowanie audytu.

### TC-DOM-04: Deterministyczne sortowanie tras
- **Plik:** `test/domain/compare_routes_test.dart`
- **Scenariusz:** W grafie istnieją 3 alternatywne trasy:
  1. Trasa A: krótka (100 m), ale odrzucona (schody).
  2. Trasa B: średnia (250 m), nieodrzucona, z potwierdzonymi danymi.
  3. Trasa C: długa (400 m), nieodrzucona, z barierami niepewnymi.
- **Weryfikacja:**
  - Kolejność sortowania: Trasa B (nieodrzucona, brak konfliktów), Trasa C (nieodrzucona, niepewna), Trasa A (odrzucona).
  - Najkrótsza odrzucona trasa nie ląduje na pierwszym miejscu.

---

## 3. Testy DTO i Walidacji Danych (`test/data/area_dto_test.dart`)

### TC-DATA-01: Walidacja poprawnego pliku JSON `demo_area.json`
- **Plik:** `test/data/area_dto_test.dart`
- **Weryfikacja:**
  - `schema_version == 1`.
  - Unikalność wszystkich `id` węzłów, krawędzi i miejsc.
  - Spójność referencyjna: każda krawędź ma istniejące `from` i `to` w `nodes`.
  - Każde miejsce `place` wskazuje na istniejący `node_id`.
  - Wszystkie obserwacje w tablicy najwyższego poziomu wskazują poprawny `target_type` (`edge` lub `place`) i istniejący `target_id`.

### TC-DATA-02: Wykrycie błędnego rekordu lub niespójności
- **Plik:** `test/data/area_dto_test.dart`
- **Scenariusz:**
  - Podanie JSON-a z brakującym węzłem docelowym lub błędną wartością enum `verification`.
- **Weryfikacja:**
  - Wyrzucenie czytelnego błędu walidacji (`AppError.validation`), bez cichego ignorowania i bez fałszywych tras.

### TC-DATA-03: Trwały zapis lokalnych obserwacji w `SharedPreferencesAsync`
- **Plik:** `test/data/area_dto_test.dart`
- **Scenariusz:**
  - Zapis lokalnej obserwacji przez `PreferencesSource`.
  - Ponowny odczyt — obserwacja jest zachowana.
  - Wywołanie „Wyczyść dane demonstracyjne” (`clearDemoData()`) — obserwacja zostaje usunięta, powrót do czystego stanu początkowego.

---

## 4. Testy Przepływu UI i Responsywności (`test/presentation/route_flow_test.dart`)

### TC-UI-01: Responsywny układ (Telefon < 600 px vs Tablet >= 600 px)
- **Plik:** `test/presentation/route_flow_test.dart`
- **Weryfikacja:**
  - Przy szerokości ekranu 400 px: interfejs renderuje pojedynczą kolumnę z nawigacją stosową.
  - Przy szerokości ekranu 800 px: interfejs renderuje dwa panele obok siebie (lewy: lista tras, prawy: szczegóły trasy i lista kroków).
  - Karty tras na tablecie nie są nienaturalnie rozciągnięte na pełną szerokość.

### TC-UI-02: Dostępność tekstowa i zachowanie przy braku kafelków mapy
- **Plik:** `test/presentation/route_flow_test.dart`
- **Weryfikacja:**
  - Widok `route_steps.dart` wyświetla pełną listę kolejnych odcinków, ich cechy i status bez konieczności pobrania kafelków mapy.
  - Symulacja błędu sieci/kafelków mapy nie blokuje interfejsu ani nawigacji tekstowej.

### TC-UI-03: Audyt Semantics i skalowanie czcionki 200%
- **Plik:** `test/presentation/route_flow_test.dart`
- **Weryfikacja:**
  - Wszystkie przyciski, przełączniki i karty posiadają etykiety semantyczne `Semantics(label: ..., button: true)`.
  - Test przy `TextScaler.linear(2.0)` — brak błędu `RenderFlex overflowed`.

---

## 5. Oficjalny Scenariusz Jurorski (Jury Acceptance Scenario)

### TC-JURY-01: Kompletna ścieżka demonstracyjna z transparentnością barier
1. **Krok 1 (Wybór potrzeb):** Uruchomienie aplikacji; widoczny wyraźny znacznik danych demonstracyjnych. Włączenie przycisku „Unikam schodów”. Wybór startu (Dworzec PKP) i celu (Teatr im. Juliusza Słowackiego).
2. **Krok 2 (Porównanie tras):** Widoczne dwie karty:
   - Trasa A: stan **`odrzucona`** z powodem: schody na odcinku tunelu, etykieta danych demo.
   - Trasa B: stan **`niepewna`** (dane demonstracyjne) lub **`potwierdzona`**, bez schodów.
3. **Krok 3 (Szczegóły odcinka i miejsca):** Otwarcie szczegółów celu: audyt pochylni przy wejściu do teatru od Plant, miejsca w XIII rzędzie oraz repertuar spektakli z audiodeskrypcją i PJM.
4. **Krok 4 (Dodanie lokalnej obserwacji):** Na odcinku Trasy B dodanie lokalnej sprzecznej obserwacji: `stairs: present`.
5. **Krok 5 (Demonstracja konfliktu):** Trasa B natychmiast zmienia status na **`niepewna`** (wykryto konflikt). Na ekranie prezentowane są obie obserwacje: wcześniejsza `stairs: absent` oraz nowe zgłoszenie użytkownika z etykietą „zapisano tylko na tym urządzeniu”.
6. **Krok 6 (Krok po kroku bez mapy):** Przejście do widoku tekstowego `route_steps.dart` i zweryfikowanie trasy klawiaturą / czytnikiem TalkBack bez korzystania z mapy.
7. **Krok 7 (Wyczyść dane):** Kliknięcie „Wyczyść dane demonstracyjne” — usunięcie lokalnego wpisu, przywrócenie stanu pierwotnego.
