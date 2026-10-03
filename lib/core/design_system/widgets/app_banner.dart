import 'package:flutter/material.dart';
import '../theme/extensions/build_context_extensions.dart';

/// Współdzielony widget informacyjno-ostrzegawczy (Banner).
class AppBanner extends StatelessWidget {
  final Widget icon;
  final Widget child;
  final Color backgroundColor;
  final Color? borderColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadiusGeometry? borderRadius;

  const AppBanner({
    super.key,
    required this.icon,
    required this.child,
    required this.backgroundColor,
    this.borderColor,
    this.padding,
    this.margin,
    this.borderRadius,
  });

  /// Wzorcowy baner ostrzegawczy o danych demonstracyjnych.
  factory AppBanner.demo({
    Key? key,
    required BuildContext context,
    required String message,
  }) {
    return AppBanner(
      key: key,
      icon: Icon(
        Icons.info_outline,
        color: context.colors.warningIcon,
        size: context.dimensions.iconLarge,
      ),
      backgroundColor: context.colors.warningBg,
      borderColor: context.colors.warningBorder,
      padding: context.spacing.bannerPadding,
      margin: context.spacing.bannerMargin,
      borderRadius: context.radii.banner,
      child: Text(
        message,
        style: context.typography.banner.copyWith(
          color: context.colors.warningFg,
        ),
      ),
    );
  }

  /// Wzorcowy baner wsparcia i asysty (zielony).
  factory AppBanner.support({
    Key? key,
    required BuildContext context,
    required String message,
  }) {
    return AppBanner(
      key: key,
      icon: Icon(
        Icons.support_agent,
        color: context.colors.supportBannerIcon,
        size: context.dimensions.iconXLarge,
      ),
      backgroundColor: context.colors.supportBannerBg,
      borderColor: context.colors.supportBannerBorder,
      padding: context.spacing.bannerPadding,
      margin: EdgeInsets.zero,
      borderRadius: context.radii.banner,
      child: Text(
        message,
        style: context.typography.bannerBody.copyWith(
          color: context.colors.supportBannerText,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? context.spacing.bannerPadding,
      margin: margin ?? EdgeInsets.zero,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius ?? context.radii.banner,
        border: borderColor != null
            ? Border.all(
                color: borderColor!,
                width: context.dimensions.borderThin,
              )
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          icon,
          SizedBox(width: context.spacing.md),
          Expanded(child: child),
        ],
      ),
    );
  }
}
