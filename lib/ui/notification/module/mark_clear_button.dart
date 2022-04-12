import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/notification_provider.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_widgets.dart';

class MarkClearButton extends StatefulWidget {
  final ScrollController scrollController;

  const MarkClearButton({Key? key, required this.scrollController})
      : super(key: key);

  @override
  State<MarkClearButton> createState() => _MarkClearButtonState();
}

class _MarkClearButtonState extends State<MarkClearButton> {
  late bool showButton;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(infoListenScroll);
    showButton = true;
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(infoListenScroll);
    super.dispose();
  }

  void infoListenScroll() {
    var direction = widget.scrollController.position.userScrollDirection;
    direction == ScrollDirection.reverse ? hide() : show();
  }

  void postListenScroll() {
    var direction = widget.scrollController.position.userScrollDirection;
    direction == ScrollDirection.reverse ? hide() : show();
  }

  void show() {
    if (!showButton) setState(() => showButton = true);
  }

  void hide() {
    if (showButton) setState(() => showButton = false);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      duration: const Duration(milliseconds: 200),
      offset: showButton ? Offset.zero : const Offset(0, 1),
      child: Container(
        margin: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () async {
                showCustomDialog(
                    context: context,
                    title: 'Clear Notifications',
                    content: 'You cannot undo this action.',
                    okFunc: () {
                      Provider.of<NotificationProvider>(context, listen: false)
                          .clearNotification();
                      Navigator.of(context).pop();
                    });
              },
              icon: const Icon(Icons.clear_all_rounded),
              label: const Text(
                'Clear',
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () async =>
                  Provider.of<NotificationProvider>(context, listen: false)
                      .markAsReadAll(),
              icon: const Icon(Icons.check_circle_rounded),
              label: const Text(
                'Mark',
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
