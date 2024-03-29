import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:randexp/randexp.dart';
import 'package:sasae_flutter_app/providers/auth_provider.dart';
import 'package:sasae_flutter_app/providers/internet_connection_provider.dart';
import 'package:sasae_flutter_app/ui/misc/custom_widgets.dart';

Future<void> refreshCallBack(
    {required BuildContext context,
    required Future<void> Function() func}) async {
  if (isInternetConnected(context)) await func.call();
}

Future<XFile> imageURLToXFile(String imageURL) async => XFile(
      (await DefaultCacheManager().getSingleFile(imageURL)).path,
    );

int getUniqueID() => DateTime.now().millisecondsSinceEpoch.remainder(2);

Future<String> writeImageToStorage(Uint8List feedbackScreenshot) async {
  final Directory output = await getTemporaryDirectory();
  final String screenshotFilePath =
      '${output.path}/feedback-${generateUID()}.png';
  final File screenshotFile = File(screenshotFilePath);
  await screenshotFile.writeAsBytes(feedbackScreenshot);
  return screenshotFilePath;
}

bool isProfileVerified(BuildContext context) {
  if (Provider.of<AuthProvider>(context, listen: false).getAuth!.isVerified) {
    return true;
  }
  showSnackBar(
      context: context,
      icon: Icons.question_mark_rounded,
      message: 'Verified account required',
      errorSnackBar: true);
  return false;
}

bool isInternetConnected(BuildContext context) {
  if (Provider.of<InternetConnectionProvider>(context, listen: false)
      .getIsConnected) {
    return true;
  }
  showSnackBar(
      context: context,
      icon: Icons.cloud_off,
      message: 'No internet connection',
      errorSnackBar: true);
  return false;
}

String generateUID() => DateTime.now().microsecondsSinceEpoch.toString();

num turnicate(num value, {int decimalPlace = 1}) {
  var a = pow(10, decimalPlace);
  var turnicatedValue = (value * a).truncateToDouble() / a;
  return turnicatedValue % 1 == 0 ? turnicatedValue.toInt() : turnicatedValue;
}

String numToK(int number) {
  var k = 1000;
  return number < k ? number.toString() : '${turnicate(number / k)}k';
}

//Generates Nepal Phone Number
String getRandPhoneNumber() => RandExp(RegExp(r'(^[9][678][0-9]{8}$)')).gen();

Future<void> copyToClipboard(
    {required BuildContext ctx, required String text}) async {
  await Clipboard.setData(ClipboardData(text: text));
  showSnackBar(context: ctx, message: 'Copied to clipboard');
}

bool isFirstConnection = true;

StreamSubscription<ConnectivityResult> getConnectivitySubscription(
    BuildContext context) {
  return Connectivity()
      .onConnectivityChanged
      .listen((ConnectivityResult result) {
    if (ConnectivityResult.none == result) {
      Provider.of<InternetConnectionProvider>(context, listen: false)
          .setIsConnected = false;
      showSnackBar(
        context: context,
        icon: Icons.ssid_chart_rounded,
        message: 'Internet disconnected',
        errorSnackBar: true,
      );
    } else {
      Provider.of<InternetConnectionProvider>(context, listen: false)
          .setIsConnected = true;
      isFirstConnection
          ? isFirstConnection = false
          : showSnackBar(
              context: context,
              icon: Icons.cloud_outlined,
              message: 'Internet connected',
            );
    }
  });
}
