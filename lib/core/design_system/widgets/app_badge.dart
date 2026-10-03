import 'package:flutter/material.dart';
import '../theme/extensions/build_context_extensions.dart';

/// Współdzielony widget semantycznej etykiety statusu (Status Badge / Chip).
/// Odporny na brak percepcji kolorów (ikona + tekst + etykieta czytnika ekranu).
class AppBadge extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color? borderColor;

  const AppBadge({
    super.key,
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.foregroundColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Status: $label',
      child: Container(
        padding: context.spacing.badgePadding,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: context.radii.badge,
          border: Border.all(
            color: borderColor ?? foregroundColor.withValues(alpha: 0.3),
            width: context.dimensions.borderMedium,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: context.dimensions.iconBase,
              color: foregroundColor,
            ),
            SizedBox(width: context.spacing.s),
            Flexible(
              child: Text(
                label,
                style: context.typography.badge.copyWith(
                  color: foregroundColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
