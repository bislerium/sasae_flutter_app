import 'package:flutter/cupertino.dart';
import 'package:map_launcher/map_launcher.dart';

class MapProvider with ChangeNotifier {
  AvailableMap? _availableMap;

  AvailableMap? get getAvailableMap => _availableMap;

  Future<void> fetchInstalledMap() async {
    _availableMap = null;
    final availableMaps = await MapLauncher.installedMaps;
    availableMaps.isEmpty
        ? _availableMap = null
        : _availableMap = availableMaps.first;
    notifyListeners();
  }

  Future<void> launchMap({
    required String title,
    required double lat,
    required double lon,
    reFetchInstalledMap = false,
  }) async {
    if (reFetchInstalledMap) await fetchInstalledMap();
    await _availableMap?.showMarker(
      coords: Coords(lat, lon),
      title: title,
    );
  }
}
