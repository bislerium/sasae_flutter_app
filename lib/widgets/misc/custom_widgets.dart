import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart';

Widget getCustomFAB({
  required String text,
  required IconData icon,
  required VoidCallback func,
  required Color background,
  required Color foreground,
}) =>
    SizedBox(
      height: 60,
      width: 120,
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
      title: Text(title),
      backgroundColor: Colors.transparent,
      foregroundColor: Theme.of(context).colorScheme.onSurface,
      elevation: 0,
    );

void showSnackBar({
  required BuildContext context,
  required String message,
  Color? textColor,
  Color? background,
}) =>
    SnackBar(
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: textColor ?? Theme.of(context).colorScheme.onInverseSurface,
        ),
      ),
      backgroundColor:
          background ?? Theme.of(context).colorScheme.inverseSurface,
    );

void showModalSheet({
  required BuildContext ctx,
  required List<Widget> children,
  double topPadding = 15,
  double bottomPadding = 10,
  double leftPadding = 15,
  double rightPadding = 15,
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: children,
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
