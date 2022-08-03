import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sasae_flutter_app/models/people.dart';
import 'package:sasae_flutter_app/ui/misc/custom_image.dart';
import 'package:sasae_flutter_app/ui/misc/custom_image_tile.dart';
import 'package:sasae_flutter_app/ui/misc/custom_info_tile.dart';
import 'package:sasae_flutter_app/ui/misc/verified_chip.dart';
import 'package:url_launcher/url_launcher.dart';

class PeopleProfile extends StatelessWidget {
  final PeopleModel peopleData;

  const PeopleProfile({Key? key, required this.peopleData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(
          height: size.height * 0.1,
        ),
        CustomImage(
          width: size.width * 0.4,
          borderRadius: BorderRadius.circular(36.0),
          imageURL: peopleData.displayPicture,
          title: 'Display Picture',
        ),
        const SizedBox(
          height: 15,
        ),
        Text(
          peopleData.username,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        VerifiedChip(
          isVerified: peopleData.isVerified,
        ),
        SizedBox(
          height: size.height * 0.04,
        ),
        Card(
          color: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Column(
              children: [
                CustomInfoTile(
                  leadingIcon: Icons.person_rounded,
                  trailing: peopleData.fullname,
                ),
                Row(
                  children: [
                    Expanded(
                        flex: 4,
                        child: CustomInfoTile(
                          leadingIcon: Icons.transgender,
                          trailing: peopleData.gender,
                        )),
                    Expanded(
                      flex: 5,
                      child: CustomInfoTile(
                          leadingIcon: Icons.cake_rounded,
                          trailing:
                              DateFormat.yMMMd().format(peopleData.birthDate)),
                    ),
                  ],
                ),
                CustomInfoTile(
                  leadingIcon: Icons.location_pin,
                  trailing: peopleData.address,
                ),
                CustomInfoTile(
                  leadingIcon: Icons.phone_android_rounded,
                  trailing: peopleData.phone,
                  func: () => launchUrl(
                    Uri(
                      scheme: 'tel',
                      path: peopleData.phone,
                    ),
                  ).onError((error, stackTrace) => true),
                ),
                CustomInfoTile(
                  leadingIcon: Icons.email_rounded,
                  trailing: peopleData.email,
                  func: () => launchUrl(
                    Uri(
                      scheme: 'mailto',
                      path: peopleData.email,
                    ),
                  ).onError((error, stackTrace) => true),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: CustomInfoTile(
                        leadingIcon: Icons.person_add_rounded,
                        trailing:
                            DateFormat.yMMMd().format(peopleData.joinedDate),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: CustomInfoTile(
                        leadingIcon: Icons.post_add_rounded,
                        trailing: peopleData.postedPosts.length.toString(),
                      ),
                    ),
                  ],
                ),
                if (peopleData.citizenshipPhoto != null)
                  CustomImageTile(
                    title: 'Citizenship photo',
                    imageURL: peopleData.citizenshipPhoto!,
                  )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
