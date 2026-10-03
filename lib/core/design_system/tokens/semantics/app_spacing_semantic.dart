import 'package:flutter/material.dart';
import '../primitives/app_spacing_primitive.dart';

/// Semantyczne tokeny odstępów i marginesów (Semantic Spacing Tokens).
class AppSpacingSemantic {
  const AppSpacingSemantic();

  static const AppSpacingSemantic instance = AppSpacingSemantic();

  // Skala wartości liczbowych
  double get none => AppSpacingPrimitive.space0;
  double get xxs => AppSpacingPrimitive.space2;
  double get xs => AppSpacingPrimitive.space4;
  double get s => AppSpacingPrimitive.space6;
  double get sm => AppSpacingPrimitive.space8;
  double get md => AppSpacingPrimitive.space10;
  double get space12 => AppSpacingPrimitive.space12;
  double get space14 => AppSpacingPrimitive.space14;
  double get base => AppSpacingPrimitive.space16;
  double get lg => AppSpacingPrimitive.space20;
  double get xl => AppSpacingPrimitive.space24;
  double get xxl => AppSpacingPrimitive.space32;
  double get huge => AppSpacingPrimitive.space48;

  // Semantyczne wcięcia (EdgeInsets)
  EdgeInsets get screenPadding => const EdgeInsets.all(AppSpacingPrimitive.space16);
  EdgeInsets get cardPadding => const EdgeInsets.all(AppSpacingPrimitive.space16);
  EdgeInsets get cardPaddingDense => const EdgeInsets.all(AppSpacingPrimitive.space12);
  EdgeInsets get bannerPadding => const EdgeInsets.all(AppSpacingPrimitive.space12);
  EdgeInsets get bannerSmallPadding => const EdgeInsets.symmetric(
        horizontal: AppSpacingPrimitive.space6,
        vertical: AppSpacingPrimitive.space2,
      );
  EdgeInsets get badgePadding => const EdgeInsets.symmetric(
        horizontal: AppSpacingPrimitive.space10,
        vertical: AppSpacingPrimitive.space6,
      );
  EdgeInsets get sourceRowPadding => const EdgeInsets.all(AppSpacingPrimitive.space8);
  EdgeInsets get routeStepReasonPadding => const EdgeInsets.all(AppSpacingPrimitive.space6);
  EdgeInsets get buttonPadding => const EdgeInsets.symmetric(
        vertical: AppSpacingPrimitive.space16,
      );
  EdgeInsets get buttonDensePadding => const EdgeInsets.symmetric(
        vertical: AppSpacingPrimitive.space14,
      );
  EdgeInsets get buttonSmallPadding => const EdgeInsets.symmetric(
        horizontal: AppSpacingPrimitive.space10,
        vertical: AppSpacingPrimitive.space4,
      );
  EdgeInsets get inputContentPadding => const EdgeInsets.symmetric(
        horizontal: AppSpacingPrimitive.space12,
        vertical: AppSpacingPrimitive.space8,
      );
  EdgeInsets get errorBoxPadding => const EdgeInsets.all(AppSpacingPrimitive.space24);

  // Semantyczne marginesy (EdgeInsets)
  EdgeInsets get cardMargin => const EdgeInsets.symmetric(
        vertical: AppSpacingPrimitive.space8,
        horizontal: AppSpacingPrimitive.space4,
      );
  EdgeInsets get cardMarginDense => const EdgeInsets.symmetric(
        vertical: AppSpacingPrimitive.space6,
        horizontal: AppSpacingPrimitive.space0,
      );
  EdgeInsets get cardMarginVertical => const EdgeInsets.symmetric(
        vertical: AppSpacingPrimitive.space6,
      );
  EdgeInsets get bannerMargin => const EdgeInsets.only(
        bottom: AppSpacingPrimitive.space16,
      );
  EdgeInsets get sourceRowMargin => const EdgeInsets.only(
        top: AppSpacingPrimitive.space6,
      );
  EdgeInsets get mapMargin => const EdgeInsets.symmetric(
        vertical: AppSpacingPrimitive.space8,
      );
}
