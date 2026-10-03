import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/providers.dart';

class A11yActions extends ConsumerWidget {
  const A11yActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isHighContrast = ref.watch(highContrastThemeProvider);
    final textScale = ref.watch(textScaleProvider);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Semantics(
          button: true,
          label: 'Zmień rozmiar tekstu. Obecnie: ${(textScale * 100).toInt()}%',
          child: IconButton(
            tooltip: 'Zmień rozmiar tekstu',
            icon: const Icon(Icons.format_size),
            onPressed: () {
              // Cykliczna zmiana wielkości czcionki: 100% -> 150% -> 200% -> 100%
              final nextScale = textScale >= 2.0 ? 1.0 : textScale + 0.5;
              ref.read(textScaleProvider.notifier).state = nextScale;
            },
          ),
        ),
        Semantics(
          button: true,
          label: isHighContrast ? 'Wyłącz wysoki kontrast' : 'Włącz wysoki kontrast',
          child: IconButton(
            tooltip: 'Wysoki kontrast',
            icon: Icon(isHighContrast ? Icons.contrast : Icons.contrast_outlined),
            onPressed: () {
              ref.read(highContrastThemeProvider.notifier).state = !isHighContrast;
            },
          ),
        ),
      ],
    );
  }
}
