import 'dart:ui';

import 'package:flutter/material.dart';

void showSnackBar({
  required BuildContext context,
  String? message,
  IconData? icon,
  bool errorSnackBar = false,
  int durationInSecond = 3,
}) {
  var onError = Theme.of(context).colorScheme.onError;
  var onInfo = Theme.of(context).colorScheme.onInverseSurface;
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      action: SnackBarAction(
        label: 'Dismiss',
        textColor: errorSnackBar ? onError : onInfo,
        onPressed: () {},
      ),
      duration: Duration(seconds: durationInSecond),
      content: Row(
        children: [
          Icon(
            icon ?? (errorSnackBar ? Icons.error_outline : Icons.info_outline),
            color: errorSnackBar ? onError : onInfo,
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            message ?? 'Something went wrong',
            style: TextStyle(
              color: errorSnackBar ? onError : onInfo,
            ),
          ),
        ],
      ),
      backgroundColor: errorSnackBar
          ? Theme.of(context).colorScheme.error
          : Theme.of(context).colorScheme.inverseSurface,
    ),
  );
}

Future<void> showModalSheet({
  required BuildContext context,
  required List<Widget> children,
  double horizontal = 20,
  double? height,
  Color? backgroundColor,
}) async {
  var colors = Theme.of(context).colorScheme;
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: backgroundColor ??
        ElevationOverlay.colorWithOverlay(colors.surface, colors.primary, 3.0),
    builder: (_) {
      return Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(_).viewInsets.bottom + 20,
          left: horizontal,
          right: horizontal,
        ),
        height: height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 5,
              width: 50,
              margin: const EdgeInsets.symmetric(vertical: 20),
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                shape: const StadiumBorder(),
              ),
            ),
            ...children,
          ],
        ),
      );
    },
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(24.0),
      ),
    ),
  );
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
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            ElevatedButton(
              onPressed: okFunc,
              child: const Text(
                'Ok',
              ),
            ),
            TextButton(
              onPressed: cancelFunc ?? () => Navigator.pop(context),
              child: const Text(
                'Cancel',
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
