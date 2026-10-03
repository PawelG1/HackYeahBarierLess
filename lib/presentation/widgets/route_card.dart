import 'package:flutter/material.dart';
import '../../core/design_system/design_system.dart';
import '../../domain/entities/route_result.dart';
import 'status_badge.dart';

/// Karta wariantu trasy do porównania na ekranie głównym.
class RouteCard extends StatelessWidget {
  final RouteResult route;
  final bool isSelected;
  final VoidCallback onTap;

  const RouteCard({
    super.key,
    required this.route,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final statusText = route.status.displayName;
    final lastDate = route.lastObservedDate;
    final dateStr = lastDate != null
        ? lastDate.toIso8601String().substring(0, 10)
        : 'brak danych';

    final semanticsLabel =
        '${route.title}. Status: $statusText. Długość: ${route.totalDistanceM} metrów. '
        '${route.reasons.isNotEmpty ? "Powód: ${route.reasons.first}." : ""} '
        'Data ostatniej informacji: $dateStr. Dotknij, aby wybrać trasę.';

    return Semantics(
      label: semanticsLabel,
      button: true,
      selected: isSelected,
      child: Card(
        elevation: isSelected
            ? context.elevations.elevationCardSelected
            : context.elevations.elevationCard,
        color: context.colors.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: context.radii.card,
          side: BorderSide(
            color: isSelected
                ? context.colors.primary
                : context.colors.borderSubtle,
            width: isSelected
                ? context.dimensions.borderSelected
                : context.dimensions.borderThin,
          ),
        ),
        margin: context.spacing.cardMargin,
        child: InkWell(
          onTap: onTap,
          borderRadius: context.radii.card,
          child: Padding(
            padding: context.spacing.cardPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        route.title,
                        style: context.typography.titleMedium.copyWith(
                          color: isSelected
                              ? context.colors.primary
                              : context.colors.textPrimary,
                        ),
                      ),
                    ),
                    StatusBadge.fromRouteStatus(route.status),
                  ],
                ),
                SizedBox(height: context.spacing.sm),
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: context.spacing.sm,
                  runSpacing: context.spacing.xs,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.straighten,
                          size: context.dimensions.iconMedium,
                          color: context.colors.textMuted,
                        ),
                        SizedBox(width: context.spacing.xs),
                        Flexible(
                          child: Text(
                            'Długość: ${route.totalDistanceM} m',
                            style: context.typography.bodyMediumMedium.copyWith(
                              color: context.colors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.update,
                          size: context.dimensions.iconMedium,
                          color: context.colors.textMuted,
                        ),
                        SizedBox(width: context.spacing.xs),
                        Flexible(
                          child: Text(
                            'Aktualność: $dateStr',
                            style: context.typography.bodySmall.copyWith(
                              color: context.colors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (route.reasons.isNotEmpty) ...[
                  SizedBox(height: context.spacing.md),
                  Container(
                    width: double.infinity,
                    padding: context.spacing.sourceRowPadding,
                    decoration: BoxDecoration(
                      color: route.status == RouteStatus.rejected
                          ? context.colors.statusRejectedBg
                          : context.colors.statusDemoBg,
                      borderRadius: context.radii.cardDense,
                    ),
                    child: Text(
                      route.reasons.first,
                      style: context.typography.banner.copyWith(
                        color: route.status == RouteStatus.rejected
                            ? context.colors.statusRejectedFg
                            : context.colors.statusUncertainFg,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
