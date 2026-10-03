import 'package:flutter/material.dart';
import 'extensions/app_colors_extension.dart';

abstract class HighContrastDarkColors {
  static const extension = AppColorsExtension(
    primary: Color(0xFFFFFF00), // Bright Yellow
    onPrimary: Color(0xFF000000), // Pure Black
    primaryContainer: Color(0xFFFFFF00),
    onPrimaryContainer: Color(0xFF000000),
    background: Color(0xFF000000), // Pure Black
    surface: Color(0xFF000000),
    onSurface: Color(0xFFFFFFFF), // Pure White
    surfaceSubtle: Color(0xFF111111),
    surfaceContainerHighest: Color(0xFF222222),
    cardBackground: Color(0xFF000000),
    textPrimary: Color(0xFFFFFFFF),
    textSecondary: Color(0xFFFFFFFF), // No muted text in high contrast
    textMuted: Color(0xFFDDDDDD),
    textInverse: Color(0xFF000000),
    textAttribution: Color(0xFFFFFFFF),
    borderSubtle: Color(0xFFFFFFFF),
    borderStrong: Color(0xFFFFFFFF),
    divider: Color(0xFFFFFFFF),
    statusConfirmedBg: Color(0xFF000000),
    statusConfirmedFg: Color(0xFF00FF00), // Bright Green
    statusConfirmedBorder: Color(0xFF00FF00),
    statusUncertainBg: Color(0xFF000000),
    statusUncertainFg: Color(0xFFFFFF00), // Bright Yellow
    statusUncertainBorder: Color(0xFFFFFF00),
    statusRejectedBg: Color(0xFF000000),
    statusRejectedFg: Color(0xFFFF0000), // Bright Red
    statusRejectedBorder: Color(0xFFFF0000),
    statusConflictBg: Color(0xFF000000),
    statusConflictFg: Color(0xFFFFFF00),
    statusConflictBorder: Color(0xFFFFFF00),
    statusDemoBg: Color(0xFF000000),
    statusDemoFg: Color(0xFFFFFFFF),
    statusDemoBorder: Color(0xFFFFFFFF),
    statusCommunityBg: Color(0xFF000000),
    statusCommunityFg: Color(0xFF00FFFF), // Cyan
    statusCommunityBorder: Color(0xFF00FFFF),
    statusMissingBg: Color(0xFF000000),
    statusMissingFg: Color(0xFFFFFFFF),
    statusMissingBorder: Color(0xFFFFFFFF),
    error: Color(0xFFFF0000),
    onError: Color(0xFFFFFFFF),
    errorBg: Color(0xFF000000),
    errorFg: Color(0xFFFF0000),
    errorBorder: Color(0xFFFF0000),
    warning: Color(0xFFFFFF00),
    onWarning: Color(0xFF000000),
    warningBg: Color(0xFF000000),
    warningFg: Color(0xFFFFFF00),
    warningBorder: Color(0xFFFFFF00),
    warningIcon: Color(0xFFFFFF00),
    info: Color(0xFF00FFFF),
    infoBg: Color(0xFF000000),
    infoFg: Color(0xFF00FFFF),
    infoBorder: Color(0xFF00FFFF),
    link: Color(0xFF00FFFF),
    placeAccent: Color(0xFFFFFF00),
    supportBannerBg: Color(0xFF000000),
    supportBannerBorder: Color(0xFFFFFFFF),
    supportBannerIcon: Color(0xFFFFFFFF),
    supportBannerText: Color(0xFFFFFFFF),
    mapRouteConfirmed: Color(0xFF00FF00),
    mapRouteUncertain: Color(0xFFFFFF00),
    mapRouteRejected: Color(0xFFFF0000),
    mapRouteDefault: Color(0xFFFFFFFF),
    mapMarkerStart: Color(0xFF00FFFF),
    mapMarkerDestination: Color(0xFFFF0000),
    mapAttributionBg: Color(0xFF000000),
    mapAttributionText: Color(0xFFFFFFFF),
  );
}
