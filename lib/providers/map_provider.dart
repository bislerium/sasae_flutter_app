import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_launcher/map_launcher.dart' as ml;
import 'package:sasae_flutter_app/ui/misc/custom_widgets.dart';

class MapProvider with ChangeNotifier {
  static const double zoom = 16;
  late bool _hasLocationPermission;
  late final LocationSettings _locationSettings;
  MapController? _mapController;
  LatLng? _deviceLocation;
  LatLng? _markedlocation;
  double? _distanceBetweenLocations;
  BuildContext? _context;
  TickerProvider? _tickerP;

  late bool _isDevicePositionStreamPaused;
  StreamSubscription<Position>? _devicePositionStreamSub;

  MapProvider() {
    _setInitalValue();
    _setlocationSettings();
  }

  void _setInitalValue() {
    _hasLocationPermission = false;
    _isDevicePositionStreamPaused = false;
  }

  bool get getHasLocationPermission => _hasLocationPermission;
  LatLng? get getDeviceLocation => _deviceLocation;
  double? get getDistanceBetweenLocations => _distanceBetweenLocations;

  set setMapController(MapController value) => _mapController = value;
  set setMarkedLocation(LatLng value) => _markedlocation = value;
  set setBuildContext(BuildContext value) => _context = value;
  set setTickerProvider(TickerProvider value) => _tickerP = value;

  Future<void> reset() async {
    _setInitalValue();
    _mapController = null;
    _deviceLocation = null;
    _markedlocation = null;
    _distanceBetweenLocations = null;
    _context = null;
    _tickerP = null;
    await _devicePositionStreamSub?.cancel();
    _devicePositionStreamSub = null;
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
          context: _context!,
          message: 'Location service is disabled',
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
            context: _context!,
            message: 'Location permission is denied',
            errorSnackBar: true);
        _hasLocationPermission = false;
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      showSnackBar(
          context: _context!,
          message: 'Permission\'s permanently denied',
          errorSnackBar: true);
      _hasLocationPermission = false;
      return;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    _hasLocationPermission = true;
  }

  void _setlocationSettings() {
    const distanceFilter = 0;
    if (defaultTargetPlatform == TargetPlatform.android) {
      _locationSettings = AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: distanceFilter,
        intervalDuration: const Duration(seconds: 1),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      _locationSettings = AppleSettings(
        accuracy: LocationAccuracy.high,
        activityType: ActivityType.fitness,
        distanceFilter: distanceFilter,
        pauseLocationUpdatesAutomatically: true,
      );
    } else {
      _locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: distanceFilter,
      );
    }
  }

  void listenDeviceLocation() {
    _devicePositionStreamSub =
        Geolocator.getPositionStream(locationSettings: _locationSettings)
            .listen((Position? position) {
      if (position == null) return;
      var latlng = LatLng(position.latitude, position.longitude);
      if (_deviceLocation == null) {
        animateMapMove(latlng);
      }
      _deviceLocation = latlng;
      _distanceBetweenLocations = Geolocator.distanceBetween(
          _deviceLocation!.latitude,
          _deviceLocation!.longitude,
          _markedlocation!.latitude,
          _markedlocation!.longitude);
      notifyListeners();
    })
          ..onError((e) {
            showSnackBar(context: _context!, errorSnackBar: true);
            _hasLocationPermission = false;
            _devicePositionStreamSub?.cancel();
            _distanceBetweenLocations = null;
            _deviceLocation = null;
            notifyListeners();
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
    _distanceBetweenLocations = null;
    _deviceLocation = null;
    notifyListeners();
  }

  void animateMapMove(LatLng destLocation, {double destZoom = zoom}) {
    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.
    final latTween = Tween<double>(
        begin: _mapController?.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(
        begin: _mapController?.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: _mapController?.zoom, end: destZoom);

    // Create a animation controller that has a duration and a TickerProvider.
    var controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: _tickerP!);
    // The animation determines what path the animation will take. You can try different Curves values, although I found
    // fastOutSlowIn to be my favorite.
    Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      _mapController?.move(
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
}

class MapLauncherProvider with ChangeNotifier {
  ml.AvailableMap? _availableMap;

  ml.AvailableMap? get getAvailableMap => _availableMap;

  Future<void> fetchInstalledMap({bool notify = false}) async {
    _availableMap = null;
    final availableMaps = await ml.MapLauncher.installedMaps;
    availableMaps.isEmpty
        ? _availableMap = null
        : _availableMap = availableMaps.first;
    if (notify) notifyListeners();
  }

  Future<void> launchMap({
    required String title,
    required double lat,
    required double lon,
    reFetchInstalledMap = false,
  }) async {
    if (reFetchInstalledMap) await fetchInstalledMap();
    await _availableMap?.showMarker(
      coords: ml.Coords(lat, lon),
      title: title,
    );
  }
}

class CompassProvider with ChangeNotifier {
  late double _compassRotation;
  MapController? _mapController;
  late int _interActiveFlags;
  late bool _isCompassEventStreamPaused;

  StreamSubscription<CompassEvent>? _compassEventStreamSub;
  StreamSubscription<MapEvent>? _mapEventStreamSub;

  CompassProvider() {
    _setInitalValue();
  }

  void _setInitalValue() {
    _compassRotation = 0;
    _interActiveFlags = InteractiveFlag.all;
    _isCompassEventStreamPaused = true;
  }

  double get getCompassRotation => _compassRotation;
  int get getInteractiveFlags => _interActiveFlags;

  set setMapController(MapController value) => _mapController = value;

  Future<void> reset() async {
    _setInitalValue();
    _mapController = null;
    await _compassEventStreamSub?.cancel();
    await _mapEventStreamSub?.cancel();
    _compassEventStreamSub = null;
    _mapEventStreamSub = null;
  }

  void initCompassService() {
    _compassEventStreamSub = FlutterCompass.events?.listen(
      (CompassEvent event) {
        _compassRotation = event.heading == null ? 0 : event.heading! * -1;
        _mapController?.rotate(_compassRotation);
        notifyListeners();
      },
    )?..pause();

    _mapEventStreamSub = _mapController?.mapEventStream.listen((event) {
      var rotation = _mapController?.rotation;
      if (_isCompassEventStreamPaused && rotation != _compassRotation) {
        _compassRotation = _mapController!.rotation;
        notifyListeners();
      }
    });
  }

  void toggleCompass() {
    if (_isCompassEventStreamPaused) {
      _compassEventStreamSub?.resume();
      _interActiveFlags = InteractiveFlag.all - InteractiveFlag.rotate;
    } else {
      _compassEventStreamSub?.pause();
      _interActiveFlags = InteractiveFlag.all;
      _compassRotation = 0;
      _mapController?.rotate(_compassRotation);
    }
    _isCompassEventStreamPaused = !_isCompassEventStreamPaused;
    notifyListeners();
  }
}
