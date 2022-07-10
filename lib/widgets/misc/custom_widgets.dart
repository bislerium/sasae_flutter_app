import 'dart:ui';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

late Flushbar flushbar;

void showSnackBar({
  required BuildContext context,
  String? message,
  IconData? icon,
  bool errorSnackBar = false,
  int durationInSecond = 6,
}) {
  assert((!errorSnackBar && (message != null)) || errorSnackBar);
  var onError = Theme.of(context).colorScheme.onError;
  var onInfo = Theme.of(context).colorScheme.onInverseSurface;

  flushbar = Flushbar(
    icon: Icon(
      icon ?? (errorSnackBar ? Icons.error_outline : Icons.info_outline),
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
    duration: Duration(seconds: durationInSecond),
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
            ElevatedButton(
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
