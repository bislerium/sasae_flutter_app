import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/models/ngo.dart';
import 'package:sasae_flutter_app/models/people.dart';
import 'package:sasae_flutter_app/models/user.dart';
import 'package:sasae_flutter_app/providers/fab_provider.dart';
import 'package:sasae_flutter_app/providers/profile_provider.dart';
import 'package:sasae_flutter_app/services/utilities.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_loading.dart';
import 'package:sasae_flutter_app/widgets/misc/fetch_error.dart';
import 'package:sasae_flutter_app/ui/profile/change_delete_action.dart';
import 'package:sasae_flutter_app/ui/profile/ngo_profile.dart';
import 'package:sasae_flutter_app/ui/profile/people_profile.dart';
import 'package:sasae_flutter_app/ui/profile/people_profile_edit_screen.dart';

class UserInfoTab extends StatefulWidget {
  final ScrollController scrollController;
  const UserInfoTab({Key? key, required this.scrollController})
      : super(key: key);

  @override
  State<UserInfoTab> createState() => _UserInfoTabState();
}

class _UserInfoTabState extends State<UserInfoTab>
    with AutomaticKeepAliveClientMixin {
  late final Future<void> _fetchUserFUTURE;
  late final ProfileSettingFABProvider profileSettingFABP;
  late final ProfileProvider profileP;

  @override
  void initState() {
    super.initState();
    profileSettingFABP =
        Provider.of<ProfileSettingFABProvider>(context, listen: false);
    profileP = Provider.of<ProfileProvider>(context, listen: false);
    widget.scrollController.addListener(profleEditfabListenScroll);
    _fetchUserFUTURE = _fetchUser();
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(profleEditfabListenScroll);
    super.dispose();
  }

  Future<void> _fetchUser() async {
    await profileP.initFetchUser();
    UserModel? data = profileP.getUserData;
    if (data == null) {
      profileSettingFABP.setOnPressedHandler = null;
      profileSettingFABP.setShowFAB = false;
      return;
    }
    if (data is NGOModel) {
      profileSettingFABP.setOnPressedHandler = null;
      profileSettingFABP.setUserType = UserType.ngo;
      profileSettingFABP.setShowFAB = false;
      return;
    }
    if (data is PeopleModel) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        profileSettingFABP.setOnPressedHandler = () => Navigator.pushNamed(
              context,
              PeopleProfileEditScreen.routeName,
            );
      });
      profileSettingFABP.setUserType = UserType.people;
      profileSettingFABP.setShowFAB = true;
    }
  }

  void profleEditfabListenScroll() {
    var a = Provider.of<ProfileSettingFABProvider>(context, listen: false);
    var direction = widget.scrollController.position.userScrollDirection;
    if (profileP.getUserData is PeopleModel) {
      direction == ScrollDirection.reverse
          ? a.setShowFAB = false
          : a.setShowFAB = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: _fetchUserFUTURE,
      builder: (context, snapshot) =>
          snapshot.connectionState == ConnectionState.waiting
              ? const CustomLoading()
              : Consumer<ProfileProvider>(
                  builder: (context, profileP, child) => RefreshIndicator(
                    onRefresh: () async => await refreshCallBack(
                      context: context,
                      func: _fetchUser,
                    ),
                    child: profileP.getUserData == null
                        ? const ErrorView()
                        : profileP.getUserData is PeopleModel
                            ? ListView(
                                controller: widget.scrollController,
                                children: [
                                  const ChangeDeleteAction(),
                                  PeopleProfile(
                                    peopleData:
                                        profileP.getUserData! as PeopleModel,
                                  ),
                                ],
                              )
                            : ListView(
                                controller: widget.scrollController,
                                children: [
                                  const ChangeDeleteAction(
                                    deletable: false,
                                  ),
                                  NGOProfile(
                                    ngoData: profileP.getUserData! as NGOModel,
                                  ),
                                ],
                              ),
                  ),
                ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
