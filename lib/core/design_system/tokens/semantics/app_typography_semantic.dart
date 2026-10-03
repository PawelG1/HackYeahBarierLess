import 'package:flutter/material.dart';
import '../primitives/app_typography_primitive.dart';

/// Semantyczne tokeny stylów tekstu (Semantic Typography Tokens).
class AppTypographySemantic {
  const AppTypographySemantic();

  static const AppTypographySemantic instance = AppTypographySemantic();

  TextStyle get titleLarge => const TextStyle(
        fontSize: AppTypographyPrimitive.size20,
        fontWeight: AppTypographyPrimitive.bold,
      );

  TextStyle get titleMedium => const TextStyle(
        fontSize: AppTypographyPrimitive.size18,
        fontWeight: AppTypographyPrimitive.bold,
      );

  TextStyle get titleSmall => const TextStyle(
        fontSize: AppTypographyPrimitive.size16,
        fontWeight: AppTypographyPrimitive.bold,
      );

  TextStyle get sectionHeader => const TextStyle(
        fontSize: AppTypographyPrimitive.size17,
        fontWeight: AppTypographyPrimitive.bold,
      );

  TextStyle get subhead => const TextStyle(
        fontSize: AppTypographyPrimitive.size15,
        fontWeight: AppTypographyPrimitive.bold,
      );

  TextStyle get bodyLarge => const TextStyle(
        fontSize: AppTypographyPrimitive.size16,
        fontWeight: AppTypographyPrimitive.regular,
      );

  TextStyle get bodyMedium => const TextStyle(
        fontSize: AppTypographyPrimitive.size14,
        fontWeight: AppTypographyPrimitive.regular,
      );

  TextStyle get bodySmall => const TextStyle(
        fontSize: AppTypographyPrimitive.size12,
        fontWeight: AppTypographyPrimitive.regular,
      );

  TextStyle get bodySmallSemiBold => const TextStyle(
        fontSize: AppTypographyPrimitive.size12,
        fontWeight: AppTypographyPrimitive.semiBold,
      );

  TextStyle get bodySmallBold => const TextStyle(
        fontSize: AppTypographyPrimitive.size12,
        fontWeight: AppTypographyPrimitive.bold,
      );

  TextStyle get bodyMediumSemiBold => const TextStyle(
        fontSize: AppTypographyPrimitive.size14,
        fontWeight: AppTypographyPrimitive.semiBold,
      );

  TextStyle get bodyMediumMedium => const TextStyle(
        fontSize: AppTypographyPrimitive.size14,
        fontWeight: AppTypographyPrimitive.medium,
      );

  TextStyle get labelLarge => const TextStyle(
        fontSize: AppTypographyPrimitive.size16,
        fontWeight: AppTypographyPrimitive.bold,
      );

  TextStyle get labelMedium => const TextStyle(
        fontSize: AppTypographyPrimitive.size14,
        fontWeight: AppTypographyPrimitive.bold,
      );

  TextStyle get labelSmall => const TextStyle(
        fontSize: AppTypographyPrimitive.size12,
        fontWeight: AppTypographyPrimitive.bold,
      );

  TextStyle get badge => const TextStyle(
        fontSize: AppTypographyPrimitive.size13,
        fontWeight: AppTypographyPrimitive.bold,
      );

  TextStyle get banner => const TextStyle(
        fontSize: AppTypographyPrimitive.size13,
        fontWeight: AppTypographyPrimitive.semiBold,
      );

  TextStyle get bannerBody => const TextStyle(
        fontSize: AppTypographyPrimitive.size13,
        fontWeight: AppTypographyPrimitive.regular,
      );

  TextStyle get caption => const TextStyle(
        fontSize: AppTypographyPrimitive.size11,
        fontWeight: AppTypographyPrimitive.regular,
      );

  TextStyle get attribution => const TextStyle(
        fontSize: AppTypographyPrimitive.size9,
        fontWeight: AppTypographyPrimitive.regular,
      );

  TextStyle get button => const TextStyle(
        fontSize: AppTypographyPrimitive.size16,
        fontWeight: AppTypographyPrimitive.bold,
      );

  TextStyle get buttonSmall => const TextStyle(
        fontSize: AppTypographyPrimitive.size12,
        fontWeight: AppTypographyPrimitive.regular,
      );

  TextStyle get stepNumber => const TextStyle(
        fontSize: AppTypographyPrimitive.size13,
        fontWeight: AppTypographyPrimitive.bold,
      );
}
