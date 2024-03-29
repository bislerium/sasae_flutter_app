import 'package:flutter/material.dart';
import 'package:sasae_flutter_app/providers/visibility_provider.dart';
import 'package:sasae_flutter_app/ui/profile/tab/info_post_tab_view.dart';
import 'package:sasae_flutter_app/ui/profile/tab/user_info_tab.dart';
import 'package:sasae_flutter_app/ui/profile/tab/profile_post_tab.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _infoScrollController;
  final ScrollController _postScrollController;

  _UserProfilePageState()
      : _infoScrollController = ScrollController(),
        _postScrollController = ScrollController();

  @override
  void dispose() {
    _infoScrollController.dispose();
    _postScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return InfoPostTab(
      infoTab: UserInfoTab(
        scrollController: _infoScrollController,
      ),
      postTab: UserProfilePostTab(
        scrollController: _postScrollController,
        actionablePost: true,
      ),
      infoScrollController: _infoScrollController,
      postScrollController: _postScrollController,
      fabType: FABType.editProfile,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
