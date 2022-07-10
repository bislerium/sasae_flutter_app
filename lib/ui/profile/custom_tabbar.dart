import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CustomTabBar extends StatefulWidget {
  final ScrollController infoScrollController;
  final ScrollController postScrollController;
  final EdgeInsets margin;
  const CustomTabBar(
      {Key? key,
      required this.infoScrollController,
      required this.postScrollController,
      required this.margin})
      : super(key: key);

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  late bool showTabBar;

  @override
  void initState() {
    super.initState();
    widget.infoScrollController.addListener(infoListenScroll);
    widget.postScrollController.addListener(postListenScroll);
    showTabBar = true;
  }

  @override
  void dispose() {
    widget.infoScrollController.removeListener(infoListenScroll);
    widget.postScrollController.removeListener(postListenScroll);
    super.dispose();
  }

  void infoListenScroll() {
    var direction = widget.infoScrollController.position.userScrollDirection;
    direction == ScrollDirection.reverse ? hide() : show();
  }

  void postListenScroll() {
    var direction = widget.postScrollController.position.userScrollDirection;
    direction == ScrollDirection.reverse ? hide() : show();
  }

  void show() {
    if (!showTabBar) setState(() => showTabBar = true);
  }

  void hide() {
    if (showTabBar) setState(() => showTabBar = false);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      duration: const Duration(milliseconds: 200),
      offset: showTabBar ? Offset.zero : const Offset(1, 0),
      child: Container(
        padding: const EdgeInsets.all(5),
        margin: widget.margin,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: Theme(
          data: ThemeData(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent),
          child: TabBar(
            isScrollable: true,
            labelColor: Theme.of(context).colorScheme.onSecondary,
            unselectedLabelColor: Theme.of(context).colorScheme.outline,
            indicator: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(30),
            ),
            enableFeedback: true,
            tabs: const [
              Tooltip(
                message: 'Information',
                child: Tab(
                  icon: Icon(
                    Icons.info_outline_rounded,
                  ),
                ),
              ),
              Tooltip(
                message: 'Posts',
                child: Tab(
                  icon: Icon(
                    Icons.post_add_outlined,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
