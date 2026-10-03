import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../dto/area_dto.dart';
import '../../domain/repositories/route_repository.dart';

/// Źródło danych odczytujące plik JSON z zasobów aplikacji (assets).
class AssetJsonSource {
  final String assetPath;
  final Future<String> Function(String)? customLoader;

  const AssetJsonSource({
    this.assetPath = 'assets/data/demo_area.json',
    this.customLoader,
  });

  Future<AreaGraph> loadArea() async {
    final String content;
    if (customLoader != null) {
      content = await customLoader!(assetPath);
    } else {
      content = await rootBundle.loadString(assetPath);
    }

    final Map<String, dynamic> json = jsonDecode(content);
    return AreaDto.fromJson(json);
  }
}
