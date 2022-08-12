import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/map_provider.dart';
import 'package:sasae_flutter_app/ui/icon/custom_icons.dart';
import 'package:sasae_flutter_app/ui/misc/annotated_scaffold.dart';
import 'package:sasae_flutter_app/ui/misc/custom_appbar.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';

class MapScreen extends StatefulWidget {
  static const String routeName = '/map/';
  final double latitude;
  final double longitude;
  final String markerTitle;
  const MapScreen({
    Key? key,
    required this.latitude,
    required this.longitude,
    required this.markerTitle,
  }) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  final MapController _mapController;
  late final LatLng _markedLocation;
  late final MapProvider _mapP;
  late final CompassProvider _compassP;
  late final MapLauncherProvider _mapLauncherP;

  _MapScreenState() : _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _mapP = Provider.of<MapProvider>(context, listen: false);
    _compassP = Provider.of<CompassProvider>(context, listen: false);
    _mapLauncherP = Provider.of<MapLauncherProvider>(context, listen: false);
    _markedLocation = LatLng(widget.latitude, widget.longitude);
    initMapProviderService();
  }

  initMapProviderService() {
    _mapLauncherP.fetchInstalledMap(notify: true);
    _mapP.setMapController = _mapController;
    _mapP.setMarkedLocation = _markedLocation;
    _mapP.setBuildContext = context;
    _mapP.setTickerProvider = this;
    _compassP.setMapController = _mapController;
    _compassP.initCompassService();
  }

  @override
  void dispose() {
    _mapController.dispose();
    _mapP.reset();
    _compassP.reset();
    super.dispose();
  }

  String _simplifyDistanceUnit(double value) {
    if (value > 1000) {
      return '~${(value / 1000).toStringAsFixed(2)}km away';
    }
    return '~${value.toStringAsFixed(2)}m away';
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedScaffold(
      child: Scaffold(
        appBar: const CustomAppBar(
          title: 'View Location',
        ),
        body: Consumer2<MapProvider, CompassProvider>(
          builder: ((context, mapP, compassP, child) => FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  center: _markedLocation,
                  zoom: MapProvider.zoom,
                  maxZoom: 18.4,
                  interactiveFlags: mapP.getIsNavigationMode
                      ? compassP.getInteractiveFlags -
                          InteractiveFlag.pinchMove -
                          InteractiveFlag.drag -
                          InteractiveFlag.flingAnimation
                      : compassP.getInteractiveFlags,
                  maxBounds:
                      LatLngBounds(LatLng(-90, -180.0), LatLng(90.0, 180.0)),
                ),
                layers: [
                  TileLayerOptions(
                    urlTemplate:
                        "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
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
                        rotate: true,
                        point: _markedLocation,
                        builder: (context) => Tooltip(
                          triggerMode: TooltipTriggerMode.tap,
                          preferBelow: false,
                          margin: const EdgeInsets.symmetric(horizontal: 80),
                          message: widget.markerTitle,
                          child: Icon(
                            Icons.location_pin,
                            size: 40,
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
                        ),
                      ),
                      if (mapP.getDeviceLocation != null)
                        Marker(
                          rotate: true,
                          point: mapP.getDeviceLocation!,
                          anchorPos: AnchorPos.align(AnchorAlign.top),
                          builder: (ctx) => mapP.getIsNavigationMode
                              ? Icon(
                                  Icons.navigation_rounded,
                                  size: 40,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                )
                              : RippleAnimation(
                                  repeat: true,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                  minRadius: 60,
                                  ripplesCount: 6,
                                  child: Icon(
                                    Icons.emoji_people_rounded,
                                    size: 40,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                  ),
                                ),
                        ),
                    ],
                  ),
                ],
                nonRotatedChildren: [
                  if (mapP.getDistanceBetweenLocations != null)
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          _simplifyDistanceUnit(
                              mapP.getDistanceBetweenLocations!),
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
                        ),
                      ),
                    ),
                  AttributionWidget(
                    attributionBuilder: (BuildContext context) =>
                        const CustomAttributionWidget(),
                  ),
                ],
              )),
        ),
        floatingActionButton: Builder(builder: (BuildContext context) {
          return Wrap(
            direction: Axis.vertical,
            crossAxisAlignment: WrapCrossAlignment.end,
            spacing: 10,
            children: [
              Consumer<MapLauncherProvider>(
                builder: (BuildContext context, mapLauncherP, Widget? child) {
                  if (mapLauncherP.getAvailableMap == null) {
                    return const SizedBox.shrink();
                  }
                  return FloatingActionButton(
                    backgroundColor:
                        Theme.of(context).colorScheme.tertiaryContainer,
                    heroTag: 'open-in-map',
                    tooltip: 'Open in ${mapLauncherP.getAvailableMap?.mapName}',
                    onPressed: () => mapLauncherP.launchMap(
                      title: widget.markerTitle,
                      lat: widget.latitude,
                      lon: widget.longitude,
                    ),
                    child: const Icon(
                      Icons.map_rounded,
                    ),
                  );
                },
              ),
              Wrap(
                spacing: 10,
                crossAxisAlignment: WrapCrossAlignment.end,
                children: [
                  FloatingActionButton(
                    heroTag: 'marked-location',
                    tooltip: 'Marked location',
                    backgroundColor:
                        Theme.of(context).colorScheme.secondaryContainer,
                    onPressed: _mapP.moveToMarker,
                    child: const Icon(
                      Icons.location_pin,
                    ),
                  ),
                  Consumer<MapProvider>(
                    builder: ((context, mapP, child) => InkWell(
                          onLongPress: mapP.pauseDeviceLocationStream,
                          child: FloatingActionButton(
                            heroTag: 'device-location',
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .secondaryContainer,
                            onPressed: () async {
                              if (!mapP.getHasLocationPermission) {
                                await mapP.checkLocationPermission();
                                if (mapP.getHasLocationPermission) {
                                  mapP.listenDeviceLocation();
                                  mapP.setIsDeviceLocationFocused = true;
                                  return;
                                }
                              }
                              mapP.toggleNavigationMode();
                            },
                            child: mapP.getDeviceLocation == null
                                ? const Icon(Icons.location_searching_rounded)
                                : const Icon(Icons.my_location_rounded),
                          ),
                        )),
                  ),
                  Consumer<CompassProvider>(
                    builder: ((context, compassP, child) =>
                        FloatingActionButton.large(
                          heroTag: 'compass',
                          tooltip: 'Compass',
                          onPressed: compassP.toggleCompass,
                          child: Transform.rotate(
                            angle: (compassP.getCompassRotation * (pi / 180)),
                            child: Icon(
                              CustomIcons.compass,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                              size: 64,
                            ),
                          ),
                        )),
                  ),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }
}

class CustomAttributionWidget extends StatelessWidget {
  const CustomAttributionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Tooltip(
            message: 'flutter_map | © OpenStreetMap contributors',
            child: Icon(Icons.copyright_rounded)),
      ),
    );
  }
}
