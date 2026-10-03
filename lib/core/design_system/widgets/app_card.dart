import 'package:flutter/material.dart';
import '../theme/extensions/build_context_extensions.dart';

/// Współdzielony widget karty (Card) zgodny z regułami dostępności i tokenami systemu designu.
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderWidth;
  final double? elevation;
  final VoidCallback? onTap;
  final String? semanticsLabel;
  final bool? semanticsSelected;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
    this.elevation,
    this.onTap,
    this.semanticsLabel,
    this.semanticsSelected,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius = borderRadius ?? context.radii.card;
    final effectiveElevation = elevation ?? context.elevations.elevationCard;
    final effectivePadding = padding ?? context.spacing.cardPadding;
    final effectiveMargin = margin ?? context.spacing.cardMargin;
    final effectiveBg = backgroundColor ?? context.colors.cardBackground;

    Widget cardWidget = Card(
      elevation: effectiveElevation,
      color: effectiveBg,
      margin: effectiveMargin,
      shape: RoundedRectangleBorder(
        borderRadius: effectiveBorderRadius,
        side: borderColor != null
            ? BorderSide(
                color: borderColor!,
                width: borderWidth ?? context.dimensions.borderThin,
              )
            : BorderSide.none,
      ),
      child: onTap != null
          ? InkWell(
              onTap: onTap,
              borderRadius: effectiveBorderRadius,
              child: Padding(
                padding: effectivePadding,
                child: child,
              ),
            )
          : Padding(
              padding: effectivePadding,
              child: child,
            ),
    );

    if (semanticsLabel != null) {
      return Semantics(
        label: semanticsLabel,
        button: onTap != null,
        selected: semanticsSelected,
        child: cardWidget,
      );
    }

    return cardWidget;
  }
}
