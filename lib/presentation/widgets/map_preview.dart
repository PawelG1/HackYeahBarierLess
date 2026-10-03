import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../core/design_system/design_system.dart';
import '../../domain/entities/route_node.dart';
import '../../domain/entities/route_result.dart';

/// Podgląd wizualny trasy na mapie OpenStreetMap z zabezpieczeniem offline.
class MapPreview extends StatelessWidget {
  final RouteResult? route;
  final List<RouteNode> allNodes;
  final double? height;

  const MapPreview({
    super.key,
    required this.route,
    required this.allNodes,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveHeight = height ?? context.dimensions.mapPreviewHeight;
    final nodeMap = {for (var n in allNodes) n.id: LatLng(n.lat, n.lon)};

    final polylinePoints = <LatLng>[];
    if (route != null) {
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
    }

    final initialCenter = polylinePoints.isNotEmpty
        ? polylinePoints.first
        : const LatLng(50.0645, 19.9440); // Kraków Planty

    final lineColor = route == null
        ? context.colors.mapRouteDefault
        : (route!.status == RouteStatus.rejected
            ? context.colors.mapRouteRejected
            : (route!.status == RouteStatus.uncertain
                ? context.colors.mapRouteUncertain
                : context.colors.mapRouteConfirmed));

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
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'org.hackyeah.krakow_bez_barier',
                  errorTileCallback: (tile, error, stackTrace) {
                    // Cichy fallback offline — mapa pozostaje czytelna schematycznie
                  },
                ),
                if (polylinePoints.isNotEmpty)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: polylinePoints,
                        strokeWidth: context.dimensions.mapPolylineStrokeWidth,
                        color: lineColor,
                      ),
                    ],
                  ),
                if (polylinePoints.isNotEmpty)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: polylinePoints.first,
                        child: Icon(
                          Icons.my_location,
                          color: context.colors.mapMarkerStart,
                          size: context.dimensions.iconXLarge,
                        ),
                      ),
                      Marker(
                        point: polylinePoints.last,
                        child: Icon(
                          Icons.location_on,
                          color: context.colors.mapMarkerDestination,
                          size: context.dimensions.iconXXLarge,
                        ),
                      ),
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
