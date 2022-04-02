import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/models/ngo.dart';
import 'package:sasae_flutter_app/models/people.dart';
import 'package:sasae_flutter_app/providers/fab_provider.dart';
import 'package:sasae_flutter_app/providers/profile_provider.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_loading.dart';
import 'package:sasae_flutter_app/widgets/misc/fetch_error.dart';
import 'package:sasae_flutter_app/widgets/profile/ngo_profile.dart';
import 'package:sasae_flutter_app/widgets/profile/people_profile.dart';
import 'package:sasae_flutter_app/widgets/profile/people_profile_edit_screen.dart';

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

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(profleCreatefabListenScroll);
    _fetchUserFUTURE = _fetchUser();
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(profleCreatefabListenScroll);
    super.dispose();
  }

  Future<void> _fetchUser() async {
    var pProvider = Provider.of<ProfileProvider>(context, listen: false);
    await pProvider.initFetchUser();
    var data = pProvider.userData;
    var psfProvider =
        Provider.of<ProfileSettingFABProvider>(context, listen: false);
    if (data is NGO) {
      psfProvider.setShowFAB = false;
    } else {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        if (data == null) {
          psfProvider.setOnPressedHandler = null;
          psfProvider.setShowFAB = false;
        } else {
          psfProvider.setOnPressedHandler = () => Navigator.pushNamed(
              context, PeopleProfileEditScreen.routeName,
              arguments: {'user': data as People});
        }
        psfProvider.setShowFAB = true;
      });
    }
  }

  void profleCreatefabListenScroll() {
    var _ = Provider.of<ProfileSettingFABProvider>(context, listen: false);
    var direction = widget.scrollController.position.userScrollDirection;
    direction == ScrollDirection.reverse
        ? _.setShowFAB = false
        : _.setShowFAB = true;
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
                    onRefresh: profileP.refreshUser,
                    child: profileP.userData == null
                        ? const FetchError()
                        : profileP.userData is People
                            ? PeopleProfile(
                                scrollController: widget.scrollController,
                                peopleData: profileP.userData! as People,
                              )
                            : NGOProfile(
                                scrollController: widget.scrollController,
                                ngoData: profileP.userData! as NGO,
                              ),
                  ),
                ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
