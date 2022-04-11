import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/fab_provider.dart';
import 'package:sasae_flutter_app/ui/profile/custom_tabbar.dart';

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
        dynamic _;
        tabController.addListener(() {
          switch (fabType) {
            case FABType.editProfile:
              _ = Provider.of<ProfileSettingFABProvider>(context,
                  listen: false);
              break;
            case FABType.donation:
              _ = Provider.of<DonationFABProvider>(context, listen: false);
              break;
          }

          if (!tabController.indexIsChanging) {
            int index = tabController.index;
            _.setTabIndex = index;
            index == 0 ? _.setShowFAB = true : _.setShowFAB = false;
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
            CustomTabBar(
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
