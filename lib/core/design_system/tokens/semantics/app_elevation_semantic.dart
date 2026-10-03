import '../primitives/app_elevation_primitive.dart';

/// Semantyczne tokeny uniesienia (Semantic Elevation Tokens).
class AppElevationSemantic {
  const AppElevationSemantic();

  static const AppElevationSemantic instance = AppElevationSemantic();

  static const double flat = AppElevationPrimitive.elevation0;
  static const double subtle = AppElevationPrimitive.elevationHalf;
  static const double card = AppElevationPrimitive.elevation1;
  static const double cardSelected = AppElevationPrimitive.elevation4;
  static const double dialog = AppElevationPrimitive.elevation8;

  double get elevationFlat => flat;
  double get elevationSubtle => subtle;
  double get elevationCard => card;
  double get elevationCardSelected => cardSelected;
  double get elevationDialog => dialog;
}
