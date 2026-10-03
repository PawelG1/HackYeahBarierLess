import 'package:flutter/material.dart';
import '../../core/design_system/design_system.dart';
import '../../domain/entities/route_result.dart';
import 'source_row.dart';

/// Widok trasy krok po kroku (Text-First), w 100% czytelny i funkcjonalny bez mapy.
class RouteSteps extends StatelessWidget {
  final RouteResult route;
  final Function(String edgeId)? onReportConflict;

  const RouteSteps({
    super.key,
    required this.route,
    this.onReportConflict,
  });

  String _formatFeature(String feature) {
    switch (feature) {
      case 'stairs':
        return 'Schody bez podjazdu';
      case 'curb_ramp':
        return 'Przejście dla pieszych z obniżonym krawężnikiem';
      case 'asphalt_path':
        return 'Płaska alejka asfaltowa';
      case 'flat_pavement':
        return 'Płaski chodnik bez barier';
      case 'sidewalk':
        return 'Chodnik miejski';
      case 'pedestrian_zone':
        return 'Strefa piesza (płyty kamienne)';
      case 'asphalt_ramp':
        return 'Pochylnia asfaltowa z poręczą';
      default:
        return 'Odcinek: $feature';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (route.steps.isEmpty) {
      return Center(
        child: Padding(
          padding: context.spacing.screenPadding,
          child: Text(
            'Brak zdefiniowanych kroków dla tej trasy.',
            style: context.typography.bodyMedium.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: route.steps.length,
      itemBuilder: (context, index) {
        final step = route.steps[index];
        final edge = step.edge;
        final stepNumber = index + 1;

        final isRejectedOrExcluded = step.isExcludedBarrier;
        final hasConflict = step.hasConflict;

        final borderColor = isRejectedOrExcluded
            ? context.colors.statusRejectedBorder
            : (hasConflict
                ? context.colors.warning
                : context.colors.borderSubtle);

        final borderWidth = (isRejectedOrExcluded || hasConflict)
            ? context.dimensions.borderThick
            : context.dimensions.borderThin;

        final avatarBg = isRejectedOrExcluded
            ? context.colors.error
            : (hasConflict ? context.colors.warning : context.colors.primary);

        return Card(
          margin: context.spacing.cardMarginDense,
          elevation: context.elevations.elevationSubtle,
          color: context.colors.cardBackground,
          shape: RoundedRectangleBorder(
            borderRadius: context.radii.cardDense,
            side: BorderSide(
              color: borderColor,
              width: borderWidth,
            ),
          ),
          child: Padding(
            padding: context.spacing.cardPaddingDense,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: context.dimensions.stepAvatarRadius,
                      backgroundColor: avatarBg,
                      child: Text(
                        '$stepNumber',
                        style: context.typography.stepNumber.copyWith(
                          color: context.colors.textInverse,
                        ),
                      ),
                    ),
                    SizedBox(width: context.spacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _formatFeature(edge.feature),
                            style: context.typography.subhead.copyWith(
                              color: isRejectedOrExcluded
                                  ? context.colors.statusConflictFg
                                  : context.colors.textPrimary,
                            ),
                          ),
                          SizedBox(height: context.spacing.xxs),
                          Text(
                            'Długość odcinka: ${edge.distanceM} m (od: ${edge.from} do: ${edge.to})',
                            style: context.typography.bodySmall.copyWith(
                              color: context.colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (step.barrierReason != null) ...[
                  SizedBox(height: context.spacing.sm),
                  Container(
                    width: double.infinity,
                    padding: context.spacing.routeStepReasonPadding,
                    decoration: BoxDecoration(
                      color: context.colors.statusRejectedBg,
                      borderRadius: context.radii.tag,
                    ),
                    child: Text(
                      '⚠️ ${step.barrierReason!}',
                      style: context.typography.bodySmallSemiBold.copyWith(
                        color: context.colors.statusConflictFg,
                      ),
                    ),
                  ),
                ],
                if (hasConflict) ...[
                  SizedBox(height: context.spacing.sm),
                  Container(
                    width: double.infinity,
                    padding: context.spacing.routeStepReasonPadding,
                    decoration: BoxDecoration(
                      color: context.colors.statusUncertainBg,
                      borderRadius: context.radii.tag,
                    ),
                    child: Text(
                      '⚠️ Wykryto sprzeczne zgłoszenia dotyczące tego odcinka. Zapoznaj się z obiema obserwacjami poniżej.',
                      style: context.typography.bodySmallSemiBold.copyWith(
                        color: context.colors.statusUncertainFg,
                      ),
                    ),
                  ),
                ],
                if (step.observations.isNotEmpty) ...[
                  SizedBox(height: context.spacing.sm),
                  Text(
                    'Zarejestrowane obserwacje i audyty:',
                    style: context.typography.labelSmall.copyWith(
                      color: context.colors.textPrimary,
                    ),
                  ),
                  ...step.observations.map(
                    (obs) => SourceRow(observation: obs),
                  ),
                ],
                if (onReportConflict != null) ...[
                  SizedBox(height: context.spacing.sm),
                  Align(
                    alignment: Alignment.centerRight,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: context.spacing.buttonSmallPadding,
                        minimumSize:
                            context.dimensions.touchTargetButtonMinSize,
                      ),
                      onPressed: () => onReportConflict!(edge.id),
                      icon: Icon(
                        Icons.report_problem_outlined,
                        size: context.dimensions.iconMedium,
                      ),
                      label: Text(
                        'Zgłoś barierę / sprzeczność',
                        style: context.typography.buttonSmall,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
