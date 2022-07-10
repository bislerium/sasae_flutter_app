import 'dart:async';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:provider/provider.dart';
import 'package:randexp/randexp.dart';
import 'package:sasae_flutter_app/providers/internet_connection_provider.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_widgets.dart';

Future<void> refreshCallBack(
    {required BuildContext context,
    required Future<void> Function() func}) async {
  if (!Provider.of<InternetConnetionProvider>(context, listen: false)
      .getConnectionStatusCallBack(context)
      .call()) return;
  await func.call();
}

Future<XFile> imageURLToXFile(String imageURL) async => XFile(
      (await DefaultCacheManager().getSingleFile(imageURL)).path,
    );

num turnicate(num value, {int decimalPlace = 1}) {
  var _ = pow(10, decimalPlace);
  var turnicatedValue = (value * _).truncateToDouble() / _;
  return turnicatedValue % 1 == 0 ? turnicatedValue.toInt() : turnicatedValue;
}

String numToK(int number) {
  var k = 1000;
  return number < k ? number.toString() : '${turnicate(number / k)}k';
}

//Generates Nepal Phone Number
String getRandPhoneNumber() => RandExp(RegExp(r'(^[9][678][0-9]{8}$)')).gen();

Future<void> launchMap(
    {required String title, required double lat, required double lon}) async {
  final availableMaps = await MapLauncher.installedMaps;
  if (availableMaps.isNotEmpty) {
    await availableMaps.first.showMarker(
      coords: Coords(lat, lon),
      title: title,
    );
  }
}

Future<void> copyToClipboard(
    {required BuildContext ctx, required String text}) async {
  await Clipboard.setData(ClipboardData(text: text));
  showSnackBar(context: ctx, message: 'Copied to clipboard');
}

StreamSubscription<ConnectivityResult> getConnectivitySubscription(
    BuildContext context) {
  return Connectivity()
      .onConnectivityChanged
      .listen((ConnectivityResult result) {
    if (ConnectivityResult.none == result) {
      Provider.of<InternetConnetionProvider>(context, listen: false)
          .setIsConnected = false;
      showSnackBar(
        context: context,
        icon: Icons.cloud_outlined,
        message: 'Internet disconnected',
        errorSnackBar: true,
      );
    } else {
      Provider.of<InternetConnetionProvider>(context, listen: false)
          .setIsConnected = true;
      showSnackBar(
        context: context,
        icon: Icons.cloud_outlined,
        message: 'Internet connected',
      );
    }
  });
}
