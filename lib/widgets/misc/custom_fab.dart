import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CustomFAB extends StatefulWidget {
  final String text;
  final IconData icon;
  final VoidCallback func;
  final Color? background;
  final Color? foreground;
  final ScrollController? scrollController;

  const CustomFAB({
    Key? key,
    required this.text,
    required this.icon,
    required this.func,
    this.background,
    this.foreground,
    this.scrollController,
  }) : super(key: key);

  @override
  State<CustomFAB> createState() => _CustomFABState();
}

class _CustomFABState extends State<CustomFAB> {
  late bool showFAB;

  @override
  void initState() {
    super.initState();
    if (widget.scrollController != null) {
      widget.scrollController!.addListener(listenScroll);
    }
    showFAB = true;
  }

  @override
  void dispose() {
    if (widget.scrollController != null) {
      widget.scrollController!.removeListener(listenScroll);
    }
    super.dispose();
  }

  void listenScroll() {
    var direction = widget.scrollController!.position.userScrollDirection;
    direction == ScrollDirection.reverse ? hide() : show();
  }

  void show() {
    if (!showFAB) setState(() => showFAB = true);
  }

  void hide() {
    if (showFAB) setState(() => showFAB = false);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 200),
        offset: showFAB ? Offset.zero : const Offset(0, 2),
        child: FloatingActionButton.extended(
          heroTag: null,
          elevation: 3,
          onPressed: widget.func,
          label: Text(
            widget.text,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          extendedPadding: const EdgeInsetsDirectional.all(25),
          icon: Icon(widget.icon),
          backgroundColor:
              widget.background ?? Theme.of(context).colorScheme.primary,
          foregroundColor:
              widget.foreground ?? Theme.of(context).colorScheme.onPrimary,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0))),
        ),
      ),
    );
  }
}
