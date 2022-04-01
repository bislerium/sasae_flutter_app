import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/models/ngo.dart';
import 'package:sasae_flutter_app/models/people.dart';
import 'package:sasae_flutter_app/providers/fab_provider.dart';
import 'package:sasae_flutter_app/providers/profile_provider.dart';
import 'package:sasae_flutter_app/widgets/misc/fetch_error.dart';
import 'package:sasae_flutter_app/widgets/profile/ngo_profile.dart';
import 'package:sasae_flutter_app/widgets/profile/people_profile.dart';
import 'package:sasae_flutter_app/widgets/profile/profile_edit_fab.dart';

class UserInfoTab extends StatefulWidget {
  const UserInfoTab({Key? key}) : super(key: key);

  @override
  State<UserInfoTab> createState() => _UserInfoTabState();
}

class _UserInfoTabState extends State<UserInfoTab>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController;
  late final Future<void> _fetchUserFUTURE;

  _UserInfoTabState() : _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchUserFUTURE = _fetchUser();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchUser() async {
    var _ = Provider.of<ProfileProvider>(context, listen: false);
    await _.initFetchUser();
    var data = _.userData;
    if (data == null) {
      Provider.of<FABProvider>(context, listen: false).setFABActionHandler =
          null;
    } else {
      Provider.of<FABProvider>(context, listen: false).setFABActionHandler =
          ProfileEditFAB(
        user: data,
        scrollController: _scrollController,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: _fetchUserFUTURE,
      builder: (context, snapshot) =>
          snapshot.connectionState == ConnectionState.waiting
              ? ListView(
                  // mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    LinearProgressIndicator(),
                  ],
                )
              : Consumer<ProfileProvider>(
                  builder: (context, profileP, child) => RefreshIndicator(
                    onRefresh: profileP.refreshUser,
                    child: profileP.userData == null
                        ? const FetchError()
                        : profileP.userData is People
                            ? PeopleProfile(
                                scrollController: _scrollController,
                                peopleData: profileP.userData! as People,
                              )
                            : NGOProfile(
                                scrollController: _scrollController,
                                ngoData: profileP.userData! as NGO,
                              ),
                  ),
                ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
