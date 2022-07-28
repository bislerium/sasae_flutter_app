import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/models/ngo.dart';
import 'package:sasae_flutter_app/models/people.dart';
import 'package:sasae_flutter_app/models/user.dart';
import 'package:sasae_flutter_app/providers/auth_provider.dart';
import 'package:sasae_flutter_app/providers/visibility_provider.dart';
import 'package:sasae_flutter_app/providers/profile_provider.dart';
import 'package:sasae_flutter_app/services/utilities.dart';
import 'package:sasae_flutter_app/ui/misc/custom_loading.dart';
import 'package:sasae_flutter_app/ui/misc/fetch_error.dart';
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
  late final NavigationBarProvider _navigationBarP;
  late final ProfileSettingFABProvider _profileSettingFABP;
  late final ProfileProvider _profileP;

  @override
  void initState() {
    super.initState();
    _profileSettingFABP =
        Provider.of<ProfileSettingFABProvider>(context, listen: false);
    _navigationBarP =
        Provider.of<NavigationBarProvider>(context, listen: false);
    _profileP = Provider.of<ProfileProvider>(context, listen: false);
    widget.scrollController.addListener(profleEditfabListenScroll);
    _fetchUserFUTURE = _fetchUser();
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(profleEditfabListenScroll);
    _profileP.disposeUserProfile();
    super.dispose();
  }

  Future<void> _fetchUser() async {
    await _profileP.initFetchUser();
    UserModel? data = _profileP.getUserData;
    if (data == null) {
      _profileSettingFABP.setOnPressedHandler = null;
      _profileSettingFABP.setShowFAB = false;
      return;
    }
    if (!mounted) return;
    await Provider.of<AuthProvider>(context, listen: false)
        .setIsVerified(data.isVerified);
    if (data is NGOModel) {
      _profileSettingFABP.setOnPressedHandler = null;
      _profileSettingFABP.setUserType = UserType.ngo;
      _profileSettingFABP.setShowFAB = false;
      return;
    }
    if (data is PeopleModel) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _profileSettingFABP.setOnPressedHandler = () => Navigator.pushNamed(
              context,
              PeopleProfileEditScreen.routeName,
            );
      });
      _profileSettingFABP.setUserType = UserType.people;
      _profileSettingFABP.setShowFAB = true;
    }
  }

  void profleEditfabListenScroll() {
    var direction = widget.scrollController.position.userScrollDirection;
    var a = _profileP.getUserData is PeopleModel;
    if (direction == ScrollDirection.reverse) {
      if (a) _profileSettingFABP.setShowFAB = false;
      _navigationBarP.setShowNB = false;
    } else {
      if (a) _profileSettingFABP.setShowFAB = true;
      _navigationBarP.setShowNB = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: _fetchUserFUTURE,
      builder: (context, snapshot) =>
          snapshot.connectionState == ConnectionState.waiting
              ? const ScreenLoading()
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
