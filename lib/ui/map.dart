import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sasae_flutter_app/ui/misc/annotated_scaffold.dart';
import 'package:sasae_flutter_app/ui/misc/custom_appbar.dart';

class OSM extends StatefulWidget {
  static const String routeName = '/map/';
  final double latitude;
  final double longitude;
  // Less than 18
  final double zoom;
  const OSM({
    Key? key,
    required this.latitude,
    required this.longitude,
    this.zoom = 16,
  }) : super(key: key);

  @override
  State<OSM> createState() => _OSMState();
}

class _OSMState extends State<OSM> {
  @override
  Widget build(BuildContext context) {
    var latLong = LatLng(widget.latitude, widget.longitude);
    return AnnotatedScaffold(
      child: Scaffold(
        appBar: const CustomAppBar(
          title: 'View NGO',
        ),
        body: FlutterMap(
          options: MapOptions(
            center: latLong,
            zoom: widget.zoom,
            maxZoom: 18.4,
            maxBounds: LatLngBounds(LatLng(-90, -180.0), LatLng(90.0, 180.0)),
          ),
          layers: [
            TileLayerOptions(
              urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
              userAgentPackageName: 'com.bishalgc.sasae.app',
              tileProvider: NetworkTileProvider(),
              backgroundColor: Theme.of(context).colorScheme.background,
              tilesContainerBuilder:
                  Theme.of(context).brightness == Brightness.dark
                      ? darkModeTilesContainerBuilder
                      : null,
            ),
            MarkerLayerOptions(
              markers: [
                Marker(
                  point: latLong,
                  builder: (context) => const Icon(
                    Icons.location_pin,
                    size: 40,
                    color: Colors.deepPurpleAccent,
                  ),
                ),
              ],
            ),
          ],
          nonRotatedChildren: [
            AttributionWidget(
              attributionBuilder: (BuildContext context) =>
                  const CustomAttributionWidget(),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomAttributionWidget extends StatelessWidget {
  const CustomAttributionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(12)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 3, 3, 3),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('flutter_map | © '),
              Text(
                'OpenStreetMap contributors',
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
