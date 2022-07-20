import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/visibility_provider.dart';
import 'package:flutter/rendering.dart';

class InfoPostTab extends StatelessWidget {
  final Widget infoTab;
  final Widget postTab;
  final ScrollController infoScrollController;
  final ScrollController postScrollController;
  final FABType fabType;
  final EdgeInsets? tabBarMargin;
  const InfoPostTab(
      {Key? key,
      required this.infoTab,
      required this.postTab,
      required this.infoScrollController,
      required this.postScrollController,
      required this.fabType,
      this.tabBarMargin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Builder(builder: (context) {
        final TabController tabController = DefaultTabController.of(context)!;
        dynamic a;
        tabController.addListener(() {
          switch (fabType) {
            case FABType.editProfile:
              a = Provider.of<ProfileSettingFABProvider>(context,
                  listen: false);
              break;
            case FABType.donation:
              a = Provider.of<DonationFABProvider>(context, listen: false);
              break;
          }

          if (!tabController.indexIsChanging) {
            int index = tabController.index;
            a.setTabIndex = index;
            index == 0 ? a.setShowFAB = true : a.setShowFAB = false;
          }
        });
        return Stack(
          alignment: AlignmentDirectional.topEnd,
          children: [
            TabBarView(
              children: [
                infoTab,
                postTab,
              ],
            ),
            TabPill(
              infoScrollController: infoScrollController,
              postScrollController: postScrollController,
              margin: tabBarMargin ?? const EdgeInsets.all(20),
            ),
          ],
        );
      }),
    );
  }
}

class TabPill extends StatefulWidget {
  final ScrollController infoScrollController;
  final ScrollController postScrollController;
  final EdgeInsets margin;
  const TabPill(
      {Key? key,
      required this.infoScrollController,
      required this.postScrollController,
      required this.margin})
      : super(key: key);

  @override
  State<TabPill> createState() => _TabPillState();
}

class _TabPillState extends State<TabPill> {
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
          color: Theme.of(context).colorScheme.surfaceVariant,
        ),
        child: Theme(
          data: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: TabBar(
            isScrollable: true,
            labelColor: Theme.of(context).colorScheme.onPrimary,
            unselectedLabelColor: Theme.of(context).colorScheme.outline,
            indicator: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
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
