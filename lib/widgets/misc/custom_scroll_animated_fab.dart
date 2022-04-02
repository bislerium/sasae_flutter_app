import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_fab.dart';

class CustomScrollAnimatedFAB extends StatefulWidget {
  final String text;
  final IconData icon;
  final VoidCallback func;
  final Color? background;
  final Color? foreground;
  final ScrollController? scrollController;

  const CustomScrollAnimatedFAB({
    Key? key,
    required this.text,
    required this.icon,
    required this.func,
    this.background,
    this.foreground,
    this.scrollController,
  }) : super(key: key);

  @override
  State<CustomScrollAnimatedFAB> createState() =>
      _CustomScrollAnimatedFABState();
}

class _CustomScrollAnimatedFABState extends State<CustomScrollAnimatedFAB> {
  late bool showFAB;

  @override
  void initState() {
    super.initState();
    if (widget.scrollController != null) {
      widget.scrollController!.addListener(listenScrollForFAB);
    }
    showFAB = true;
  }

  @override
  void dispose() {
    if (widget.scrollController != null) {
      widget.scrollController!.removeListener(listenScrollForFAB);
    }
    super.dispose();
  }

  void listenScrollForFAB() {
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
    return AnimatedSlide(
      duration: const Duration(milliseconds: 200),
      offset: showFAB ? Offset.zero : const Offset(0, 2),
      child: SizedBox(
        height: 60,
        child: CustomFAB(
          func: widget.func,
          text: widget.text,
          icon: widget.icon,
          background: widget.background,
          foreground: widget.foreground,
        ),
      ),
    );
  }
}
