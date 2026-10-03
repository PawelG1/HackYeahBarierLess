import 'package:flutter/material.dart';
import '../primitives/app_dimensions_primitive.dart';

/// Semantyczne tokeny rozmiarów i wymiarów (Semantic Dimensions Tokens).
class AppDimensionsSemantic {
  const AppDimensionsSemantic();

  static const AppDimensionsSemantic instance = AppDimensionsSemantic();

  // Wymiary celów dotykowych (a11y: minimum 48x48)
  double get minTouchTarget => AppDimensionsPrimitive.minTouchTarget;
  Size get minTouchTargetSize => const Size(
        AppDimensionsPrimitive.minTouchTarget,
        AppDimensionsPrimitive.minTouchTarget,
      );
  Size get fullWidthButtonSize => const Size(
        double.infinity,
        AppDimensionsPrimitive.buttonHeight,
      );
  Size get fullWidthButtonDenseSize => const Size(
        double.infinity,
        AppDimensionsPrimitive.buttonDenseHeight,
      );
  Size get touchTargetButtonMinSize => const Size(
        AppDimensionsPrimitive.minTouchTarget,
        AppDimensionsPrimitive.minTouchTarget,
      );

  // Układ responsywny
  double get tabletBreakpoint => AppDimensionsPrimitive.tabletBreakpoint;
  double get tabletSidePanelWidth => AppDimensionsPrimitive.tabletSidePanelWidth;

  // Wysokość mapy
  double get mapPreviewHeight => AppDimensionsPrimitive.mapPreviewDefaultHeight;

  // Promień awatara kroku
  double get stepAvatarRadius => AppDimensionsPrimitive.stepAvatarRadius;

  // Rozmiary ikon
  double get iconSmall => AppDimensionsPrimitive.iconSize14;
  double get iconMedium => AppDimensionsPrimitive.iconSize16;
  double get iconBase => AppDimensionsPrimitive.iconSize18;
  double get iconLarge => AppDimensionsPrimitive.iconSize20;
  double get iconXLarge => AppDimensionsPrimitive.iconSize28;
  double get iconXXLarge => AppDimensionsPrimitive.iconSize32;
  double get iconHuge => AppDimensionsPrimitive.iconSize48;

  // Grubości krawędzi
  double get borderThin => AppDimensionsPrimitive.borderWidthThin;
  double get borderMedium => AppDimensionsPrimitive.borderWidthMedium;
  double get borderThick => AppDimensionsPrimitive.borderWidthThick;
  double get borderSelected => AppDimensionsPrimitive.borderWidthSelected;

  // Rysowanie geometrii
  double get mapPolylineStrokeWidth => AppDimensionsPrimitive.polylineStrokeWidth;
}
