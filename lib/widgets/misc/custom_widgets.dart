import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:map_launcher/map_launcher.dart';

Widget getCustomFAB({
  required String text,
  required IconData icon,
  required VoidCallback func,
  required Color background,
  required Color foreground,
  double height = 60,
  double width = 120,
}) =>
    SizedBox(
      height: height,
      width: width,
      child: FloatingActionButton.extended(
        elevation: 3,
        onPressed: func,
        label: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        icon: Icon(icon),
        backgroundColor: background,
        foregroundColor: foreground,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0))),
      ),
    );

AppBar getCustomAppBar(
        {required BuildContext context, required String title}) =>
    AppBar(
      title: Text(
        title,
        style: Theme.of(context).textTheme.headline6?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
      ),
      backgroundColor: Colors.transparent,
      foregroundColor: Theme.of(context).colorScheme.onSurface,
      elevation: 0,
    );

void showSnackBar({
  required BuildContext context,
  required String message,
  Color? foreground,
  Color? background,
  bool errorSnackBar = false,
}) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: foreground ??= errorSnackBar
              ? Theme.of(context).colorScheme.onError
              : Theme.of(context).colorScheme.onInverseSurface,
        ),
      ),
      backgroundColor: background ??= errorSnackBar
          ? Theme.of(context).colorScheme.error
          : Theme.of(context).colorScheme.inverseSurface,
    ));

void showModalSheet({
  required BuildContext ctx,
  required List<Widget> children,
  double topPadding = 15,
  double bottomPadding = 10,
  double leftPadding = 15,
  double rightPadding = 15,
  double? height,
}) {
  showModalBottomSheet(
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
