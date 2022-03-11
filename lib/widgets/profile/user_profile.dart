import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/profile_provider.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_fab.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_info_tile.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_material_tile.dart';
import 'package:sasae_flutter_app/widgets/misc/fetch_error.dart';
import 'package:sasae_flutter_app/widgets/profile/user_profile_edit_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../misc/verified_chip.dart';

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
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: FutureBuilder(
        future:
            Provider.of<ProfileProvider>(context, listen: false).fetchUser(),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
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
                      : ListView(
                          controller: scrollController,
                          children: [
                            SizedBox(
                              height: size.height * 0.1,
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  width: size.width * 0.4,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(40),
                                    child: AspectRatio(
                                      aspectRatio: 1 / 1,
                                      child: Image.network(
                                        profileP.userData!.displayPicture,
                                        fit: BoxFit.cover,
                                        loadingBuilder: (context, child,
                                                loadingProgress) =>
                                            loadingProgress == null
                                                ? child
                                                : const LinearProgressIndicator(),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  profileP.userData!.userName,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondaryContainer,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                VerifiedChip(
                                  isVerified: profileP.userData!.isVerified,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: size.height * 0.04,
                            ),
                            Card(
                              color: Theme.of(context).colorScheme.surface,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 15),
                                child: Column(
                                  children: [
                                    CustomInfoTile(
                                      leadingIcon: Icons.person_rounded,
                                      trailing: profileP.userData!.fullName,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                            flex: 3,
                                            child: CustomInfoTile(
                                              leadingIcon: Icons.transgender,
                                              trailing:
                                                  profileP.userData!.gender,
                                            )),
                                        Expanded(
                                          flex: 5,
                                          child: CustomInfoTile(
                                              leadingIcon: Icons.cake_rounded,
                                              trailing: DateFormat.yMMMd()
                                                  .format(profileP
                                                      .userData!.birthDate)),
                                        ),
                                      ],
                                    ),
                                    CustomInfoTile(
                                      leadingIcon: Icons.location_pin,
                                      trailing: profileP.userData!.address,
                                    ),
                                    CustomInfoTile(
                                      leadingIcon: Icons.phone_android_rounded,
                                      trailing: profileP.userData!.phoneNumber,
                                      func: () => setState(() {
                                        launch(Uri(
                                          scheme: 'tel',
                                          path: profileP.userData!.phoneNumber,
                                        ).toString());
                                      }),
                                    ),
                                    CustomInfoTile(
                                      leadingIcon: Icons.email_rounded,
                                      trailing: profileP.userData!.email,
                                      func: () => setState(() {
                                        launch(Uri(
                                          scheme: 'mailto',
                                          path: profileP.userData!.email,
                                        ).toString());
                                      }),
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 5,
                                          child: CustomInfoTile(
                                            leadingIcon:
                                                Icons.person_add_rounded,
                                            trailing: DateFormat.yMMMd().format(
                                                profileP.userData!.joinedDate),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: CustomInfoTile(
                                            leadingIcon: Icons.post_add_rounded,
                                            trailing: profileP
                                                .userData!.postedPosts.length
                                                .toString(),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (profileP.userData!.citizenshipPhoto !=
                                        null)
                                      CustomMaterialTile(
                                        child: Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        10, 0, 10, 20),
                                                child: Text(
                                                  'Citizenship photo',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSurfaceVariant,
                                                  ),
                                                ),
                                              ),
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: AspectRatio(
                                                  aspectRatio: 6 / 4,
                                                  child: Image.network(
                                                    profileP.userData!
                                                        .citizenshipPhoto!,
                                                    fit: BoxFit.cover,
                                                    loadingBuilder: (context,
                                                            child,
                                                            loadingProgress) =>
                                                        loadingProgress == null
                                                            ? child
                                                            : const LinearProgressIndicator(),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Consumer<ProfileProvider>(
        builder: (context, profileP, child) => profileP.userData == null
            ? const SizedBox.shrink()
            : CustomFAB(
                width: 150,
                text: 'Edit profile',
                background: Theme.of(context).colorScheme.primary,
                icon: Icons.edit,
                func: () {
                  Navigator.pushNamed(context, UserProfileEditScreen.routeName,
                      arguments: {'user': profileP.userData});
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
