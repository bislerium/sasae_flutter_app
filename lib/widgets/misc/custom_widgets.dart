import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:randexp/randexp.dart';
import 'package:http/http.dart' as http;

late Flushbar flushbar;

void showSnackBar({
  required BuildContext context,
  String? message,
  bool errorSnackBar = false,
}) {
  assert((!errorSnackBar && (message != null)) || errorSnackBar);
  var onError = Theme.of(context).colorScheme.onError;
  var onInfo = Theme.of(context).colorScheme.onInverseSurface;

  flushbar = Flushbar(
    icon: Icon(
      errorSnackBar ? Icons.error_outline : Icons.info_outline,
      color: errorSnackBar ? onError : onInfo,
    ),
    margin: const EdgeInsets.all(12),
    borderRadius: BorderRadius.circular(6),
    message: message ?? 'Something went wrong',
    // messageSize: 16,
    messageColor: errorSnackBar ? onError : onInfo,
    backgroundColor: errorSnackBar
        ? Theme.of(context).colorScheme.error
        : Theme.of(context).colorScheme.inverseSurface,
    duration: const Duration(seconds: 6),
    mainButton: TextButton(
      onPressed: () => flushbar.dismiss(true),
      child: Text(
        "Dismiss",
        style: TextStyle(
          color: errorSnackBar ? onError : onInfo,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    animationDuration: const Duration(milliseconds: 600),
  )..show(context);
}

Future<void> showModalSheet({
  required BuildContext ctx,
  required List<Widget> children,
  double topPadding = 15,
  double bottomPadding = 10,
  double leftPadding = 15,
  double rightPadding = 15,
  double? height,
}) async {
  await showModalBottomSheet(
    context: ctx,
    isScrollControlled: true,
    backgroundColor: Theme.of(ctx).colorScheme.surface,
    builder: (_) {
      return Padding(
        padding: EdgeInsets.only(
            top: topPadding,
            bottom: MediaQuery.of(_).viewInsets.bottom + bottomPadding,
            left: leftPadding,
            right: rightPadding),
        child: SizedBox(
          height: height,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: children,
          ),
        ),
      );
    },
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(25.0),
      ),
    ),
  );
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
  showSnackBar(context: ctx, message: 'Copiied to clipboard!');
}

String? checkValue({
  String? value,
  bool checkEmptyOnly = false,
  String emptyMessage = 'Required Field!',
  String? pattern,
  String? patternMessage,
  bool checkInt = false,
  bool checkDecimal = false,
}) {
  assert(
      checkInt && checkDecimal, 'Either mark checkInt or checkDecimal: TRUE');
  bool isValueEmpty = value == null || value.isEmpty;
  var intPattern = r'^-?(([0-9]*))$';
  var decimalPattern = r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$';
  if (isValueEmpty) return emptyMessage;
  if (checkEmptyOnly && !isValueEmpty) return null;
  if (checkInt) {
    pattern = intPattern;
    patternMessage = 'Only numeric non-decimal values accepted!';
  }
  if (checkDecimal) {
    pattern = decimalPattern;
    patternMessage = 'Only numeric values accepted!';
  }
  return RegExp(pattern!).hasMatch(value) ? null : patternMessage;
}

num turnicate(num value, {int decimalPlace = 1}) {
  var _ = pow(10, decimalPlace);
  var turnicatedValue = (value * _).truncateToDouble() / _;
  return turnicatedValue % 1 == 0 ? turnicatedValue.toInt() : turnicatedValue;
}

String numToK(int number) {
  var k = 1000;
  return number < k ? number.toString() : '${turnicate(number / k)}k';
}

void showCustomDialog(
        {required BuildContext context,
        required String title,
        required String content,
        required void Function() okFunc,
        void Function()? cancelFunc,
        required}) =>
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 8,
          sigmaY: 8,
        ),
        child: AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 3,
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              onPressed: okFunc,
              child: Text(
                'Ok',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            TextButton(
              onPressed: cancelFunc ?? () => Navigator.pop(context, 'Cancel'),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );

Widget getWrappedChips(
        {required BuildContext context,
        required List<String> list,
        bool center = true}) =>
    Wrap(
      alignment: center ? WrapAlignment.center : WrapAlignment.start,
      spacing: 8,
      runSpacing: -5,
      children: list
          .map(
            (e) => Chip(
              label: Text(
                e,
                style: Theme.of(context).textTheme.subtitle1?.copyWith(
                    color: Theme.of(context).colorScheme.onSecondaryContainer),
              ),
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            ),
          )
          .toList(),
    );

Future<XFile> imageURLToXFile(String imageURL) async => XFile(
      (await DefaultCacheManager().getSingleFile(imageURL)).path,
    );
