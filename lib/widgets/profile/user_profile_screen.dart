import 'package:flutter/material.dart';
import 'package:sasae_flutter_app/widgets/profile/info_post_tab.dart';
import 'package:sasae_flutter_app/widgets/profile/user_info_tab.dart';
import 'package:sasae_flutter_app/widgets/profile/user_post_tab.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _infoScrollController;
  final ScrollController _postScrollController;

  _UserProfileState()
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
      postTab: UserPostTab(
        scrollController: _postScrollController,
        actionablePost: true,
      ),
      infoScrollController: _infoScrollController,
      postScrollController: _postScrollController,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
