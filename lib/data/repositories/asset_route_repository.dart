import '../../domain/repositories/route_repository.dart';
import '../sources/asset_json_source.dart';

/// Implementacja RouteRepository ładująca graf z zasobów aplikacji.
class AssetRouteRepository implements RouteRepository {
  final AssetJsonSource jsonSource;

  const AssetRouteRepository({required this.jsonSource});

  @override
  Future<AreaGraph> loadArea() async {
    return await jsonSource.loadArea();
  }
}
