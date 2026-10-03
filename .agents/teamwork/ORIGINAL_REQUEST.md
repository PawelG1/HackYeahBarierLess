# Original User Request

## Initial Request — 2026-10-03T14:46:58Z

# Teamwork Project Prompt — Draft

> Status: Launched
> Goal: Craft prompt → get user approval → delegate to teamwork_preview
> Requested team: Small, focused team

This is a single self-contained fix; keep it small and focused.
Zadanie polega na wdrożeniu Architektury Systemu Designu i refaktoryzacji widoków aplikacji "Trasa bez domysłów", bazując na wytycznych z dokumentacji.

Working directory: /home/mecharolnik/HackYeahCracowApp
Integrity mode: demo

## Requirements

### R1. Architektura Systemu Designu
Wdrożenie scentralizowanego systemu designu w `lib/core/design_system/` (tokeny prymitywne, semantyczne, motywy, współdzielone widgety). Całkowita refaktoryzacja obecnego UI w `lib/presentation/`, tak aby korzystało wyłącznie z publicznego API design systemu (np. `context.colors.primary`), bez magicznych liczb i zakodowanych na sztywno kolorów.

### R2. Czysta Architektura i Separacja Warstw
Dalsze rygorystyczne utrzymanie podziału na warstwy `domain`, `data` i `presentation`. Zmiany wizualne nie mogą zaburzyć logiki biznesowej, a dozwolone jest wspieranie się czytaniem plików testów (zgodnie z TDD).

### R3. Spełnienie Scenariuszy Testowych i Jakości
Utrzymanie pełnego przejścia wszystkich testów po refaktoryzacji widoków. 

## Acceptance Criteria

### Weryfikacja Programistyczna
- [ ] Skrypt `./scripts/run_all_tests.sh` wykonuje się bezbłędnie (exit code 0), generując kompletny raport Markdown po refaktoryzacji.
- [ ] Wyszukiwanie wzorców `Color(0x` i `Colors.` w folderze `lib/presentation/` nie zwraca żadnych wyników (wszystko korzysta z `lib/core/design_system`).
- [ ] Analiza statyczna `flutter analyze` nie zwraca żadnych błędów.
