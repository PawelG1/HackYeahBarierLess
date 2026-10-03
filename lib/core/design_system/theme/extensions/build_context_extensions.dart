import 'package:flutter/material.dart';
import '../../tokens/semantics/app_dimensions_semantic.dart';
import '../../tokens/semantics/app_elevation_semantic.dart';
import '../../tokens/semantics/app_radius_semantic.dart';
import '../../tokens/semantics/app_spacing_semantic.dart';
import '../../tokens/semantics/app_typography_semantic.dart';
import 'app_colors_extension.dart';

/// Wygodne rozszerzenie dla [BuildContext] pozwalające na bezpośredni dostęp
/// do semantycznych tokenów systemu designu bez magii i bez powtórzeń.
///
/// Przykład: `context.colors.primary`, `context.spacing.screenPadding`
extension DesignSystemContext on BuildContext {
  /// Semantyczne kolory powiązane z aktualnym motywem aplikacji.
  AppColorsExtension get colors =>
      Theme.of(this).extension<AppColorsExtension>() ?? AppColorsExtension.light;

  /// Semantyczne odstępy i marginesy.
  AppSpacingSemantic get spacing => AppSpacingSemantic.instance;

  /// Semantyczne zaokrąglenia krawędzi (BorderRadius).
  AppRadiusSemantic get radii => AppRadiusSemantic.instance;

  /// Semantyczne style typograficzne.
  AppTypographySemantic get typography => AppTypographySemantic.instance;

  /// Semantyczne wymiary, rozmiary ikon i progi responsywności.
  AppDimensionsSemantic get dimensions => AppDimensionsSemantic.instance;

  /// Semantyczne poziomy uniesienia i cieni (elevation).
  AppElevationSemantic get elevations => AppElevationSemantic.instance;
}
