/// Centralne publiczne API Systemu Designu aplikacji „Trasa bez domysłów”.
///
/// Moduł udostępnia:
/// - Tokeny prymitywne: barwy bazowe, odstępy, zaokrąglenia, typografię, uniesienia, wymiary
/// - Tokeny semantyczne: role kolorystyczne (statusy, powierzchnie, ostrzeżenia), ergonomiczne skale
/// - Motyw aplikacji (ThemeData + Material 3) oraz rozszerzenia ThemeExtension
/// - Ergonomiczne rozszerzenie `BuildContext` (`context.colors`, `context.spacing`, `context.radii` itp.)
/// - Współdzielone widgety: banery, karty, etykiety (badge), widoki stanu
library design_system;

// Primitives
export 'tokens/primitives/app_colors_primitive.dart';
export 'tokens/primitives/app_dimensions_primitive.dart';
export 'tokens/primitives/app_elevation_primitive.dart';
export 'tokens/primitives/app_radius_primitive.dart';
export 'tokens/primitives/app_spacing_primitive.dart';
export 'tokens/primitives/app_typography_primitive.dart';

// Semantics
export 'tokens/semantics/app_colors_semantic.dart';
export 'tokens/semantics/app_dimensions_semantic.dart';
export 'tokens/semantics/app_elevation_semantic.dart';
export 'tokens/semantics/app_radius_semantic.dart';
export 'tokens/semantics/app_spacing_semantic.dart';
export 'tokens/semantics/app_typography_semantic.dart';

// Theme & Extensions
export 'theme/app_theme.dart';
export 'theme/extensions/app_colors_extension.dart';
export 'theme/extensions/build_context_extensions.dart';

// Shared Widgets
export 'widgets/app_badge.dart';
export 'widgets/app_banner.dart';
export 'widgets/app_card.dart';
export 'widgets/app_error_view.dart';
export 'widgets/app_loading_view.dart';
