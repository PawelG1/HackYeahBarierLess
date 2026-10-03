import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/design_system/design_system.dart';
import '../widgets/a11y_actions.dart';
import '../../domain/entities/observation.dart';
import '../../domain/entities/route_node.dart';
import '../../domain/entities/route_result.dart';
import '../viewmodels/route_comparison_vm.dart';
import '../viewmodels/route_setup_vm.dart';
import '../widgets/map_preview.dart';
import '../widgets/route_card.dart';
import '../widgets/route_steps.dart';
import 'route_navigation_screen.dart';
import 'place_detail_screen.dart';

/// Ekran 2: Porównanie tras z obsługą układu responsywnego (Telefon vs Tablet).
class RouteComparisonScreen extends ConsumerStatefulWidget {
  const RouteComparisonScreen({super.key});

  @override
  ConsumerState<RouteComparisonScreen> createState() =>
      _RouteComparisonScreenState();
}

class _RouteComparisonScreenState extends ConsumerState<RouteComparisonScreen> {
  int _viewMode = 0; // 0: Krok po kroku (Tekst), 1: Mapa (Podgląd)

  @override
  Widget build(BuildContext context) {
    final comparisonAsync = ref.watch(routeComparisonVmProvider);
    final setupState = ref.watch(routeSetupVmProvider);
    final allNodes = setupState.areaGraph?.nodes ?? <RouteNode>[];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Porównanie tras'),
        actions: [
          const A11yActions(),
          IconButton(
            tooltip: 'Wyczyść dane demonstracyjne',
            icon: const Icon(Icons.restore),
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              await ref
                  .read(routeComparisonVmProvider.notifier)
                  .clearDemoData();
              messenger.showSnackBar(
                const SnackBar(
                  content: Text(
                    'Zresetowano dane demonstracyjne do stanu początkowego.',
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: comparisonAsync.when(
        loading: () => const AppLoadingView(
          message: 'Wyszukiwanie i ewaluacja wariantów tras...',
        ),
        error: (err, stack) => AppErrorView(
          errorMessage: 'Wystąpił błąd: $err',
        ),
        data: (state) {
          if (state == null || state.routes.isEmpty) {
            return Center(
              child: Text(
                'Nie możemy potwierdzić trasy pomiędzy wybranymi punktami.',
                style: context.typography.bodyLarge,
              ),
            );
          }

          final selectedRoute = state.selectedRoute!;

          return LayoutBuilder(
            builder: (context, constraints) {
              final isTablet = constraints.maxWidth >=
                  context.dimensions.tabletBreakpoint;

              if (isTablet) {
                // Układ dwupanelowy dla tabletu
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Lewy panel: warianty tras
                    SizedBox(
                      width: context.dimensions.tabletSidePanelWidth,
                      child: ListView(
                        padding: context.spacing.screenPadding,
                        children: [
                          Text(
                            'Warianty trasy:',
                            style: context.typography.titleSmall,
                          ),
                          SizedBox(height: context.spacing.sm),
                          ...state.routes.asMap().entries.map((entry) {
                            final idx = entry.key;
                            final r = entry.value;
                            return RouteCard(
                              route: r,
                              isSelected: idx == state.selectedRouteIndex,
                              onTap: () => ref
                                  .read(routeComparisonVmProvider.notifier)
                                  .selectRoute(idx),
                            );
                          }),
                          SizedBox(height: context.spacing.base),
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              minimumSize: Size(
                                double.infinity,
                                context.dimensions.minTouchTarget,
                              ),
                            ),
                            onPressed: () => _openPlaceDetails(
                              context,
                              state.destinationPlaceId,
                            ),
                            icon: const Icon(Icons.info_outline),
                            label: const Text('Dostępność celu i wydarzenia'),
                          ),                          SizedBox(height: context.spacing.sm),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: context.colors.statusConfirmedBg,
                              foregroundColor: context.colors.background,
                              minimumSize: Size(
                                double.infinity,
                                context.dimensions.minTouchTarget,
                              ),
                            ),
                            onPressed: () => _startNavigation(context, selectedRoute, allNodes),
                            icon: const Icon(Icons.navigation),
                            label: const Text('Rozpocznij nawigację'),
                          ),

                        ],
                      ),
                    ),
                    VerticalDivider(
                      width: context.dimensions.borderThin,
                      color: context.colors.divider,
                    ),
                    // Prawy panel: podgląd wybranej trasy i kroki
                    Expanded(
                      child: ListView(
                        padding: context.spacing.screenPadding,
                        children: [
                          _buildSelectedRouteHeader(context, selectedRoute),
                          SizedBox(height: context.spacing.space12),
                          MapPreview(route: selectedRoute, allNodes: allNodes),
                          SizedBox(height: context.spacing.base),
                          Text(
                            'Trasa krok po kroku (Text-First):',
                            style: context.typography.titleSmall,
                          ),
                          SizedBox(height: context.spacing.sm),
                          RouteSteps(
                            route: selectedRoute,
                            onReportConflict: (edgeId) =>
                                _showAddObservationDialog(context, edgeId),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }

              // Układ jednokolumnowy dla telefonu (< 600 px)
              return ListView(
                padding: context.spacing.screenPadding,
                children: [
                  Text(
                    'Wybierz wariant trasy do szczegółowej oceny:',
                    style: context.typography.subhead,
                  ),
                  SizedBox(height: context.spacing.sm),
                  ...state.routes.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final r = entry.value;
                    return RouteCard(
                      route: r,
                      isSelected: idx == state.selectedRouteIndex,
                      onTap: () => ref
                          .read(routeComparisonVmProvider.notifier)
                          .selectRoute(idx),
                    );
                  }),
                  SizedBox(height: context.spacing.base),
                  _buildSelectedRouteHeader(context, selectedRoute),
                  SizedBox(height: context.spacing.space12),

                  // Przełącznik widoku: Tekst vs Mapa
                  SegmentedButton<int>(
                    segments: const [
                      ButtonSegment(
                        value: 0,
                        label: Text('Krok po kroku (Tekst)'),
                        icon: Icon(Icons.list_alt),
                      ),
                      ButtonSegment(
                        value: 1,
                        label: Text('Mapa (Podgląd)'),
                        icon: Icon(Icons.map_outlined),
                      ),
                    ],
                    selected: {_viewMode},
                    onSelectionChanged: (val) {
                      setState(() => _viewMode = val.first);
                    },
                  ),
                  SizedBox(height: context.spacing.space12),

                  if (_viewMode == 0) ...[
                    RouteSteps(
                      route: selectedRoute,
                      onReportConflict: (edgeId) =>
                          _showAddObservationDialog(context, edgeId),
                    ),
                  ] else ...[
                    MapPreview(route: selectedRoute, allNodes: allNodes),
                    SizedBox(height: context.spacing.space12),
                    RouteSteps(
                      route: selectedRoute,
                      onReportConflict: (edgeId) =>
                          _showAddObservationDialog(context, edgeId),
                    ),
                  ],

                  SizedBox(height: context.spacing.lg),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.colors.primary,
                      foregroundColor: context.colors.onPrimary,
                      padding: context.spacing.buttonDensePadding,
                      minimumSize: context.dimensions.fullWidthButtonDenseSize,
                    ),
                    onPressed: () => _openPlaceDetails(
                      context,
                      state.destinationPlaceId,
                    ),
                    icon: const Icon(Icons.theater_comedy),
                    label: Text(
                      'Sprawdź dostępność wejścia i spektakle',
                      style: context.typography.button,
                    ),
                  ),                  SizedBox(height: context.spacing.sm),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.colors.statusConfirmedBg,
                      foregroundColor: context.colors.background,
                      padding: context.spacing.buttonDensePadding,
                      minimumSize: context.dimensions.fullWidthButtonDenseSize,
                    ),
                    onPressed: () => _startNavigation(context, selectedRoute, allNodes),
                    icon: const Icon(Icons.navigation),
                    label: Text(
                      'Rozpocznij nawigację',
                      style: context.typography.button,
                    ),
                  ),

                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSelectedRouteHeader(BuildContext context, RouteResult route) {
    return Container(
      padding: context.spacing.cardPaddingDense,
      decoration: BoxDecoration(
        color: context.colors.surfaceSubtle,
        borderRadius: context.radii.cardDense,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.directions_walk,
                size: context.dimensions.iconLarge,
                color: context.colors.primary,
              ),
              SizedBox(width: context.spacing.sm),
              Expanded(
                child: Text(
                  'Wybrany wariant: ${route.title}',
                  style: context.typography.subhead.copyWith(
                    color: context.colors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          if (route.reasons.isNotEmpty) ...[
            SizedBox(height: context.spacing.s),
            ...route.reasons.map(
              (r) => Padding(
                padding: EdgeInsets.symmetric(vertical: context.spacing.xxs),
                child: Text(
                  '• $r',
                  style: context.typography.bodySmall.copyWith(
                    color: route.status == RouteStatus.rejected
                        ? context.colors.statusConflictFg
                        : context.colors.statusUncertainFg,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _startNavigation(BuildContext context, RouteResult route, List<RouteNode> allNodes) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RouteNavigationScreen(route: route, allNodes: allNodes),
      ),
    );
  }

  void _openPlaceDetails(BuildContext context, String placeId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PlaceDetailScreen(placeId: placeId),
      ),
    );
  }

  void _showAddObservationDialog(BuildContext context, String edgeId) {
    String selectedFeature = 'stairs';
    String selectedValue = 'present';

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              title: const Text('Zgłoś barierę na odcinku'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Odcinek: $edgeId',
                    style: context.typography.labelMedium,
                  ),
                  SizedBox(height: context.spacing.space12),
                  const Text('Typ zgłaszanej cechy / bariery:'),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: selectedFeature,
                    items: const [
                      DropdownMenuItem(
                        value: 'stairs',
                        child: Text('Schody bez windy / brak podjazdu'),
                      ),
                      DropdownMenuItem(
                        value: 'curb_ramp',
                        child: Text('Wysoki krawężnik / uszkodzona rampa'),
                      ),
                      DropdownMenuItem(
                        value: 'surface_quality',
                        child: Text('Remont nawierzchni / wykop'),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setDialogState(() => selectedFeature = val);
                      }
                    },
                  ),
                  SizedBox(height: context.spacing.sm),
                  const Text('Stan:'),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: selectedValue,
                    items: const [
                      DropdownMenuItem(
                        value: 'present',
                        child: Text('Bariera występuje (obecna)'),
                      ),
                      DropdownMenuItem(
                        value: 'absent',
                        child: Text('Bariera usunięta (brak)'),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setDialogState(() => selectedValue = val);
                      }
                    },
                  ),
                  SizedBox(height: context.spacing.md),
                  Text(
                    'Uwaga: Zgłoszenie zostanie zapisane na Twoim urządzeniu.',
                    style: context.typography.caption.copyWith(
                      color: context.colors.textMuted,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Anuluj'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final obs = Observation(
                      id: 'local-obs-${DateTime.now().millisecondsSinceEpoch}',
                      targetType: 'edge',
                      targetId: edgeId,
                      feature: selectedFeature,
                      value: selectedValue,
                      sourceName: 'Lokalne zgłoszenie użytkownika',
                      sourceUrl: null,
                      observedAt: DateTime.now(),
                      verification: VerificationStatus.community_unverified,
                    );

                    final messenger = ScaffoldMessenger.of(context);
                    Navigator.of(ctx).pop();
                    await ref
                        .read(routeComparisonVmProvider.notifier)
                        .addLocalObservation(obs);

                    messenger.showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Zapisano lokalną obserwację. Trasy zostały przeliczone.',
                        ),
                      ),
                    );
                  },
                  child: const Text('Zapisz zgłoszenie'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
