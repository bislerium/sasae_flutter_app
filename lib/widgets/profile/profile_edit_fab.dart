import 'package:flutter/material.dart';
import 'package:sasae_flutter_app/models/people.dart';
import 'package:sasae_flutter_app/models/user.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_fab.dart';
import 'package:sasae_flutter_app/widgets/profile/people_profile_edit_screen.dart';

class ProfileEditFAB extends StatelessWidget {
  final ScrollController scrollController;
  final User user;
  const ProfileEditFAB(
      {Key? key, required this.user, required this.scrollController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomFAB(
      text: 'Edit profile',
      background: Theme.of(context).colorScheme.primary,
      icon: Icons.edit,
      func: () {
        Navigator.pushNamed(context, PeopleProfileEditScreen.routeName,
            arguments: {'user': user as People});
      },
      foreground: Theme.of(context).colorScheme.onPrimary,
      scrollController: scrollController,
    );
  }
}
