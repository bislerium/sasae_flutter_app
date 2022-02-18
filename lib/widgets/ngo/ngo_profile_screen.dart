import 'dart:math';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sasae_flutter_app/models/bank.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/ngo.dart';
import '../misc/custom_widgets.dart';
import '../misc/verified_chip.dart';

class NGOProfileScreen extends StatefulWidget {
  // static const String routeName = '/ngo';
  final String hyperlink;

  const NGOProfileScreen({Key? key, required this.hyperlink}) : super(key: key);

  @override
  _NGOProfileScreenState createState() => _NGOProfileScreenState();
}

class _NGOProfileScreenState extends State<NGOProfileScreen> {
  _NGOProfileScreenState()
      : isloaded = false,
        paymentField = TextEditingController(),
        passwordResetFormKey = GlobalKey<FormState>();

  Future<NGO>? _ngo;
  bool isloaded;
  TextEditingController paymentField;
  GlobalKey<FormState> passwordResetFormKey;

  @override
  void initState() {
    super.initState();
    _ngo = _getNGO();
  }

  @override
  void dispose() {
    paymentField.dispose();
    super.dispose();
  }

  NGO _randomUser() {
    var verified = faker.randomGenerator.boolean();
    var ngoName = faker.company.name();
    return NGO(
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

  Future<NGO> _getNGO() async {
    await Future.delayed(const Duration(seconds: 2));
    return _randomUser();
  }

  Future<void> _refresh() async {
    var ngo = await _getNGO();
    setState(() {
      _ngo = Future.value(ngo);
    });
  }

  void showDonationModalSheet(BuildContext context, NGO ngo) => showModalSheet(
        ctx: context,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'NGO Donation',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(right: 10, left: 10, top: 12, bottom: 5),
            child: RichText(
              textAlign: TextAlign.justify,
              text: TextSpan(
                  text:
                      'Making a donation is the ultimate sign of solidarity. Actions speak louder than words.',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 15,
                  ),
                  children: [
                    TextSpan(
                      text: '\n- Ibrahim Hooper',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        height: 1.6,
                      ),
                    )
                  ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Form(
              key: passwordResetFormKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: paymentField,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.money_rounded),
                      labelText: 'Amount',
                      // floatingLabelBehavior: FloatingLabelBehavior.never,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter donation amount!';
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints.tightFor(
                        height: 60, width: double.infinity),
                    child: ElevatedButton(
                      child: const Text(
                        'Donate with Khalti',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      onPressed: () {
                        final isValid =
                            passwordResetFormKey.currentState!.validate();

                        if (isValid) {
                          Navigator.of(context).pop();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      );

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

  Widget getFieldOfWorkChips(List<String> fieldOfWork) => Padding(
        padding: const EdgeInsets.all(10.0),
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: -5,
          children: fieldOfWork
              .map(
                (e) => Chip(
                  label: Text(
                    e,
                    style: TextStyle(
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer),
                  ),
                  backgroundColor:
                      Theme.of(context).colorScheme.secondaryContainer,
                ),
              )
              .toList(),
        ),
      );

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: getCustomAppBar(context: context, title: 'View NGO'),
      body: FutureBuilder<NGO>(
        future: _ngo, // a previously-obtained Future<void> or null
        builder: (BuildContext context, AsyncSnapshot<NGO> snapshot) {
          Widget? widget;
          if (snapshot.hasData) {
            NGO ngo = snapshot.data!;
            isloaded = true;
            widget = RefreshIndicator(
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
                                ngo.orgPhoto,
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
                          ngo.orgName,
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
                          isVerified: ngo.isVerified,
                        ),
                        getFieldOfWorkChips(ngo.fieldOfWork),
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.06,
                    ),
                    Card(
                      color: Theme.of(context).colorScheme.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 15),
                        child: Column(
                          children: [
                            customTile(
                              Icons.calendar_today_rounded,
                              DateFormat.yMMMd().format(ngo.estDate),
                            ),
                            customTile(
                              Icons.location_pin,
                              ngo.address,
                              func: () {
                                launchMap(
                                  title: ngo.orgName,
                                  lat: ngo.latitude,
                                  lon: ngo.longitude,
                                );
                              },
                            ),
                            customTile(
                              Icons.phone_android_rounded,
                              ngo.phone,
                              func: () => setState(() {
                                launch(Uri(
                                  scheme: 'tel',
                                  path: ngo.phone,
                                ).toString());
                              }),
                            ),
                            customTile(
                              Icons.email_rounded,
                              ngo.email,
                              func: () => setState(() {
                                launch(Uri(
                                  scheme: 'mailto',
                                  path: ngo.email,
                                ).toString());
                              }),
                            ),
                            if (ngo.isVerified)
                              materialTile(
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 0, 10, 20),
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
                                            ngo.swcCertificateURL!,
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
                    const SizedBox(
                      height: 10,
                    ),
                    if (ngo.bank != null)
                      Card(
                        color: Theme.of(context).colorScheme.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              customTile(
                                Icons.ac_unit,
                                ngo.bank!.bankName,
                              ),
                              customTile(Icons.ac_unit, ngo.bank!.bankBranch),
                              customTile(
                                  Icons.ac_unit, ngo.bank!.bankBSB.toString()),
                              customTile(
                                  Icons.ac_unit, ngo.bank!.bankAccountName),
                              customTile(Icons.ac_unit,
                                  ngo.bank!.bankAccountNumber.toString()),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            Navigator.of(context).pop();
            showSnackBar(
                context: context, message: 'Network connection error!');
          } else {
            widget = const LinearProgressIndicator();
          }
          return widget!;
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: isloaded
          ? getCustomFAB(
              text: 'Donate',
              icon: Icons.hail_rounded,
              background: Theme.of(context).colorScheme.primary,
              foreground: Theme.of(context).colorScheme.onPrimary,
              func: () => showDonationModalSheet(context, _randomUser()),
            )
          : null,
    );
  }

  // @override
  // // ignore: todo
  // // TODO: implement wantKeepAlive
  // bool get wantKeepAlive => true;
}
