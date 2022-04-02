import 'package:flutter/material.dart';
import 'package:sasae_flutter_app/widgets/profile/custom_tabbar.dart';

class InfoPostTab extends StatelessWidget {
  final Widget infoTab;
  final Widget postTab;
  final ScrollController infoScrollController;
  final ScrollController postScrollController;
  final EdgeInsets? tabBarMargin;
  const InfoPostTab(
      {Key? key,
      required this.infoTab,
      required this.postTab,
      required this.infoScrollController,
      required this.postScrollController,
      this.tabBarMargin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Stack(
        alignment: AlignmentDirectional.topEnd,
        children: [
          TabBarView(
            children: [
              infoTab,
              postTab,
            ],
          ),
          CustomTabBar(
            infoScrollController: infoScrollController,
            postScrollController: postScrollController,
            margin: tabBarMargin ?? const EdgeInsets.all(20),
          ),
        ],
      ),
    );
  }
}
