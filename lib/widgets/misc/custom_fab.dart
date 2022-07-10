import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/internet_connection_provider.dart';

class CustomFAB extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback? func;
  final Color? background;
  final Color? foreground;
  final String? tooltip;
  const CustomFAB(
      {Key? key,
      required this.text,
      required this.icon,
      required this.func,
      this.background,
      this.foreground,
      this.tooltip})
      : super(key: key);

  @override
  Widget build(BuildContext context) => FloatingActionButton.large(
        heroTag: null,
        onPressed: () {
          if (!Provider.of<InternetConnetionProvider>(context, listen: false)
              .getConnectionStatusCallBack(context)
              .call()) return;
          func!.call();
        },
        tooltip: tooltip,
        backgroundColor: background,
        foregroundColor: foreground,
        // label: Text(
        //   text,
        // ),
        child: Icon(icon),
      );
}
