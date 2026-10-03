import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/design_system/design_system.dart';
import '../widgets/a11y_actions.dart';
import '../viewmodels/route_comparison_vm.dart';
import '../viewmodels/route_setup_vm.dart';
import 'route_comparison_screen.dart';

/// Ekran 1: Wybór potrzeb, punktu startowego i docelowego.
class RouteSetupScreen extends ConsumerWidget {
  const RouteSetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setupState = ref.watch(routeSetupVmProvider);
    final setupVm = ref.read(routeSetupVmProvider.notifier);

    if (setupState.isLoading) {
      return const Scaffold(
        body: AppLoadingView(
          message: 'Ładowanie danych miejskich Krakowa...',
        ),
      );
    }

    if (setupState.errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Błąd')),
        body: AppErrorView(
          errorMessage: setupState.errorMessage!,
        ),
      );
    }

    final area = setupState.areaGraph;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Trasa bez domysłów',
          style: context.typography.titleLarge,
        ),
        actions: [
          const A11yActions(),
          IconButton(
            tooltip: 'Wyczyść dane demonstracyjne',
            icon: const Icon(Icons.restore),
            onPressed: () async {
              await ref
                  .read(routeComparisonVmProvider.notifier)
                  .clearDemoData();
              await ref.read(routeSetupVmProvider.notifier).reload();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Przywrócono pierwotne dane demonstracyjne.'),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: context.spacing.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            // Karta preferencji dostępności
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Twoje preferencje trasy',
                    style: context.typography.titleSmall,
                  ),
                  SizedBox(height: context.spacing.space12),
                  Semantics(
                    label: 'Przełącznik: Unikam schodów',
                    child: SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        'Unikam schodów',
                        style: context.typography.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        'Wymaga płaskiej trasy, rampy lub windy (profil wózka)',
                        style: context.typography.bodyMedium.copyWith(
                          color: context.colors.textSecondary,
                        ),
                      ),
                      value: setupState.avoidStairs,
                      onChanged: (val) => setupVm.toggleAvoidStairs(val),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: context.spacing.base),

            // Wybór punktu startowego
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Punkt początkowy (Start)',
                    style: context.typography.titleSmall,
                  ),
                  SizedBox(height: context.spacing.sm),
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    initialValue: setupState.selectedStartNodeId,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      contentPadding: context.spacing.inputContentPadding,
                    ),
                    items: (area?.nodes ?? []).map((node) {
                      return DropdownMenuItem(
                        value: node.id,
                        child: Text(
                          '${node.id} (Współrzędne: ${node.lat.toStringAsFixed(4)}, ${node.lon.toStringAsFixed(4)})',
                          style: context.typography.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setupVm.selectStartNode(val);
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: context.spacing.base),

            // Wybór miejsca docelowego
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cel podróży (Miejsce)',
                    style: context.typography.titleSmall,
                  ),
                  SizedBox(height: context.spacing.sm),
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    initialValue: setupState.selectedDestinationPlaceId,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      contentPadding: context.spacing.inputContentPadding,
                    ),
                    items: (area?.places ?? []).map((place) {
                      return DropdownMenuItem(
                        value: place.id,
                        child: Text(
                          place.name,
                          style: context.typography.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setupVm.selectDestinationPlace(val);
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: context.spacing.xl),

            // Przycisk porównania tras (a11y min 48dp)
            Semantics(
              label: 'Przycisk: Porównaj warianty trasy',
              button: true,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colors.primary,
                  foregroundColor: context.colors.onPrimary,
                  padding: context.spacing.buttonPadding,
                  minimumSize: context.dimensions.fullWidthButtonSize,
                  shape: RoundedRectangleBorder(
                    borderRadius: context.radii.button,
                  ),
                ),
                onPressed: (setupState.selectedStartNodeId != null &&
                        setupState.selectedDestinationPlaceId != null)
                    ? () async {
                        await ref
                            .read(routeComparisonVmProvider.notifier)
                            .evaluate(
                              startNodeId: setupState.selectedStartNodeId!,
                              destinationPlaceId:
                                  setupState.selectedDestinationPlaceId!,
                              avoidStairs: setupState.avoidStairs,
                            );

                        if (context.mounted) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const RouteComparisonScreen(),
                            ),
                          );
                        }
                      }
                    : null,
                icon: const Icon(Icons.alt_route),
                label: Text(
                  'Porównaj warianty tras',
                  style: context.typography.button,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
