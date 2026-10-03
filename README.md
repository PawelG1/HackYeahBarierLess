<div align="center">
  <h1>Trasa bez domysłów 🧑‍🦽🗺️</h1>
  <p><strong>Aplikacja nawigacyjna zorientowana na dostępność (Accessibility-First)</strong></p>
  <p><i>Projekt przygotowany na HackYeah 2026 – kategoria "Kraków bez barier"</i></p>

  [![Flutter](https://img.shields.io/badge/Flutter-3.x-blue.svg?logo=flutter)](https://flutter.dev)
  [![Dart](https://img.shields.io/badge/Dart-3.x-0175C2.svg?logo=dart)](https://dart.dev)
  [![Clean Architecture](https://img.shields.io/badge/Architecture-Clean-success.svg)]()
  [![WCAG 2.0](https://img.shields.io/badge/A11y-WCAG%202.0-orange.svg)]()
</div>

---

## 📖 O projekcie

**Trasa bez domysłów** to innowacyjna nawigacja miejska, która nie kłamie. Powszechne mapy często zakładają, że "najkrótsza trasa" to trasa najlepsza. Dla osób poruszających się na wózkach inwalidzkich, z wózkami dziecięcymi lub o ograniczonej mobilności jeden nieoznaczony krawężnik lub schody zamieniają tę trasę w pułapkę.

Nasza aplikacja rozwiązuje ten problem poprzez transparentną ocenę tras (potwierdzone, niepewne, odrzucone) oraz integrację bazy danych z audytów ZDMK ze zgłoszeniami społeczności.

## ✨ Kluczowe funkcjonalności

- ♿ **Dostępność przede wszystkim (WCAG 2.0):**
  - Ekran startowy z powiększonymi kartami atrakcji i czytelnymi kontrastami.
  - Skalowalność tekstów do **200%** bez „psucia” układu ekranu (brak błędu RenderFlex overflow).
  - Wbudowany w górny pasek globalny przełącznik dużego kontrastu oraz wielkości czcionek.
  - Pełne wsparcie dla czytników ekranu (każdy element posiada odpowiednie `Semantics`).
- 🗺️ **Interaktywna Mapa (OpenStreetMap):**
  - Wyświetlanie obranej ścieżki i lokalizacji, zorientowane na prywatność.
  - Asynchroniczne rysowanie markerów społeczności (wypadki, barierki, brak zjazdu).
  - Możliwość **kliknięcia w dowolny punkt mapy**, by błyskawicznie zgłosić nową przeszkodę do systemu.
- 🚦 **Kategoryzacja bezpieczeństwa tras:**
  - Zamiast fałszywych wskaźników procentowych, aplikacja posługuje się kategorycznymi statusami: 🟢 **POTWIERDZONA**, 🟡 **NIEPEWNA** (konflikt danych/stare dane), 🔴 **ODRZUCONA** (krytyczna bariera, np. schody).
- 🎨 **Własny Design System:**
  - Centralne zarządzanie motywem (tokeny semantyczne) sprawia, że przełączenie na tryb nocny lub o wysokim kontraście jest płynne i działa wszędzie tak samo.

## 🏗️ Architektura i Stos Technologiczny

Projekt został zbudowany z zachowaniem najbardziej rygorystycznych standardów inżynierii oprogramowania. 

- **Frontend:** Flutter + Dart
- **Architektura:** Enterprise Clean Architecture (Domain, Data, Presentation)
- **Wzorzec projektowy UI:** MVVM (Model-View-ViewModel)
- **Zarządzanie stanem i DI:** Riverpod (w wersji No-Codegen) + warstwa `providers.dart`.
- **Zapis danych:** `SharedPreferencesAsync` (lokalna baza zgłoszeń).
- **Mapa:** `flutter_map` z `latlong2`.

> **Zero magii:** Projekt celowo unika generatorów kodu (`build_runner`, `freezed`), frameworków do nawigacji (`go_router`) czy zewnętrznych serwerów bazodanowych jak Firebase, udowadniając w 100% wydajność w izolacji. Pełen przepływ danych działa nawet offline (lub na wbudowanym zrzucie w formacie JSON).

## 📚 Dokumentacja

Więcej szczegółów technicznych znajduje się w dedykowanych plikach w folderze `docs/`:
- [Wymagania i Logika Domenowa](docs/REQUIREMENTS.md)
- [Architektura Systemu i DI](docs/ARCHITECTURE.md)
- [Matryca Testów i Scenariusze Jurorskie](docs/TEST_SCENARIOS.md)
- [Orkiestracja Agentów AI](docs/AGENT_ORCHESTRATION.md)

## 🚀 Uruchomienie lokalne

1. Pobierz repozytorium na dysk.
2. Pobierz pakiety Fluttera:
   ```bash
   flutter pub get
   ```
3. Uruchom aplikację (domyślny lub webowy symulator):
   ```bash
   flutter run
   ```

## 🧪 Uruchamianie testów

Kod logiki domenowej (Domain) nie wie absolutnie nic o frameworku Flutter, co pozwala nam błyskawicznie weryfikować poprawność algorytmów. Cały projekt został stworzony w metodyce **Test-Driven Development (TDD)**.

Aby uruchomić pełen pakiet testów weryfikujący (testy modeli, repozytoriów, symulację flow interfejsu łącznie ze skalowaniem tekstu na 200%):
```bash
flutter test
```
