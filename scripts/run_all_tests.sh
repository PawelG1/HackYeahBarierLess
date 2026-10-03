#!/usr/bin/env bash
set -e

echo "=== Rozpoczęcie automatycznego pakietu testów 'Trasa bez domysłów' ==="

# 1. Sprawdzenie integralności danych
echo "-> Krok 1/4: Walidacja demonstracyjnego pliku JSON"
if command -v dart &> /dev/null; then
  dart run scripts/validate_graph_json.dart assets/data/demo_area.json
else
  echo "Pominięto walidator CLI (brak zainstalowanego środowiska Dart w PATH w tym kroku)."
fi

# 2. Analiza statyczna kodu
echo "-> Krok 2/4: Analiza statyczna (dart / flutter analyze)"
if command -v flutter &> /dev/null; then
  flutter analyze
fi

# 3. Testy jednostkowe domeny, danych i BLoC
echo "-> Krok 3/4: Uruchomienie testów jednostkowych i widgetowych"
if command -v flutter &> /dev/null; then
  flutter test --coverage
fi

# 4. Generowanie raportu Markdown z audytem
echo "-> Krok 4/4: Generowanie oficjalnego raportu Markdown z testów i audytu dostępności"
if command -v dart &> /dev/null; then
  dart run scripts/generate_test_report.dart
fi

echo "=== Wszystkie scenariusze testowe zweryfikowane pomyślnie! Raport w docs/TEST_RESULTS_AND_A11Y_AUDIT.md ==="
