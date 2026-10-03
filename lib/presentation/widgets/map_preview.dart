import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../core/design_system/design_system.dart';
import '../../core/di/providers.dart';
import '../../domain/entities/observation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/route_node.dart';
import '../../domain/entities/route_result.dart';

/// Podgląd wizualny trasy na mapie OpenStreetMap z zabezpieczeniem offline.
class MapPreview extends ConsumerWidget {
  final RouteResult? route;
  final List<RouteNode> allNodes;
  final double? height;
  final int? highlightedStepIndex;
  final void Function(LatLng)? onMapTap;

  const MapPreview({
    super.key,
    required this.route,
    required this.allNodes,
    this.height,
    this.highlightedStepIndex,
    this.onMapTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final effectiveHeight = height ?? context.dimensions.mapPreviewHeight;
    final pointObsAsync = ref.watch(pointObservationsProvider);
    final List<Observation> pointObs = pointObsAsync.value ?? [];
    final nodeMap = {for (var n in allNodes) n.id: LatLng(n.lat, n.lon)};

    final lineColor = route == null
        ? context.colors.mapRouteDefault
        : (route!.status == RouteStatus.rejected
            ? context.colors.mapRouteRejected
            : (route!.status == RouteStatus.uncertain
                ? context.colors.mapRouteUncertain
                : context.colors.mapRouteConfirmed));
    final polylines = <Polyline>[];
    LatLng? currentCenter;
    
    if (route != null) {
      if (highlightedStepIndex != null) {
        // Rysuj trase z wyroznieniem
        for (int i = 0; i < route!.steps.length; i++) {
          final step = route!.steps[i];
          final pFrom = nodeMap[step.edge.from];
          final pTo = nodeMap[step.edge.to];
          if (pFrom != null && pTo != null) {
            final isHighlighted = i == highlightedStepIndex;
            if (isHighlighted) currentCenter = pFrom;
            
            polylines.add(
              Polyline(
                points: [pFrom, pTo],
                strokeWidth: isHighlighted ? context.dimensions.mapPolylineStrokeWidth + 2.0 : context.dimensions.mapPolylineStrokeWidth - 1.0,
                color: isHighlighted ? context.colors.primary : lineColor.withAlpha(127),
              ),
            );
          }
        }
      } else {
        final polylinePoints = <LatLng>[];
        for (final step in route!.steps) {
          final pFrom = nodeMap[step.edge.from];
          final pTo = nodeMap[step.edge.to];
          if (pFrom != null && !polylinePoints.contains(pFrom)) {
            polylinePoints.add(pFrom);
          }
          if (pTo != null && !polylinePoints.contains(pTo)) {
            polylinePoints.add(pTo);
          }
        }
        if (polylinePoints.isNotEmpty) {
          polylines.add(
            Polyline(
              points: polylinePoints,
              strokeWidth: context.dimensions.mapPolylineStrokeWidth,
              color: lineColor,
            ),
          );
        }
      }
    }

    final initialCenter = currentCenter ?? (polylines.isNotEmpty && polylines.first.points.isNotEmpty
        ? polylines.first.points.first
        : const LatLng(50.0645, 19.9440)); // Kraków Planty



    return Semantics(
      label:
          'Podgląd mapy trasy. Dostępny także pełny widok tekstowy krok po kroku poniżej.',
      child: Container(
        height: effectiveHeight,
        margin: context.spacing.mapMargin,
        decoration: BoxDecoration(
          borderRadius: context.radii.card,
          border: Border.all(
            color: context.colors.borderSubtle,
            width: context.dimensions.borderThin,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                initialCenter: initialCenter,
                initialZoom: 16.0,
                onTap: (tapPosition, point) => onMapTap?.call(point),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'org.hackyeah.krakow_bez_barier',
                  errorTileCallback: (tile, error, stackTrace) {
                    // Cichy fallback offline — mapa pozostaje czytelna schematycznie
                  },
                ),
                if (polylines.isNotEmpty)
                  PolylineLayer(
                    polylines: polylines,
                  ),
                if (polylines.isNotEmpty && polylines.first.points.isNotEmpty)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: polylines.first.points.first,
                        child: Icon(
                          Icons.my_location,
                          color: context.colors.mapMarkerStart,
                          size: context.dimensions.iconXLarge,
                        ),
                      ),
                      Marker(
                        point: polylines.last.points.last,
                        child: Icon(
                          Icons.location_on,
                          color: context.colors.mapMarkerDestination,
                          size: context.dimensions.iconXXLarge,
                        ),
                      ),
                      // Dodatkowy marker dla aktualnej pozycji (jeśli nawigujemy)
                      if (highlightedStepIndex != null && currentCenter != null)
                        Marker(
                          point: currentCenter,
                          child: Icon(
                            Icons.directions_walk,
                            color: context.colors.primary,
                            size: context.dimensions.iconXXLarge,
                          ),
                        ),
                      // Zgłoszone przeszkody na mapie
                      ...pointObs.map((obs) {
                        final parts = obs.targetId.split(',');
                        if (parts.length == 2) {
                          final lat = double.tryParse(parts[0]);
                          final lon = double.tryParse(parts[1]);
                          if (lat != null && lon != null) {
                            return Marker(
                              point: LatLng(lat, lon),
                              child: Tooltip(
                                message: '${obs.feature}\n${obs.value}\nCzas: ${obs.observedAt.toLocal().toString().substring(0, 16)}',
                                child: Icon(
                                  Icons.warning,
                                  color: context.colors.error,
                                  size: context.dimensions.iconLarge,
                                ),
                              ),
                            );
                          }
                        }
                        return null;
                      }).whereType<Marker>(),

                    ],
                  ),
              ],
            ),
            Positioned(
              bottom: context.spacing.s,
              right: context.spacing.s,
              child: Container(
                padding: context.spacing.bannerSmallPadding,
                decoration: BoxDecoration(
                  color: context.colors.mapAttributionBg,
                  borderRadius: context.radii.bannerSmall,
                ),
                child: Text(
                  '© OpenStreetMap contributors',
                  style: context.typography.attribution.copyWith(
                    color: context.colors.mapAttributionText,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
