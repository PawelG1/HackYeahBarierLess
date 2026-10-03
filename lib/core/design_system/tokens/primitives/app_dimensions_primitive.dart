/// Prymitywne wymiary i stałe geometryczne (Primitive Dimensions Tokens).
abstract final class AppDimensionsPrimitive {
  // Rozmiary celów dotykowych (a11y)
  static const double minTouchTarget = 48.0;
  static const double buttonHeight = 52.0;
  static const double buttonDenseHeight = 50.0;

  // Układ responsywny (Breakpointy)
  static const double tabletBreakpoint = 600.0;
  static const double tabletSidePanelWidth = 360.0;

  // Komponenty dedykowane
  static const double mapPreviewDefaultHeight = 240.0;
  static const double stepAvatarRadius = 14.0;

  // Rozmiary ikon
  static const double iconSize14 = 14.0;
  static const double iconSize16 = 16.0;
  static const double iconSize18 = 18.0;
  static const double iconSize20 = 20.0;
  static const double iconSize28 = 28.0;
  static const double iconSize32 = 32.0;
  static const double iconSize48 = 48.0;

  // Grubości obramowań
  static const double borderWidthThin = 1.0;
  static const double borderWidthMedium = 1.5;
  static const double borderWidthThick = 2.0;
  static const double borderWidthSelected = 2.5;

  // Grubość linii trasy na mapie
  static const double polylineStrokeWidth = 5.0;
}
