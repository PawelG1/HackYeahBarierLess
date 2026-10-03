import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/observation.dart';
import '../../data/repositories/asset_route_repository.dart';
import '../../data/repositories/local_observation_repository.dart';
import '../../data/sources/asset_json_source.dart';
import '../../data/sources/preferences_source.dart';
import '../../domain/repositories/observation_repository.dart';
import '../../domain/repositories/route_repository.dart';
import '../../domain/usecases/add_observation.dart';
import '../../domain/usecases/compare_routes.dart';
import '../../domain/usecases/load_area.dart';

// 1. Data Sources
final assetJsonSourceProvider = Provider<AssetJsonSource>((ref) {
  return const AssetJsonSource();
});

final preferencesSourceProvider = Provider<PreferencesSource>((ref) {
  return PreferencesSource();
});

// 2. Repositories
final routeRepositoryProvider = Provider<RouteRepository>((ref) {
  final jsonSource = ref.watch(assetJsonSourceProvider);
  return AssetRouteRepository(jsonSource: jsonSource);
});

final observationRepositoryProvider = Provider<ObservationRepository>((ref) {
  final prefSource = ref.watch(preferencesSourceProvider);
  return LocalObservationRepository(preferencesSource: prefSource);
});

// 3. Use Cases
final loadAreaUseCaseProvider = Provider<LoadArea>((ref) {
  final repo = ref.watch(routeRepositoryProvider);
  return LoadArea(routeRepository: repo);
});

final compareRoutesUseCaseProvider = Provider<CompareRoutes>((ref) {
  final routeRepo = ref.watch(routeRepositoryProvider);
  final obsRepo = ref.watch(observationRepositoryProvider);
  return CompareRoutes(
    routeRepository: routeRepo,
    observationRepository: obsRepo,
  );
});

final addObservationUseCaseProvider = Provider<AddObservation>((ref) {
  final obsRepo = ref.watch(observationRepositoryProvider);
  return AddObservation(observationRepository: obsRepo);
});

// 4. UI State
final highContrastThemeProvider = StateProvider<bool>((ref) => false);

final textScaleProvider = StateProvider<double>((ref) => 1.0);

final pointObservationsProvider = FutureProvider<List<Observation>>((ref) async {
  final repo = ref.read(observationRepositoryProvider);
  final obs = await repo.getLocalObservations();
  return obs.where((o) => o.targetType == 'point').toList();
});
