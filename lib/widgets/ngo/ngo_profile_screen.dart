import 'dart:math';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sasae_flutter_app/models/bank.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/ngo.dart';
import '../misc/verified_chip.dart';

class NGOProfileScreen extends StatefulWidget {
  // static const String routeName = '/ngo';
  final String hyperlink;

  const NGOProfileScreen({Key? key, required this.hyperlink}) : super(key: key);

  @override
  _NGOProfileScreenState createState() => _NGOProfileScreenState();
}

class _NGOProfileScreenState extends State<NGOProfileScreen> {
  NGO? ngo;
  // bool _hasCallSupport = false;

  @override
  void initState() {
    super.initState();
    _getNGO();
  }

  void _randomUser() {
    var verified = faker.randomGenerator.boolean();
    var ngoName = faker.company.name();
    ngo = NGO(
      id: faker.randomGenerator.integer(1000),
      latitude: faker.randomGenerator.decimal(scale: (90 - (-90)), min: -90),
      longitude:
          faker.randomGenerator.decimal(scale: (180 - (-180)), min: -180),
      isVerified: verified,
      orgPhoto: faker.image.image(width: 600, height: 600, random: true),
      orgName: ngoName,
      fieldOfWork: List.generate(
        Random().nextInt(8 - 1) + 1,
        (index) => faker.lorem.word(),
      ),
      estDate: faker.date.dateTime(maxYear: 2010, minYear: 1900),
      address: faker.address.streetAddress(),
      phone: faker.phoneNumber.us(),
      email: faker.internet.email(),
      epayAccount: faker.phoneNumber.us(),
      bank: faker.randomGenerator.boolean()
          ? Bank(
              bankName: faker.company.name(),
              bankBranch: faker.address.city(),
              bankBSB: faker.randomGenerator.integer(6, min: 6),
              bankAccountName: ngoName,
              bankAccountNumber: faker.randomGenerator.integer(17, min: 6))
          : null,
      panCertificateURL: verified
          ? faker.image.image(width: 800, height: 600, random: true)
          : null,
      swcCertificateURL: verified
          ? faker.image.image(width: 800, height: 600, random: true)
          : null,
    );
  }

  Future<void> _getNGO() async {
    await Future.delayed(const Duration(seconds: 3));
    _randomUser();
  }

  Future<void> _refresh() async {
    setState(() {
      _getNGO();
    });
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
    // super.build(context);
    var size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.08,
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
                          ngo!.orgPhoto,
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
                    ngo!.orgName,
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
                    isVerified: ngo!.isVerified,
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
                      customTile(Icons.calendar_today_rounded,
                          DateFormat.yMMMd().format(ngo!.estDate)),
                      customTile(
                        Icons.location_pin,
                        ngo!.address,
                      ),
                      customTile(
                        Icons.phone_android_rounded,
                        ngo!.phone,
                        func: () => setState(() {
                          launch(Uri(
                            scheme: 'tel',
                            path: ngo!.phone,
                          ).toString());
                        }),
                      ),
                      customTile(
                        Icons.email_rounded,
                        ngo!.email,
                        func: () => setState(() {
                          launch(Uri(
                            scheme: 'mailto',
                            path: ngo!.email,
                          ).toString());
                        }),
                      ),
                      if (ngo!.isVerified)
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
                                    ' Social Welfare Council Affilation',
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
                                      ngo!.swcCertificateURL!,
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

  // @override
  // // ignore: todo
  // // TODO: implement wantKeepAlive
  // bool get wantKeepAlive => true;
}
