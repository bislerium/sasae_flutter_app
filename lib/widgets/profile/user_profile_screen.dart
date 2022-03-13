import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/models/ngo.dart';
import 'package:sasae_flutter_app/models/people.dart';
import 'package:sasae_flutter_app/providers/profile_provider.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_fab.dart';
import 'package:sasae_flutter_app/widgets/misc/fetch_error.dart';
import 'package:sasae_flutter_app/widgets/profile/ngo_profile.dart';
import 'package:sasae_flutter_app/widgets/profile/people_profile.dart';
import 'package:sasae_flutter_app/widgets/profile/people_profile_edit_screen.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile>
    with AutomaticKeepAliveClientMixin {
  ScrollController scrollController;

  _UserProfileState() : scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: FutureBuilder(
        future: Provider.of<ProfileProvider>(context, listen: false)
            .initFetchUser(),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.end,
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
                                  scrollController: scrollController,
                                  peopleData: profileP.userData! as People,
                                )
                              : NGOProfile(
                                  scrollController: scrollController,
                                  ngoData: profileP.userData! as NGO,
                                ),
                    ),
                  ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Consumer<ProfileProvider>(
        builder: (context, profileP, child) =>
            profileP.userData == null || profileP.userData is NGO
                ? const SizedBox.shrink()
                : CustomFAB(
                    width: 150,
                    text: 'Edit profile',
                    background: Theme.of(context).colorScheme.primary,
                    icon: Icons.edit,
                    func: () {
                      Navigator.pushNamed(
                          context, PeopleProfileEditScreen.routeName,
                          arguments: {'user': profileP.userData as People});
                    },
                    foreground: Theme.of(context).colorScheme.onPrimary,
                    scrollController: scrollController,
                  ),
      ),
    );
  }

  @override
  // ignore: todo
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
