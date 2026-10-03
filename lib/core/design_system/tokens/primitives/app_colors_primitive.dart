import 'package:flutter/material.dart';

/// Podstawowa paleta kolorów (Primitive Color Tokens).
/// Zawiera surowe wartości kolorów bez powiązania semantycznego.
abstract final class AppColorsPrimitive {
  // Brand Blue
  static const Color blue50 = Color(0xFFE1F5FE);
  static const Color blue100 = Color(0xFFB3E5FC);
  static const Color blue500 = Color(0xFF2196F3);
  static const Color blue700 = Color(0xFF1976D2);
  static const Color blue800 = Color(0xFF1565C0);
  static const Color blue900 = Color(0xFF01579B);
  static const Color blueAccent = Color(0xFF448AFF);

  // Indigo
  static const Color indigo500 = Color(0xFF3F51B5);
  static const Color indigo700 = Color(0xFF303F9F);

  // Green / Sukces
  static const Color green50 = Color(0xFFE8F5E9);
  static const Color green300 = Color(0xFF81C784);
  static const Color green600 = Color(0xFF388E3C);
  static const Color green700 = Color(0xFF2E7D32);
  static const Color green900 = Color(0xFF1B5E20);

  // Amber / Orange / Ostrzeżenia
  static const Color amber50 = Color(0xFFFFF8E1);
  static const Color amber800 = Color(0xFFFFA000);
  static const Color amber900 = Color(0xFFF57F17);
  static const Color orange50 = Color(0xFFFFF3E0);
  static const Color orange500 = Color(0xFFFF9800);
  static const Color orange700 = Color(0xFFF57C00);
  static const Color orange800 = Color(0xFFEF6C00);
  static const Color orange900 = Color(0xFFE65100);

  // Red / Błędy / Odrzucenia
  static const Color red50 = Color(0xFFFFEBEE);
  static const Color red400 = Color(0xFFEF5350);
  static const Color red500 = Color(0xFFF44336);
  static const Color red600 = Color(0xFFE53935);
  static const Color red700 = Color(0xFFD32F2F);
  static const Color red800 = Color(0xFFC62828);
  static const Color red900 = Color(0xFFB71C1C);
  static const Color redAccent = Color(0xFFFF5252);

  // Neutral / Szarości
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);
  static const Color slate50 = Color(0xFFECEFF1);
  static const Color slate800 = Color(0xFF37474F);

  // Alpha / Nakładki
  static const Color black87 = Color(0xDD000000);
  static const Color whiteAlpha85 = Color(0xD9FFFFFF);
  static const Color transparent = Color(0x00000000);
}
