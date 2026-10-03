import 'package:flutter/material.dart';
import '../../core/design_system/design_system.dart';
import '../../domain/entities/observation.dart';
import '../../domain/entities/route_result.dart';

/// Etykieta statusu weryfikacji lub statusu trasy odporna na brak percepcji kolorów (a11y).
/// Wykorzystuje tokeny semantyczne z systemu designu.
class StatusBadge extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final RouteStatus? routeStatus;
  final VerificationStatus? verificationStatus;

  const StatusBadge({
    super.key,
    required this.label,
    required this.icon,
    this.backgroundColor,
    this.foregroundColor,
  })  : routeStatus = null,
        verificationStatus = null;

  const StatusBadge.fromRouteStatus(
    RouteStatus status, {
    super.key,
  })  : routeStatus = status,
        verificationStatus = null,
        label = null,
        icon = null,
        backgroundColor = null,
        foregroundColor = null;

  const StatusBadge.fromVerification(
    VerificationStatus status, {
    super.key,
  })  : verificationStatus = status,
        routeStatus = null,
        label = null,
        icon = null,
        backgroundColor = null,
        foregroundColor = null;

  @override
  Widget build(BuildContext context) {
    String resolvedLabel = label ?? '';
    IconData resolvedIcon = icon ?? Icons.help_outline;
    Color resolvedBg = backgroundColor ?? context.colors.surfaceSubtle;
    Color resolvedFg = foregroundColor ?? context.colors.textPrimary;

    if (routeStatus != null) {
      switch (routeStatus!) {
        case RouteStatus.confirmed:
          resolvedLabel = 'POTWIERDZONA';
          resolvedIcon = Icons.check_circle;
          resolvedBg = context.colors.statusConfirmedBg;
          resolvedFg = context.colors.statusConfirmedFg;
        case RouteStatus.uncertain:
          resolvedLabel = 'NIEPEWNA';
          resolvedIcon = Icons.help_outline;
          resolvedBg = context.colors.statusUncertainBg;
          resolvedFg = context.colors.statusUncertainFg;
        case RouteStatus.rejected:
          resolvedLabel = 'ODRZUCONA';
          resolvedIcon = Icons.cancel;
          resolvedBg = context.colors.statusRejectedBg;
          resolvedFg = context.colors.statusRejectedFg;
      }
    } else if (verificationStatus != null) {
      switch (verificationStatus!) {
        case VerificationStatus.confirmed:
          resolvedLabel = 'Potwierdzone źródło';
          resolvedIcon = Icons.verified;
          resolvedBg = context.colors.statusConfirmedBg;
          resolvedFg = context.colors.statusConfirmedFg;
        case VerificationStatus.community_unverified:
          resolvedLabel = 'Zapisano na tym urządzeniu';
          resolvedIcon = Icons.phone_android;
          resolvedBg = context.colors.statusCommunityBg;
          resolvedFg = context.colors.statusCommunityFg;
        case VerificationStatus.conflict:
          resolvedLabel = 'Konflikt zgłoszeń';
          resolvedIcon = Icons.warning_amber;
          resolvedBg = context.colors.statusConflictBg;
          resolvedFg = context.colors.statusConflictFg;
        case VerificationStatus.missing:
          resolvedLabel = 'Brak danych';
          resolvedIcon = Icons.question_mark;
          resolvedBg = context.colors.statusMissingBg;
          resolvedFg = context.colors.statusMissingFg;
        case VerificationStatus.demo:
          resolvedLabel = 'Dane demonstracyjne';
          resolvedIcon = Icons.science;
          resolvedBg = context.colors.statusDemoBg;
          resolvedFg = context.colors.statusDemoFg;
      }
    }

    return AppBadge(
      label: resolvedLabel,
      icon: resolvedIcon,
      backgroundColor: resolvedBg,
      foregroundColor: resolvedFg,
    );
  }
}
