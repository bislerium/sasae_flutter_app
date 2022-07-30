import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sasae_flutter_app/providers/map_provider.dart';
import 'package:sasae_flutter_app/ui/misc/annotated_scaffold.dart';
import 'package:sasae_flutter_app/ui/misc/custom_appbar.dart';
import 'package:sasae_flutter_app/ui/misc/custom_widgets.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';

class MapScreen extends StatefulWidget {
  static const String routeName = '/map/';
  final double latitude;
  final double longitude;
  final String markerTitle;
  // Less than 18
  final double zoom;
  const MapScreen({
    Key? key,
    required this.latitude,
    required this.longitude,
    required this.markerTitle,
    this.zoom = 16,
  }) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  final MapController _mapController;
  bool _isDevicePositionStreamPaused;
  bool _hasLocationPermission;
  LatLng? _deviceLocation;
  double? _distanceInMeters;
  late final LatLng _markedlocation;
  double _compassRotation;
  int _interActiveFlags;
  late final StreamSubscription<CompassEvent>? _compassEventStreamSub;
  late final StreamSubscription<Position>? _devicePositionStreamSub;
  late final StreamSubscription<MapEvent>? _mapEventStreamSub;

  _MapScreenState()
      : _isDevicePositionStreamPaused = false,
        _hasLocationPermission = false,
        _isCompassOn = false,
        _compassRotation = 0,
        _interActiveFlags = InteractiveFlag.all,
        _mapController = MapController();

  @override
  void initState() {
    super.initState();
    Provider.of<MapProvider>(context, listen: false).fetchInstalledMap();
    _markedlocation = LatLng(widget.latitude, widget.longitude);
    initCompassService();
  }

  @override
  void dispose() {
    _devicePositionStreamSub?.cancel();
    _compassEventStreamSub?.cancel();
    _mapEventStreamSub?.cancel();
    _mapController.dispose();
    super.dispose();
  }

  void initCompassService() {
    _compassEventStreamSub =
        FlutterCompass.events?.listen((CompassEvent event) {
      setState(() {
        _compassRotation = event.heading ?? 0;
      });
      _mapController.rotate(_compassRotation);
    })
          ?..pause();

    _mapEventStreamSub = _mapController.mapEventStream.listen((event) {
      var rotation = _mapController.rotation;
      if (!_isCompassOn && rotation != _compassRotation) {
        setState(() {
          _compassRotation = _mapController.rotation;
        });
      }
    });
  }

