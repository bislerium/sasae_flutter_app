import 'package:faker/faker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/user.dart';
import '../misc/verified_chip.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile>
    with AutomaticKeepAliveClientMixin {
  User? user;
  // bool _hasCallSupport = false;

  @override
  void initState() {
    super.initState();
    _getUser();
    // canLaunch('tel:123').then((bool result) {
    //   setState(() {
    //     _hasCallSupport = result;
    //   });
    // });
  }

  Future<void> _refresh() async {
    // await Future.delayed(Duration(seconds: 2));
    setState(() {
      _getUser();
    });
  }

  var gender = ['Male', 'Female', 'LGBTQ+'];

  void _getUser() {
    var isVerified = faker.randomGenerator.boolean();
    user = User(
      id: faker.randomGenerator.integer(1000),
      isVerified: isVerified,
      displayPicture: faker.image.image(width: 600, height: 600, random: true),
      numOfPosts: faker.randomGenerator.integer(1000),
      userName: faker.person.firstName(),
      fullName: faker.person.name(),
      gender: faker.randomGenerator.element(gender),
      birthDate: faker.date.dateTime(maxYear: 2010, minYear: 1900),
      address: faker.address.streetAddress(),
      phoneNumber: faker.phoneNumber.us(),
      email: faker.internet.email(),
      joinedDate: faker.date.dateTime(maxYear: 2010, minYear: 1900),
      citizenshipPhoto: isVerified
          ? faker.image.image(width: 800, height: 600, random: true)
          : null,
    );
  }

  Widget materialTile({required Widget child, Function? func}) => Container(
        margin: const EdgeInsets.all(5),
        child: Material(
          elevation: 1,
          color: Theme.of(context).colorScheme.surfaceVariant,
          shadowColor: Theme.of(context).colorScheme.shadow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            splashColor: Theme.of(context).colorScheme.inversePrimary,
            onTap: () {
              if (func != null) {
                func();
              }
            },
            child: child,
          ),
        ),
      );

  Widget customTile(IconData icon, String title, {Function? func}) =>
      materialTile(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        func: func,
      );

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          child: Column(
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
                          user!.displayPicture,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) =>
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
                    user!.userName,
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
                    isVerified: user!.isVerified,
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.04,
              ),
              Card(
                color: Theme.of(context).colorScheme.surface,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: Column(
                    children: [
                      customTile(
                        Icons.person_rounded,
                        user!.fullName,
                      ),
                      Row(
                        children: [
                          Expanded(
                              flex: 3,
                              child:
                                  customTile(Icons.transgender, user!.gender)),
                          Expanded(
                            flex: 5,
                            child: customTile(Icons.cake_rounded,
                                DateFormat.yMMMd().format(user!.birthDate)),
                          ),
                        ],
                      ),
                      customTile(
                        Icons.location_pin,
                        user!.address,
                      ),
                      customTile(
                        Icons.phone_android_rounded,
                        user!.phoneNumber,
                        func: () => setState(() {
                          launch(Uri(
                            scheme: 'tel',
                            path: user!.phoneNumber,
                          ).toString());
                        }),
                      ),
                      customTile(
                        Icons.email_rounded,
                        user!.email,
                        func: () => setState(() {
                          launch(Uri(
                            scheme: 'mailto',
                            path: user!.email,
                          ).toString());
                        }),
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: customTile(
                              Icons.person_add_rounded,
                              DateFormat.yMMMd().format(user!.joinedDate),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: customTile(
                              Icons.post_add_rounded,
                              user!.numOfPosts.toString(),
                            ),
                          ),
                        ],
                      ),
                      if (user!.citizenshipPhoto != null)
                        materialTile(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 10, 20),
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
                                  borderRadius: BorderRadius.circular(10),
                                  child: AspectRatio(
                                    aspectRatio: 6 / 4,
                                    child: Image.network(
                                      user!.citizenshipPhoto!,
                                      fit: BoxFit.cover,
                                      loadingBuilder: (context, child,
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
    );
  }

  @override
  // ignore: todo
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
