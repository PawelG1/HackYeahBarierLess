import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/design_system/design_system.dart';
import 'core/di/providers.dart';
import 'presentation/screens/route_setup_screen.dart';

/// Główny widget aplikacji konfigurujący MaterialApp, motyw i dostępność (a11y).
class KrakowBezBarierApp extends ConsumerWidget {
  const KrakowBezBarierApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isHighContrast = ref.watch(highContrastThemeProvider);
    final textScale = ref.watch(textScaleProvider);

    return MaterialApp(
      title: 'Trasa bez domysłów — Kraków bez barier',
      debugShowCheckedModeBanner: false,
      theme: isHighContrast ? AppTheme.highContrastDarkTheme : AppTheme.darkTheme,
      builder: (context, child) {
        final data = MediaQuery.of(context);
        return MediaQuery(
          data: data.copyWith(
            textScaler: TextScaler.linear(
              data.textScaler.scale(1.0) * textScale,
            ),
          ),
          child: child!,
        );
      },
      home: const RouteSetupScreen(),
    );
  }
}
