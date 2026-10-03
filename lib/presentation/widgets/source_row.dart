import 'package:flutter/material.dart';
import '../../core/design_system/design_system.dart';
import '../../domain/entities/observation.dart';
import 'status_badge.dart';

/// Wiersz prezentujący źródło, datę oraz status weryfikacji cechy lub bariery.
class SourceRow extends StatelessWidget {
  final Observation observation;

  const SourceRow({super.key, required this.observation});

  @override
  Widget build(BuildContext context) {
    final dateStr = observation.observedAt.toIso8601String().substring(0, 10);

    return Semantics(
      label:
          'Źródło: ${observation.sourceName}, data: $dateStr, status: ${observation.verification.displayName}',
      child: Container(
        margin: context.spacing.sourceRowMargin,
        padding: context.spacing.sourceRowPadding,
        decoration: BoxDecoration(
          color: context.colors.surfaceContainerHighest.withValues(alpha: 0.4),
          borderRadius: context.radii.cardDense,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: context.spacing.sm,
              runSpacing: context.spacing.xs,
              children: [
                Text(
                  observation.sourceName,
                  style: context.typography.banner.copyWith(
                    color: context.colors.textPrimary,
                  ),
                ),
                StatusBadge.fromVerification(observation.verification),
              ],
            ),
            SizedBox(height: context.spacing.xs),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: context.spacing.space12,
              runSpacing: context.spacing.xs,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: context.dimensions.iconSmall,
                      color: context.colors.textSecondary,
                    ),
                    SizedBox(width: context.spacing.xs),
                    Flexible(
                      child: Text(
                        'Data: $dateStr',
                        style: context.typography.bodySmall.copyWith(
                          color: context.colors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                if (observation.sourceUrl != null)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.link,
                        size: context.dimensions.iconSmall,
                        color: context.colors.textSecondary,
                      ),
                      SizedBox(width: context.spacing.xs),
                      Flexible(
                        child: Text(
                          observation.sourceUrl!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.typography.bodySmall.copyWith(
                            color: context.colors.link,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