  Future<void> checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      showSnackBar(
          context: context,
          message: 'Location services are disabled',
          errorSnackBar: true);
      _hasLocationPermission = false;
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        showSnackBar(
            context: context,
            message: 'Location permissions are denied',
            errorSnackBar: true);
        _hasLocationPermission = false;
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      showSnackBar(
          context: context,
          message: 'Location permissions are permanently denied',
          errorSnackBar: true);
      _hasLocationPermission = false;
      return;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    _hasLocationPermission = true;
  }

  void listenDeviceLocation() {
    late LocationSettings locationSettings;
    const distanceFilter = 0;

    if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: distanceFilter,
        intervalDuration: const Duration(seconds: 1),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      locationSettings = AppleSettings(
        accuracy: LocationAccuracy.high,
        activityType: ActivityType.fitness,
        distanceFilter: distanceFilter,
        pauseLocationUpdatesAutomatically: true,
        // Only set to true if our app will be started up in the background.
        showBackgroundLocationIndicator: false,
      );
    } else {
      locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: distanceFilter,
      );
    }

    _devicePositionStreamSub =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) {
      if (position == null) return;
      var latlng = LatLng(position.latitude, position.longitude);
      if (_deviceLocation == null) {
        _animatedMapMove(latlng, widget.zoom);
      }

      setState(() {
        _deviceLocation = latlng;
        _distanceInMeters = Geolocator.distanceBetween(
            _deviceLocation!.latitude,
            _deviceLocation!.longitude,
            _markedlocation.latitude,
            _markedlocation.longitude);
      });
    })
          ..onError((e) {
            showSnackBar(context: context, errorSnackBar: true);
            _hasLocationPermission = false;
            _devicePositionStreamSub?.cancel();
            setState(() {
              _distanceInMeters = null;
              _deviceLocation = null;
            });
          });
  }

  void resumeDeviceLocationStream() {
    if (!_isDevicePositionStreamPaused) return;
    _devicePositionStreamSub?.resume();
    _isDevicePositionStreamPaused = false;
  }

  void pauseDeviceLocationStream() {
    if (_isDevicePositionStreamPaused) return;
    _devicePositionStreamSub?.pause();
    _isDevicePositionStreamPaused = true;
    setState(() {
      _distanceInMeters = null;
      _deviceLocation = null;
    });
  }

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.
    final latTween = Tween<double>(
        begin: _mapController.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(
        begin: _mapController.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: _mapController.zoom, end: destZoom);

    // Create a animation controller that has a duration and a TickerProvider.
    var controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    // The animation determines what path the animation will take. You can try different Curves values, although I found
    // fastOutSlowIn to be my favorite.
    Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      _mapController.move(
          LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
          zoomTween.evaluate(animation));
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

  String _simplfyDistanceUnit(double value) {
    if (value > 1000) {
      return '~${(value / 1000).toStringAsFixed(2)}km away';
    }
    return '~${value.toStringAsFixed(2)}m away';
  }

  bool _isCompassOn;

  void toggleCompass() {
    if (_isCompassOn) {
      _compassEventStreamSub?.pause();
      setState(() {
        _interActiveFlags = InteractiveFlag.all;
        _compassRotation = 0;
      });
      _mapController.rotate(_compassRotation);
    } else {
      _compassEventStreamSub?.resume();
      setState(() {
        _interActiveFlags = InteractiveFlag.all - InteractiveFlag.rotate;
      });
    }
    _isCompassOn = !_isCompassOn;
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedScaffold(
      child: Scaffold(
        appBar: const CustomAppBar(
          title: 'View Location',
        ),
        body: FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            center: _markedlocation,
            zoom: widget.zoom,
            maxZoom: 18.4,
            interactiveFlags: _interActiveFlags,
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
            if (_deviceLocation != null)
              PolylineLayerOptions(
                polylineCulling: false,
                polylines: [
                  Polyline(
                    points: [
                      _deviceLocation!,
                      _markedlocation,
                    ],
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
            MarkerLayerOptions(
              markers: [
                Marker(
                  rotate: true,
                  point: _markedlocation,
                  builder: (context) => Tooltip(
                    triggerMode: TooltipTriggerMode.tap,
                    preferBelow: false,
                    margin: const EdgeInsets.symmetric(horizontal: 80),
                    message: widget.markerTitle,
                    child: Icon(
                      Icons.location_pin,
                      size: 40,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                if (_deviceLocation != null)
                  Marker(
                    rotate: true,
                    point: _deviceLocation!,
                    builder: (ctx) => RippleAnimation(
                      repeat: true,
                      color: Theme.of(context).colorScheme.primaryContainer,
                      minRadius: 60,
                      ripplesCount: 6,
                      child: Icon(
                        Icons.emoji_people_rounded,
                        size: 40,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
              ],
            ),
          ],
          nonRotatedChildren: [
            if (_distanceInMeters != null)
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _simplfyDistanceUnit(_distanceInMeters!),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ),
            AttributionWidget(
              attributionBuilder: (BuildContext context) =>
                  const CustomAttributionWidget(),
            ),
          ],
        ),
        floatingActionButton: Builder(builder: (BuildContext context) {
          return Wrap(
            direction: Axis.vertical,
            crossAxisAlignment: WrapCrossAlignment.end,
            spacing: 10,
            children: [
              Consumer<MapProvider>(
                builder: (BuildContext context, mapP, Widget? child) {
                  if (mapP.getAvailableMap == null) {
                    return const SizedBox.shrink();
                  }
                  return FloatingActionButton(
                    heroTag: 'open-in-map',
                    tooltip: 'Open in ${mapP.getAvailableMap?.mapName}',
                    onPressed: () => mapP.launchMap(
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
                    onPressed: () =>
                        _animatedMapMove(_markedlocation, _mapController.zoom),
                    child: const Icon(
                      Icons.location_pin,
                    ),
                  ),
                  InkWell(
                    onLongPress: pauseDeviceLocationStream,
                    child: FloatingActionButton(
                      heroTag: 'device-location',
                      onPressed: () async {
                        if (!_hasLocationPermission) {
                          await checkLocationPermission();
                          if (_hasLocationPermission) {
                            listenDeviceLocation();
                          } else {
                            return;
                          }
                        }
                        resumeDeviceLocationStream();
                        if (_deviceLocation != null) {
                          _animatedMapMove(_deviceLocation!, widget.zoom);
                        }
                      },
                      child: _deviceLocation == null
                          ? const Icon(Icons.location_searching_rounded)
                          : const Icon(Icons.my_location_rounded),
                    ),
                  ),
                  FloatingActionButton.large(
                    heroTag: 'compass',
                    tooltip: 'Compass',
                    onPressed: toggleCompass,
                    child: Transform.rotate(
                      angle: (_compassRotation * (pi / 180)),
                      child: SvgPicture.asset(
                        'assets/svg/compass.svg',
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        height: 60,
                        semanticsLabel: 'A Compass',
                      ),
                    ),
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
