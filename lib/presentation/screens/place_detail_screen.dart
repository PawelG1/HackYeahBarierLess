import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/design_system/design_system.dart';
import '../widgets/a11y_actions.dart';
import '../viewmodels/place_detail_vm.dart';
import '../widgets/source_row.dart';

/// Ekran 3: Szczegół dostępności wejścia do obiektu docelowego i wydarzeń kulturalnych.
class PlaceDetailScreen extends ConsumerWidget {
  final String placeId;

  const PlaceDetailScreen({super.key, required this.placeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailState = ref.watch(placeDetailVmProvider(placeId));

    if (detailState.isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Szczegóły obiektu')),
        body: const AppLoadingView(message: 'Wczytywanie szczegółów obiektu...'),
      );
    }

    if (detailState.errorMessage != null || detailState.place == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Błąd')),
        body: AppErrorView(
          errorMessage: detailState.errorMessage ?? 'Nie znaleziono obiektu',
        ),
      );
    }

    final place = detailState.place!;
    final obs = detailState.observations;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          place.name,
          style: context.typography.titleMedium,
        ),
        actions: const [A11yActions()],
      ),
      body: SingleChildScrollView(
        padding: context.spacing.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nagłówek obiektu
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.theater_comedy,
                        size: context.dimensions.iconXLarge,
                        color: context.colors.placeAccent,
                      ),
                      SizedBox(width: context.spacing.sm),
                      Expanded(
                        child: Text(
                          place.name,
                          style: context.typography.titleMedium,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: context.spacing.sm),
                  Text(
                    'Identyfikator węzła: ${place.nodeId}',
                    style: context.typography.banner.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: context.spacing.base),

            // Sekcja audytu wejścia
            Text(
              'Audyt dostępności wejścia i wnętrza',
              style: context.typography.sectionHeader,
            ),
            SizedBox(height: context.spacing.sm),
            if (obs.isEmpty)
              Text(
                'Brak zarejestrowanych obserwacji dla tego obiektu.',
                style: context.typography.bodyMedium.copyWith(
                  color: context.colors.textSecondary,
                ),
              )
            else
              ...obs.map((o) {
                return AppCard(
                  margin: context.spacing.cardMarginVertical,
                  padding: context.spacing.cardPaddingDense,
                  borderRadius: context.radii.cardDense,
                  borderColor: context.colors.borderSubtle,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cecha: ${o.feature}',
                        style: context.typography.labelMedium,
                      ),
                      SizedBox(height: context.spacing.xs),
                      Text(
                        'Wartość: ${o.value}',
                        style: context.typography.bodyMedium,
                      ),
                      SourceRow(observation: o),
                    ],
                  ),
                );
              }),
            SizedBox(height: context.spacing.xl),

            // Informacje o koordynacji i wsparciu
            AppBanner.support(
              context: context,
              message:
                  'Przed wizytą możesz skontaktować się z Działem Dostępności obiektu w celu rezerwacji asysty lub zwiedzania dotykowego (touch tour).',
            ),
          ],
        ),
      ),
    );
  }
}
