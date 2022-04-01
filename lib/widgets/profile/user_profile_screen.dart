import 'package:flutter/material.dart';
import 'package:sasae_flutter_app/widgets/profile/info_post_tab.dart';
import 'package:sasae_flutter_app/widgets/profile/user_info_tab.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const InfoPostTab(
      infoTab: UserInfoTab(),
      postTab: Text('Mag'),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
