import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:krakow_bez_barier/core/design_system/design_system.dart';
import 'package:krakow_bez_barier/domain/entities/observation.dart';
import 'package:krakow_bez_barier/domain/entities/route_result.dart';
import 'package:krakow_bez_barier/presentation/widgets/status_badge.dart';

void main() {
  group('Design System - Tokeny i Motyw (AppTheme)', () {
    test('AppTheme.lightTheme zawiera rozszerzenie AppColorsExtension', () {
      final theme = AppTheme.lightTheme;
      final colors = theme.extension<AppColorsExtension>();

      expect(colors, isNotNull);
      expect(colors!.primary, equals(AppColorsPrimitive.blue800));
      expect(colors.statusConfirmedBg, equals(AppColorsPrimitive.green50));
      expect(colors.statusUncertainBg, equals(AppColorsPrimitive.orange50));
      expect(colors.statusRejectedBg, equals(AppColorsPrimitive.red50));
      expect(colors.warningBg, equals(AppColorsPrimitive.orange50));
      expect(colors.warningBorder, equals(AppColorsPrimitive.orange800));
    });

    test('AppColorsExtension copyWith oraz lerp działają poprawnie', () {
      const colors = AppColorsExtension.light;
      final copy = colors.copyWith(primary: Colors.purple) as AppColorsExtension;
      expect(copy.primary, equals(Colors.purple));
      expect(copy.onPrimary, equals(colors.onPrimary));

      final lerped = colors.lerp(copy, 0.5);
      expect(lerped, isA<AppColorsExtension>());
    });

    test('Tokeny semantyczne udostępniają poprawne wartości', () {
      const spacing = AppSpacingSemantic.instance;
      expect(spacing.none, equals(0.0));
      expect(spacing.base, equals(16.0));
      expect(spacing.huge, equals(48.0));
      expect(spacing.screenPadding, equals(const EdgeInsets.all(16.0)));

      const radii = AppRadiusSemantic.instance;
      expect(radii.card, equals(BorderRadius.circular(12.0)));
      expect(radii.cardDense, equals(BorderRadius.circular(8.0)));
      expect(radii.badge, equals(BorderRadius.circular(16.0)));

      const dimensions = AppDimensionsSemantic.instance;
      expect(dimensions.minTouchTarget, equals(48.0));
      expect(dimensions.tabletBreakpoint, equals(600.0));
      expect(dimensions.tabletSidePanelWidth, equals(360.0));
    });
  });

  group('Design System - Współdzielone Widgety i a11y', () {
    testWidgets('AppBanner.demo renderuje się z poprawnymi tokenami', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return AppBanner.demo(
                  context: context,
                  message: 'Komunikat demonstracyjny',
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Komunikat demonstracyjny'), findsOneWidget);
      expect(find.byIcon(Icons.info_outline), findsOneWidget);
    });

    testWidgets('AppBanner.support renderuje się poprawnie', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return AppBanner.support(
                  context: context,
                  message: 'Wsparcie asystenta',
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Wsparcie asystenta'), findsOneWidget);
      expect(find.byIcon(Icons.support_agent), findsOneWidget);
    });

    testWidgets('AppCard posiada etykietę semantyczną i reaguje na onTap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: AppCard(
              semanticsLabel: 'Karta testowa',
              onTap: () => tapped = true,
              child: const Text('Zawartość karty'),
            ),
          ),
        ),
      );

      expect(find.text('Zawartość karty'), findsOneWidget);
      await tester.tap(find.text('Zawartość karty'));
      expect(tapped, isTrue);
    });

    testWidgets('StatusBadge.fromRouteStatus renderuje etykiety dla wszystkich statusów',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: Column(
              children: [
                StatusBadge.fromRouteStatus(RouteStatus.confirmed),
                StatusBadge.fromRouteStatus(RouteStatus.uncertain),
                StatusBadge.fromRouteStatus(RouteStatus.rejected),
              ],
            ),
          ),
        ),
      );

      expect(find.text('POTWIERDZONA'), findsOneWidget);
      expect(find.text('NIEPEWNA'), findsOneWidget);
      expect(find.text('ODRZUCONA'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
      expect(find.byIcon(Icons.help_outline), findsOneWidget);
      expect(find.byIcon(Icons.cancel), findsOneWidget);
    });

    testWidgets('StatusBadge.fromVerification renderuje poprawne ikony i teksty',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: Column(
              children: [
                StatusBadge.fromVerification(VerificationStatus.confirmed),
                StatusBadge.fromVerification(VerificationStatus.community_unverified),
                StatusBadge.fromVerification(VerificationStatus.conflict),
                StatusBadge.fromVerification(VerificationStatus.missing),
                StatusBadge.fromVerification(VerificationStatus.demo),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Potwierdzone źródło'), findsOneWidget);
      expect(find.text('Zapisano na tym urządzeniu'), findsOneWidget);
      expect(find.text('Konflikt zgłoszeń'), findsOneWidget);
      expect(find.text('Brak danych'), findsOneWidget);
      expect(find.text('Dane demonstracyjne'), findsOneWidget);
    });
  });
}
