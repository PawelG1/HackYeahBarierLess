import 'package:flutter/material.dart';
import '../tokens/semantics/app_elevation_semantic.dart';
import '../tokens/semantics/app_radius_semantic.dart';
import '../tokens/semantics/app_spacing_semantic.dart';
import '../tokens/semantics/app_typography_semantic.dart';
import 'extensions/app_colors_extension.dart';
import 'dark_colors.dart';
import 'high_contrast_dark_colors.dart';

abstract final class AppTheme {
  static ThemeData get lightTheme {
    const colors = AppColorsExtension.light;
    const spacing = AppSpacingSemantic.instance;
    const radii = AppRadiusSemantic.instance;
    const typography = AppTypographySemantic.instance;
    const elevations = AppElevationSemantic.instance;

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: colors.primary,
        onPrimary: colors.onPrimary,
        primaryContainer: colors.primaryContainer,
        onPrimaryContainer: colors.onPrimaryContainer,
        secondary: colors.primary,
        onSecondary: colors.onPrimary,
        error: colors.error,
        onError: colors.onError,
        surface: colors.surface,
        onSurface: colors.onSurface,
        surfaceContainerHighest: colors.surfaceContainerHighest,
      ),
      scaffoldBackgroundColor: colors.background,
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface,
        foregroundColor: colors.onSurface,
        elevation: elevations.elevationFlat,
        centerTitle: false,
        titleTextStyle: typography.titleLarge.copyWith(color: colors.textPrimary),
      ),
      cardTheme: CardThemeData(
        elevation: elevations.elevationCard,
        margin: spacing.cardMargin,
        shape: RoundedRectangleBorder(
          borderRadius: radii.card,
        ),
        color: colors.cardBackground,
      ),
      textTheme: TextTheme(
        titleLarge: typography.titleLarge.copyWith(color: colors.textPrimary),
        titleMedium: typography.titleMedium.copyWith(color: colors.textPrimary),
        titleSmall: typography.titleSmall.copyWith(color: colors.textPrimary),
        bodyLarge: typography.bodyLarge.copyWith(color: colors.textPrimary),
        bodyMedium: typography.bodyMedium.copyWith(color: colors.textPrimary),
        bodySmall: typography.bodySmall.copyWith(color: colors.textSecondary),
      ),
      extensions: const [
        AppColorsExtension.light,
      ],
    );
  }

  static ThemeData get darkTheme {
    const colors = DarkColors.extension;
    const spacing = AppSpacingSemantic.instance;
    const radii = AppRadiusSemantic.instance;
    const typography = AppTypographySemantic.instance;
    const elevations = AppElevationSemantic.instance;

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: colors.primary,
        onPrimary: colors.onPrimary,
        primaryContainer: colors.primaryContainer,
        onPrimaryContainer: colors.onPrimaryContainer,
        secondary: colors.primary,
        onSecondary: colors.onPrimary,
        error: colors.error,
        onError: colors.onError,
        surface: colors.surface,
        onSurface: colors.onSurface,
        surfaceContainerHighest: colors.surfaceContainerHighest,
      ),
      scaffoldBackgroundColor: colors.background,
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface,
        foregroundColor: colors.onSurface,
        elevation: elevations.elevationFlat,
        centerTitle: false,
        titleTextStyle: typography.titleLarge.copyWith(color: colors.textPrimary),
      ),
      cardTheme: CardThemeData(
        elevation: elevations.elevationCard,
        margin: spacing.cardMargin,
        shape: RoundedRectangleBorder(
          borderRadius: radii.card,
          side: BorderSide(color: colors.borderSubtle, width: 1),
        ),
      ),
      textTheme: TextTheme(
        titleLarge: typography.titleLarge.copyWith(color: colors.textPrimary),
        titleMedium: typography.titleMedium.copyWith(color: colors.textPrimary),
        titleSmall: typography.titleSmall.copyWith(color: colors.textPrimary),
        bodyLarge: typography.bodyLarge.copyWith(color: colors.textPrimary),
        bodyMedium: typography.bodyMedium.copyWith(color: colors.textPrimary),
        bodySmall: typography.bodySmall.copyWith(color: colors.textSecondary),
      ),
      extensions: const [
        colors,
      ],
    );
  }

  static ThemeData get highContrastDarkTheme {
    const colors = HighContrastDarkColors.extension;
    const spacing = AppSpacingSemantic.instance;
    const radii = AppRadiusSemantic.instance;
    const typography = AppTypographySemantic.instance;
    const elevations = AppElevationSemantic.instance;

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: colors.primary,
        onPrimary: colors.onPrimary,
        primaryContainer: colors.primaryContainer,
        onPrimaryContainer: colors.onPrimaryContainer,
        secondary: colors.primary,
        onSecondary: colors.onPrimary,
        error: colors.error,
        onError: colors.onError,
        surface: colors.surface,
        onSurface: colors.onSurface,
        surfaceContainerHighest: colors.surfaceContainerHighest,
      ),
      scaffoldBackgroundColor: colors.background,
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface,
        foregroundColor: colors.onSurface,
        elevation: elevations.elevationFlat,
        centerTitle: false,
        titleTextStyle: typography.titleLarge.copyWith(color: colors.textPrimary),
      ),
      cardTheme: CardThemeData(
        elevation: elevations.elevationCard,
        margin: spacing.cardMargin,
        color: colors.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: radii.card,
          side: BorderSide(color: colors.borderStrong, width: 2),
        ),
      ),
      textTheme: TextTheme(
        titleLarge: typography.titleLarge.copyWith(color: colors.textPrimary),
        titleMedium: typography.titleMedium.copyWith(color: colors.textPrimary),
        titleSmall: typography.titleSmall.copyWith(color: colors.textPrimary),
        bodyLarge: typography.bodyLarge.copyWith(color: colors.textPrimary),
        bodyMedium: typography.bodyMedium.copyWith(color: colors.textPrimary),
        bodySmall: typography.bodySmall.copyWith(color: colors.textSecondary),
      ),
      extensions: const [
        colors,
      ],
    );
  }
}
