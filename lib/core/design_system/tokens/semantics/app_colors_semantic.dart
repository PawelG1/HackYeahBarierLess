import 'package:flutter/material.dart';
import '../../theme/extensions/app_colors_extension.dart';

/// Statyczny punkt dostępu do domyślnych semantycznych tokenów kolorów.
abstract final class AppColorsSemantic {
  static const AppColorsExtension defaultColors = AppColorsExtension.light;

  static Color get primary => defaultColors.primary;
  static Color get onPrimary => defaultColors.onPrimary;
  static Color get background => defaultColors.background;
  static Color get surface => defaultColors.surface;
  static Color get onSurface => defaultColors.onSurface;
  static Color get error => defaultColors.error;
  static Color get warning => defaultColors.warning;
  static Color get borderSubtle => defaultColors.borderSubtle;
}
