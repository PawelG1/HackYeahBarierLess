import 'package:flutter/material.dart';
import '../primitives/app_radius_primitive.dart';

/// Semantyczne tokeny zaokrągleń (Semantic Border Radius Tokens).
class AppRadiusSemantic {
  const AppRadiusSemantic();

  static const AppRadiusSemantic instance = AppRadiusSemantic();

  BorderRadius get none => BorderRadius.zero;
  BorderRadius get card => BorderRadius.circular(AppRadiusPrimitive.radius12);
  BorderRadius get cardDense => BorderRadius.circular(AppRadiusPrimitive.radius8);
  BorderRadius get banner => BorderRadius.circular(AppRadiusPrimitive.radius8);
  BorderRadius get bannerSmall => BorderRadius.circular(AppRadiusPrimitive.radius4);
  BorderRadius get badge => BorderRadius.circular(AppRadiusPrimitive.radius16);
  BorderRadius get button => BorderRadius.circular(AppRadiusPrimitive.radius10);
  BorderRadius get buttonDense => BorderRadius.circular(AppRadiusPrimitive.radius8);
  BorderRadius get tag => BorderRadius.circular(AppRadiusPrimitive.radius6);
  BorderRadius get full => BorderRadius.circular(AppRadiusPrimitive.radiusFull);

  // Wartości liczbowe promienia
  double get cardValue => AppRadiusPrimitive.radius12;
  double get cardDenseValue => AppRadiusPrimitive.radius8;
  double get bannerValue => AppRadiusPrimitive.radius8;
  double get badgeValue => AppRadiusPrimitive.radius16;
  double get buttonValue => AppRadiusPrimitive.radius10;
  double get tagValue => AppRadiusPrimitive.radius6;
}
