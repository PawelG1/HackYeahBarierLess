# Wymagania i Specyfikacja Systemu: „Trasa bez domysłów”
**Kategoria:** Kraków bez barier — HackYeah 2026  
**Język aplikacji i dokumentacji:** Polski  
**Platformy docelowe:** Android (główna demonstracja mobilna), iOS, opcjonalnie Flutter Web (zapasowy podgląd)  
**Specyfikacja źródłowa:** `SPEC_KRAKOW_BEZ_BARIER_AI(1).md`

---

## 1. Cel i Główna Teza Projektu
Większość aplikacji asystujących podaje trasę „najkrótszą” i ukrywa brak wiedzy o barierach, co dla osoby na wózku inwalidzkim kończy się utknięciem przed schodami, zepsutą windą lub stromym krawężnikiem.
**„Trasa bez domysłów” opiera się na radykalnej transparentności:**
1. Każda cecha odcinka i miejsca posiada konkretne źródło, datę obserwacji oraz status weryfikacji.
2. Brak danych lub informacja **starsza niż 90 dni** (konfigurowalny próg demonstracyjny w jednym miejscu w kodzie) oznaczają **„nie wiemy”**, a **nigdy „dostępne”**.
3. Sprzeczne obserwacje (np. w danych bazowych `stairs: absent`, a lokalne zgłoszenie użytkownika `stairs: present`) generują stan **`conflict`** i wykluczają status „potwierdzona trasa dostępna”.
4. Aplikacja mobilna działa w 100% lokalnie na telefonach i tabletach Android/iOS, bez serwera, API, konta i bazy danych. Dane ładują się z `assets/data/demo_area.json`.
5. Lokalne obserwacje i preferencje są trwale zapisywane na urządzeniu przy użyciu `shared_preferences` (`SharedPreferencesAsync`). Dostępny jest przycisk **„Wyczyść dane demonstracyjne”**.
6. Pełna dostępność interfejsu (Semantics, a11y, TalkBack, klawiatura), responsywny układ (telefon < 600px jeden słupek; tablet >= 600px dwa panele), oraz priorytet widoku tekstowego nad mapą.

---

## 2. Profile Użytkownika i Prywatność
- **Profil wspierany w prototypie:** Osoba poruszająca się na wózku manualnym/elektrycznym, dla której schody bez alternatywy stanowią bezwzględną barierę.
- **Prywatność i RODO:** Preferencje barierowe wybiera się w aplikacji (przełącznik „Unikam schodów”). **Nie zapisujemy, nie przetwarzamy ani nie pytamy o diagnozy medyczne ani stopień niepełnosprawności.**

---

## 3. Kontrakt Danych (`assets/data/demo_area.json`)

### 3.1. Zasady Kontraktu
- `schema_version`: integer `1`.
- Obiekt `area`: identyfikator, nazwa oraz znacznik `data_kind: "demo"`.
- `places`: lista obiektów docelowych (w tym Teatr im. J. Słowackiego, Sukiennice, Teatr Bagatela, Wawel, Bunkier Sztuki).
- `nodes`: wierzchołki grafu z współrzędnymi lat/lon.
- `edges`: krawędzie łączące węzły, z dystansem w metrach i bazową cechą (`feature`).
- **`observations`:** Obserwacje znajdują się **wyłącznie w tablicy najwyższego poziomu**! Wskazują `target_type` (`"edge"` lub `"place"`) oraz `target_id`.
- **Wymóg demonstracyjny sprzeczności:**
  - Na Trasie A umieszczone są schody oznaczone `verification: "demo"`.
  - Na Trasie B umieszczona jest obserwacja `feature: "stairs"`, `value: "absent"` oznaczona `verification: "demo"`, dzięki czemu lokalne zgłoszenie użytkownika `value: "present"` tworzy natychmiastowy i ewidentny stan `conflict`.
  - Lokalna obserwacja otrzymuje status `community_unverified` i etykietę „zapisano tylko na tym urządzeniu”.

