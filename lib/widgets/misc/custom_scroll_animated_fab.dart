import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CustomScrollAnimatedFAB extends StatefulWidget {
  final Widget child;
  final ScrollController? scrollController;

  const CustomScrollAnimatedFAB({
    Key? key,
    required this.child,
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
      child: widget.child,
    );
  }
}
