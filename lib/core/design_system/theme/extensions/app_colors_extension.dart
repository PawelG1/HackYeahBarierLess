import 'package:flutter/material.dart';
import '../../tokens/primitives/app_colors_primitive.dart';

/// Rozszerzenie motywu Fluttera udostępniające semantyczne kolory aplikacji.
/// Umożliwia dostęp w drzewie widgetów przez `context.colors.primary` itp.
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  // Podstawowe kolory marki
  final Color primary;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;

  // Tła i powierzchnie
  final Color background;
  final Color surface;
  final Color onSurface;
  final Color surfaceSubtle;
  final Color surfaceContainerHighest;
  final Color cardBackground;

  // Typografia i teksty
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color textInverse;
  final Color textAttribution;

  // Krawędzie i separatory
  final Color borderSubtle;
  final Color borderStrong;
  final Color divider;

  // Statusy weryfikacji i tras (a11y)
  final Color statusConfirmedBg;
  final Color statusConfirmedFg;
  final Color statusConfirmedBorder;

  final Color statusUncertainBg;
  final Color statusUncertainFg;
  final Color statusUncertainBorder;

  final Color statusRejectedBg;
  final Color statusRejectedFg;
  final Color statusRejectedBorder;

  final Color statusConflictBg;
  final Color statusConflictFg;
  final Color statusConflictBorder;

  final Color statusDemoBg;
  final Color statusDemoFg;
  final Color statusDemoBorder;

  final Color statusCommunityBg;
  final Color statusCommunityFg;
  final Color statusCommunityBorder;

  final Color statusMissingBg;
  final Color statusMissingFg;
  final Color statusMissingBorder;

  // Komunikaty, błędy i ostrzeżenia
  final Color error;
  final Color onError;
  final Color errorBg;
  final Color errorFg;
  final Color errorBorder;

  final Color warning;
  final Color onWarning;
  final Color warningBg;
  final Color warningFg;
  final Color warningBorder;
  final Color warningIcon;

  final Color info;
  final Color infoBg;
  final Color infoFg;
  final Color infoBorder;

  // Dedykowane akcenty
  final Color link;
  final Color placeAccent;

  // Sekcja wsparcia
  final Color supportBannerBg;
  final Color supportBannerBorder;
  final Color supportBannerIcon;
  final Color supportBannerText;

  // Wizualizacja mapy
  final Color mapRouteConfirmed;
  final Color mapRouteUncertain;
  final Color mapRouteRejected;
  final Color mapRouteDefault;
  final Color mapMarkerStart;
  final Color mapMarkerDestination;
  final Color mapAttributionBg;
  final Color mapAttributionText;

  const AppColorsExtension({
    required this.primary,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.background,
    required this.surface,
    required this.onSurface,
    required this.surfaceSubtle,
    required this.surfaceContainerHighest,
    required this.cardBackground,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.textInverse,
    required this.textAttribution,
    required this.borderSubtle,
    required this.borderStrong,
    required this.divider,
    required this.statusConfirmedBg,
    required this.statusConfirmedFg,
    required this.statusConfirmedBorder,
    required this.statusUncertainBg,
    required this.statusUncertainFg,
    required this.statusUncertainBorder,
    required this.statusRejectedBg,
    required this.statusRejectedFg,
    required this.statusRejectedBorder,
    required this.statusConflictBg,
    required this.statusConflictFg,
    required this.statusConflictBorder,
    required this.statusDemoBg,
    required this.statusDemoFg,
    required this.statusDemoBorder,
    required this.statusCommunityBg,
    required this.statusCommunityFg,
    required this.statusCommunityBorder,
    required this.statusMissingBg,
    required this.statusMissingFg,
    required this.statusMissingBorder,
    required this.error,
    required this.onError,
    required this.errorBg,
    required this.errorFg,
    required this.errorBorder,
    required this.warning,
    required this.onWarning,
    required this.warningBg,
    required this.warningFg,
    required this.warningBorder,
    required this.warningIcon,
    required this.info,
    required this.infoBg,
    required this.infoFg,
    required this.infoBorder,
    required this.link,
    required this.placeAccent,
    required this.supportBannerBg,
    required this.supportBannerBorder,
    required this.supportBannerIcon,
    required this.supportBannerText,
    required this.mapRouteConfirmed,
    required this.mapRouteUncertain,
    required this.mapRouteRejected,
    required this.mapRouteDefault,
    required this.mapMarkerStart,
    required this.mapMarkerDestination,
    required this.mapAttributionBg,
    required this.mapAttributionText,
  });

  /// Domyślna, kontrastowa paleta jasna (Light Theme).
  static const AppColorsExtension light = AppColorsExtension(
    primary: AppColorsPrimitive.blue800,
    onPrimary: AppColorsPrimitive.white,
    primaryContainer: AppColorsPrimitive.blue50,
    onPrimaryContainer: AppColorsPrimitive.blue900,
    background: AppColorsPrimitive.grey50,
    surface: AppColorsPrimitive.white,
    onSurface: AppColorsPrimitive.grey900,
    surfaceSubtle: AppColorsPrimitive.grey100,
    surfaceContainerHighest: AppColorsPrimitive.grey200,
    cardBackground: AppColorsPrimitive.white,
    textPrimary: AppColorsPrimitive.grey900,
    textSecondary: AppColorsPrimitive.grey700,
    textMuted: AppColorsPrimitive.grey500,
    textInverse: AppColorsPrimitive.white,
    textAttribution: AppColorsPrimitive.black87,
    borderSubtle: AppColorsPrimitive.grey300,
    borderStrong: AppColorsPrimitive.grey500,
    divider: AppColorsPrimitive.grey300,
    statusConfirmedBg: AppColorsPrimitive.green50,
    statusConfirmedFg: AppColorsPrimitive.green900,
    statusConfirmedBorder: AppColorsPrimitive.green300,
    statusUncertainBg: AppColorsPrimitive.orange50,
    statusUncertainFg: AppColorsPrimitive.orange900,
    statusUncertainBorder: AppColorsPrimitive.orange800,
    statusRejectedBg: AppColorsPrimitive.red50,
    statusRejectedFg: AppColorsPrimitive.red900,
    statusRejectedBorder: AppColorsPrimitive.red400,
    statusConflictBg: AppColorsPrimitive.red50,
    statusConflictFg: AppColorsPrimitive.red800,
    statusConflictBorder: AppColorsPrimitive.red400,
    statusDemoBg: AppColorsPrimitive.amber50,
    statusDemoFg: AppColorsPrimitive.amber900,
    statusDemoBorder: AppColorsPrimitive.amber800,
    statusCommunityBg: AppColorsPrimitive.blue50,
    statusCommunityFg: AppColorsPrimitive.blue900,
    statusCommunityBorder: AppColorsPrimitive.blue100,
    statusMissingBg: AppColorsPrimitive.slate50,
    statusMissingFg: AppColorsPrimitive.slate800,
    statusMissingBorder: AppColorsPrimitive.grey300,
    error: AppColorsPrimitive.red600,
    onError: AppColorsPrimitive.white,
    errorBg: AppColorsPrimitive.red50,
    errorFg: AppColorsPrimitive.red800,
    errorBorder: AppColorsPrimitive.red400,
    warning: AppColorsPrimitive.orange700,
    onWarning: AppColorsPrimitive.white,
    warningBg: AppColorsPrimitive.orange50,
    warningFg: AppColorsPrimitive.orange900,
    warningBorder: AppColorsPrimitive.orange800,
    warningIcon: AppColorsPrimitive.orange900,
    info: AppColorsPrimitive.blue700,
    infoBg: AppColorsPrimitive.blue50,
    infoFg: AppColorsPrimitive.blue900,
    infoBorder: AppColorsPrimitive.blue100,
    link: AppColorsPrimitive.blue700,
    placeAccent: AppColorsPrimitive.indigo500,
    supportBannerBg: AppColorsPrimitive.green50,
    supportBannerBorder: AppColorsPrimitive.green300,
    supportBannerIcon: AppColorsPrimitive.green700,
    supportBannerText: AppColorsPrimitive.grey900,
    mapRouteConfirmed: AppColorsPrimitive.green600,
    mapRouteUncertain: AppColorsPrimitive.orange700,
    mapRouteRejected: AppColorsPrimitive.red700,
    mapRouteDefault: AppColorsPrimitive.blue500,
    mapMarkerStart: AppColorsPrimitive.blueAccent,
    mapMarkerDestination: AppColorsPrimitive.redAccent,
    mapAttributionBg: AppColorsPrimitive.whiteAlpha85,
    mapAttributionText: AppColorsPrimitive.black87,
  );

  @override
  ThemeExtension<AppColorsExtension> copyWith({
    Color? primary,
    Color? onPrimary,
    Color? primaryContainer,
    Color? onPrimaryContainer,
    Color? background,
    Color? surface,
    Color? onSurface,
    Color? surfaceSubtle,
    Color? surfaceContainerHighest,
    Color? cardBackground,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? textInverse,
    Color? textAttribution,
    Color? borderSubtle,
    Color? borderStrong,
    Color? divider,
    Color? statusConfirmedBg,
    Color? statusConfirmedFg,
    Color? statusConfirmedBorder,
    Color? statusUncertainBg,
    Color? statusUncertainFg,
    Color? statusUncertainBorder,
    Color? statusRejectedBg,
    Color? statusRejectedFg,
    Color? statusRejectedBorder,
    Color? statusConflictBg,
    Color? statusConflictFg,
    Color? statusConflictBorder,
    Color? statusDemoBg,
    Color? statusDemoFg,
    Color? statusDemoBorder,
    Color? statusCommunityBg,
    Color? statusCommunityFg,
    Color? statusCommunityBorder,
    Color? statusMissingBg,
    Color? statusMissingFg,
    Color? statusMissingBorder,
    Color? error,
    Color? onError,
    Color? errorBg,
    Color? errorFg,
    Color? errorBorder,
    Color? warning,
    Color? onWarning,
    Color? warningBg,
    Color? warningFg,
    Color? warningBorder,
    Color? warningIcon,
    Color? info,
    Color? infoBg,
    Color? infoFg,
    Color? infoBorder,
    Color? link,
    Color? placeAccent,
    Color? supportBannerBg,
    Color? supportBannerBorder,
    Color? supportBannerIcon,
    Color? supportBannerText,
    Color? mapRouteConfirmed,
    Color? mapRouteUncertain,
    Color? mapRouteRejected,
    Color? mapRouteDefault,
    Color? mapMarkerStart,
    Color? mapMarkerDestination,
    Color? mapAttributionBg,
    Color? mapAttributionText,
  }) {
    return AppColorsExtension(
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      primaryContainer: primaryContainer ?? this.primaryContainer,
      onPrimaryContainer: onPrimaryContainer ?? this.onPrimaryContainer,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      onSurface: onSurface ?? this.onSurface,
      surfaceSubtle: surfaceSubtle ?? this.surfaceSubtle,
      surfaceContainerHighest:
          surfaceContainerHighest ?? this.surfaceContainerHighest,
      cardBackground: cardBackground ?? this.cardBackground,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      textInverse: textInverse ?? this.textInverse,
      textAttribution: textAttribution ?? this.textAttribution,
      borderSubtle: borderSubtle ?? this.borderSubtle,
      borderStrong: borderStrong ?? this.borderStrong,
      divider: divider ?? this.divider,
      statusConfirmedBg: statusConfirmedBg ?? this.statusConfirmedBg,
      statusConfirmedFg: statusConfirmedFg ?? this.statusConfirmedFg,
      statusConfirmedBorder:
          statusConfirmedBorder ?? this.statusConfirmedBorder,
      statusUncertainBg: statusUncertainBg ?? this.statusUncertainBg,
      statusUncertainFg: statusUncertainFg ?? this.statusUncertainFg,
      statusUncertainBorder:
          statusUncertainBorder ?? this.statusUncertainBorder,
      statusRejectedBg: statusRejectedBg ?? this.statusRejectedBg,
      statusRejectedFg: statusRejectedFg ?? this.statusRejectedFg,
      statusRejectedBorder: statusRejectedBorder ?? this.statusRejectedBorder,
      statusConflictBg: statusConflictBg ?? this.statusConflictBg,
      statusConflictFg: statusConflictFg ?? this.statusConflictFg,
      statusConflictBorder: statusConflictBorder ?? this.statusConflictBorder,
      statusDemoBg: statusDemoBg ?? this.statusDemoBg,
      statusDemoFg: statusDemoFg ?? this.statusDemoFg,
      statusDemoBorder: statusDemoBorder ?? this.statusDemoBorder,
      statusCommunityBg: statusCommunityBg ?? this.statusCommunityBg,
      statusCommunityFg: statusCommunityFg ?? this.statusCommunityFg,
      statusCommunityBorder:
          statusCommunityBorder ?? this.statusCommunityBorder,
      statusMissingBg: statusMissingBg ?? this.statusMissingBg,
      statusMissingFg: statusMissingFg ?? this.statusMissingFg,
      statusMissingBorder: statusMissingBorder ?? this.statusMissingBorder,
      error: error ?? this.error,
      onError: onError ?? this.onError,
      errorBg: errorBg ?? this.errorBg,
      errorFg: errorFg ?? this.errorFg,
      errorBorder: errorBorder ?? this.errorBorder,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      warningBg: warningBg ?? this.warningBg,
      warningFg: warningFg ?? this.warningFg,
      warningBorder: warningBorder ?? this.warningBorder,
      warningIcon: warningIcon ?? this.warningIcon,
      info: info ?? this.info,
      infoBg: infoBg ?? this.infoBg,
      infoFg: infoFg ?? this.infoFg,
      infoBorder: infoBorder ?? this.infoBorder,
      link: link ?? this.link,
      placeAccent: placeAccent ?? this.placeAccent,
      supportBannerBg: supportBannerBg ?? this.supportBannerBg,
      supportBannerBorder: supportBannerBorder ?? this.supportBannerBorder,
      supportBannerIcon: supportBannerIcon ?? this.supportBannerIcon,
      supportBannerText: supportBannerText ?? this.supportBannerText,
      mapRouteConfirmed: mapRouteConfirmed ?? this.mapRouteConfirmed,
      mapRouteUncertain: mapRouteUncertain ?? this.mapRouteUncertain,
      mapRouteRejected: mapRouteRejected ?? this.mapRouteRejected,
      mapRouteDefault: mapRouteDefault ?? this.mapRouteDefault,
      mapMarkerStart: mapMarkerStart ?? this.mapMarkerStart,
      mapMarkerDestination: mapMarkerDestination ?? this.mapMarkerDestination,
      mapAttributionBg: mapAttributionBg ?? this.mapAttributionBg,
      mapAttributionText: mapAttributionText ?? this.mapAttributionText,
    );
  }

  @override
  ThemeExtension<AppColorsExtension> lerp(
    covariant ThemeExtension<AppColorsExtension>? other,
    double t,
  ) {
    if (other is! AppColorsExtension) return this;
    return AppColorsExtension(
      primary: Color.lerp(primary, other.primary, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      primaryContainer:
          Color.lerp(primaryContainer, other.primaryContainer, t)!,
      onPrimaryContainer:
          Color.lerp(onPrimaryContainer, other.onPrimaryContainer, t)!,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      surfaceSubtle: Color.lerp(surfaceSubtle, other.surfaceSubtle, t)!,
      surfaceContainerHighest: Color.lerp(
          surfaceContainerHighest, other.surfaceContainerHighest, t)!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      textInverse: Color.lerp(textInverse, other.textInverse, t)!,
      textAttribution: Color.lerp(textAttribution, other.textAttribution, t)!,
      borderSubtle: Color.lerp(borderSubtle, other.borderSubtle, t)!,
      borderStrong: Color.lerp(borderStrong, other.borderStrong, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      statusConfirmedBg:
          Color.lerp(statusConfirmedBg, other.statusConfirmedBg, t)!,
      statusConfirmedFg:
          Color.lerp(statusConfirmedFg, other.statusConfirmedFg, t)!,
      statusConfirmedBorder:
          Color.lerp(statusConfirmedBorder, other.statusConfirmedBorder, t)!,
      statusUncertainBg:
          Color.lerp(statusUncertainBg, other.statusUncertainBg, t)!,
      statusUncertainFg:
          Color.lerp(statusUncertainFg, other.statusUncertainFg, t)!,
      statusUncertainBorder:
          Color.lerp(statusUncertainBorder, other.statusUncertainBorder, t)!,
      statusRejectedBg:
          Color.lerp(statusRejectedBg, other.statusRejectedBg, t)!,
      statusRejectedFg:
          Color.lerp(statusRejectedFg, other.statusRejectedFg, t)!,
      statusRejectedBorder:
          Color.lerp(statusRejectedBorder, other.statusRejectedBorder, t)!,
      statusConflictBg:
          Color.lerp(statusConflictBg, other.statusConflictBg, t)!,
      statusConflictFg:
          Color.lerp(statusConflictFg, other.statusConflictFg, t)!,
      statusConflictBorder:
          Color.lerp(statusConflictBorder, other.statusConflictBorder, t)!,
      statusDemoBg: Color.lerp(statusDemoBg, other.statusDemoBg, t)!,
      statusDemoFg: Color.lerp(statusDemoFg, other.statusDemoFg, t)!,
      statusDemoBorder:
          Color.lerp(statusDemoBorder, other.statusDemoBorder, t)!,
      statusCommunityBg:
          Color.lerp(statusCommunityBg, other.statusCommunityBg, t)!,
      statusCommunityFg:
          Color.lerp(statusCommunityFg, other.statusCommunityFg, t)!,
      statusCommunityBorder:
          Color.lerp(statusCommunityBorder, other.statusCommunityBorder, t)!,
      statusMissingBg: Color.lerp(statusMissingBg, other.statusMissingBg, t)!,
      statusMissingFg: Color.lerp(statusMissingFg, other.statusMissingFg, t)!,
      statusMissingBorder:
          Color.lerp(statusMissingBorder, other.statusMissingBorder, t)!,
      error: Color.lerp(error, other.error, t)!,
      onError: Color.lerp(onError, other.onError, t)!,
      errorBg: Color.lerp(errorBg, other.errorBg, t)!,
      errorFg: Color.lerp(errorFg, other.errorFg, t)!,
      errorBorder: Color.lerp(errorBorder, other.errorBorder, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      onWarning: Color.lerp(onWarning, other.onWarning, t)!,
      warningBg: Color.lerp(warningBg, other.warningBg, t)!,
      warningFg: Color.lerp(warningFg, other.warningFg, t)!,
      warningBorder: Color.lerp(warningBorder, other.warningBorder, t)!,
      warningIcon: Color.lerp(warningIcon, other.warningIcon, t)!,
      info: Color.lerp(info, other.info, t)!,
      infoBg: Color.lerp(infoBg, other.infoBg, t)!,
      infoFg: Color.lerp(infoFg, other.infoFg, t)!,
      infoBorder: Color.lerp(infoBorder, other.infoBorder, t)!,
      link: Color.lerp(link, other.link, t)!,
      placeAccent: Color.lerp(placeAccent, other.placeAccent, t)!,
      supportBannerBg: Color.lerp(supportBannerBg, other.supportBannerBg, t)!,
      supportBannerBorder:
          Color.lerp(supportBannerBorder, other.supportBannerBorder, t)!,
      supportBannerIcon:
          Color.lerp(supportBannerIcon, other.supportBannerIcon, t)!,
      supportBannerText:
          Color.lerp(supportBannerText, other.supportBannerText, t)!,
      mapRouteConfirmed:
          Color.lerp(mapRouteConfirmed, other.mapRouteConfirmed, t)!,
      mapRouteUncertain:
          Color.lerp(mapRouteUncertain, other.mapRouteUncertain, t)!,
      mapRouteRejected:
          Color.lerp(mapRouteRejected, other.mapRouteRejected, t)!,
      mapRouteDefault: Color.lerp(mapRouteDefault, other.mapRouteDefault, t)!,
      mapMarkerStart: Color.lerp(mapMarkerStart, other.mapMarkerStart, t)!,
      mapMarkerDestination:
          Color.lerp(mapMarkerDestination, other.mapMarkerDestination, t)!,
      mapAttributionBg:
          Color.lerp(mapAttributionBg, other.mapAttributionBg, t)!,
      mapAttributionText:
          Color.lerp(mapAttributionText, other.mapAttributionText, t)!,
    );
  }
}