### 3.2. Wzorcowy Schemat JSON
```json
{
  "schema_version": 1,
  "area": {
    "id": "demo-area",
    "name": "Obszar demonstracyjny Kraków — Stare Miasto",
    "data_kind": "demo"
  },
  "places": [
    {
      "id": "p-teatr-slowackiego",
      "name": "Teatr im. Juliusza Słowackiego w Krakowie",
      "node_id": "n-teatr-slowackiego"
    },
    {
      "id": "p-teatr-bagatela",
      "name": "Teatr Bagatela (wejście od ul. Krupniczej)",
      "node_id": "n-bagatela"
    },
    {
      "id": "p-sukiennice",
      "name": "Sukiennice — Galeria Sztuki Polskiej XIX w.",
      "node_id": "n-sukiennice"
    }
  ],
  "nodes": [
    {"id": "n-dworzec", "lat": 50.0665, "lon": 19.9482},
    {"id": "n-tunel-start", "lat": 50.0655, "lon": 19.9460},
    {"id": "n-planty-slowacki", "lat": 50.0645, "lon": 19.9440},
    {"id": "n-teatr-slowackiego", "lat": 50.0638, "lon": 19.9425},
    {"id": "n-basztowa-przejscie", "lat": 50.0652, "lon": 19.9448}
  ],
  "edges": [
    {
      "id": "e-tunel-schody",
      "from": "n-dworzec",
      "to": "n-tunel-start",
      "distance_m": 85,
      "feature": "stairs"
    },
    {
      "id": "e-basztowa-naziemne",
      "from": "n-dworzec",
      "to": "n-basztowa-przejscie",
      "distance_m": 120,
      "feature": "curb_ramp"
    },
    {
      "id": "e-planty-dojscie",
      "from": "n-basztowa-przejscie",
      "to": "n-teatr-slowackiego",
      "distance_m": 150,
      "feature": "asphalt_path"
    }
  ],
  "observations": [
    {
      "id": "o-tunel-01",
      "target_type": "edge",
      "target_id": "e-tunel-schody",
      "feature": "stairs",
      "value": "present",
      "source_name": "Audyt barier architektonicznych",
      "source_url": null,
      "observed_at": "2026-09-15",
      "verification": "demo"
    },
    {
      "id": "o-planty-01",
      "target_type": "edge",
      "target_id": "e-planty-dojscie",
      "feature": "stairs",
      "value": "absent",
      "source_name": "Miejski rejestr alejek parkowych",
      "source_url": null,
      "observed_at": "2026-09-20",
      "verification": "demo"
    },
    {
      "id": "o-teatr-wejscie-01",
      "target_type": "place",
      "target_id": "p-teatr-slowackiego",
      "feature": "wheelchair_ramp",
      "value": "present",
      "source_name": "Dział Dostępności Teatru Słowackiego",
      "source_url": "https://teatrwkrakowie.pl/dostepnosc",
      "observed_at": "2026-09-01",
      "verification": "confirmed"
    }
  ]
}
```

### 3.3. Dopuszczalne wartości `verification`
- `confirmed`: sprawdzone, wiarygodne źródło i aktualna data (<= 90 dni).
- `community_unverified`: zgłoszenie użytkownika zapisane lokalnie.
- `conflict`: sprzeczne obserwacje dotyczące tej samej cechy.
- `missing`: brak danych na odcinku.
- `demo`: dane demonstracyjne.

---

## 4. Reguły Oceny Tras (`CompareRoutes`)

1. **Bezwzględne wykluczenie:** Potwierdzone schody (`feature: "stairs"`, `value: "present"`, `verification: "confirmed"` lub `"demo"` w scenariuszu demonstracyjnym) przy `avoidStairs = true` powodują status trasy: **`odrzucona`**.
2. **Wykrywanie konfliktu:** Jeżeli dla danej cechy (`feature`) istnieją obserwacje sprzeczne (np. `value: "absent"` vs `value: "present"`), odcinek otrzymuje status `conflict`, a trasa: **`niepewna`**. Pokazywane są obie informacje ze źródłami i datami.
3. **Zasada 90 dni (Data Obsolescence):** Informacja starsza niż 90 dni od daty bieżącej lub brak obserwacji oznacza stan „nie wiemy” -> trasa otrzymuje status **`niepewna`**.
4. **Wyznaczanie i sortowanie tras:** `CompareRoutes` wyszukuje proste ścieżki bez cykli w grafie i sortuje je deterministycznie:
   1. Trasy nieodrzucone przed odrzuconymi.
   2. Mniejsza liczba nierozstrzygniętych barier i konfliktów.
   3. Krótszy dystans.
5. **Format wyniku:** Każda trasa zawiera listę odcinków, ich cechy, status oraz jawne uzasadnienie (`reasons`).

---

## 5. Dostępność i Responsywność (a11y & Form Factors)
- **Telefon (< 600 px):** Układ pojedynczej kolumny z krótkim stosem ekranów.
- **Tablet (>= 600 px):** Układ dwupanelowy (porównanie tras po lewej + szczegóły/kroki po prawej) bez nienaturalnego rozciągania kart.
- **Dostępność cyfrowa:**
  - `Semantics` na wszystkich kontrolkach i kartach tras.
  - Minimalny rozmiar celu dotykowego: 48x48 dp.
  - Odporność na skalowanie tekstu do 200% bez błędu `RenderFlex overflowed`.
  - Mapa nie zasłania treści przy dużym tekście.
  - Pełna funkcjonalność w trybie tekstowym bez pobierania kafelków mapy.
