import 'dart:ui';

import 'package:flutter/material.dart';

void showSnackBar({
  required BuildContext context,
  String? message,
  IconData? icon,
  bool errorSnackBar = false,
  int durationInSecond = 6,
}) {
  var onError = Theme.of(context).colorScheme.onError;
  var onInfo = Theme.of(context).colorScheme.onInverseSurface;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      action: SnackBarAction(
        label: 'Dismiss',
        textColor: errorSnackBar ? onError : onInfo,
        onPressed: () {},
      ),
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
