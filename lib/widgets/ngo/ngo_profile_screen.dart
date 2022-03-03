import 'dart:math';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_fab.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:randexp/randexp.dart';

import '../../models/bank.dart';
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
      : donationAmountField = TextEditingController(),
        paymentFormKey = GlobalKey<FormState>(),
        isLoaded = false,
        scrollController = ScrollController();

  NGO? _ngo;
  bool isLoaded;
  ScrollController scrollController;
  TextEditingController donationAmountField;
  GlobalKey<FormState> paymentFormKey;

  @override
  void initState() {
    super.initState();
    _getNGO();
  }

  @override
  void dispose() {
    donationAmountField.dispose();
    scrollController.dispose();
    super.dispose();
  }

  //Generates Nepal Phone Number
  String getRandPhoneNumber() => RandExp(RegExp(r'(^[9][678][0-9]{8}$)')).gen();

  NGO _randomUser() {
    var _isVerified = faker.randomGenerator.boolean();
    var ngoName = faker.company.name();
    return NGO(
      id: faker.randomGenerator.integer(1000),
      latitude: faker.randomGenerator.decimal(scale: (90 - (-90)), min: -90),
      longitude:
          faker.randomGenerator.decimal(scale: (180 - (-180)), min: -180),
      isVerified: _isVerified,
      orgPhoto: faker.image.image(width: 600, height: 600, random: true),
      orgName: ngoName,
      fieldOfWork: List.generate(
        Random().nextInt(8 - 1) + 1,
        (index) => faker.lorem.word(),
      ),
      estDate: faker.date.dateTime(maxYear: 2010, minYear: 1900),
      address: faker.address.streetAddress(),
      phone: getRandPhoneNumber(),
      email: faker.internet.email(),
      epayAccount: _isVerified ? getRandPhoneNumber() : null,
      bank: _isVerified
          ? Bank(
              bankName: faker.company.name(),
              bankBranch: faker.address.city(),
              bankBSB: int.parse(faker.randomGenerator.numberOfLength(6)),
              bankAccountName: ngoName,
              bankAccountNumber: int.parse(faker.randomGenerator
                  .numberOfLength(faker.randomGenerator.integer(16, min: 9))),
            )
          : null,
      panCertificateURL: _isVerified
          ? faker.image.image(width: 800, height: 600, random: true)
          : null,
      swcCertificateURL: _isVerified
          ? faker.image.image(width: 800, height: 600, random: true)
          : null,
    );
  }

  Future<void> _getNGO() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _ngo = _randomUser();
      isLoaded = true;
    });
  }

  Future<void> _refresh() async {
    await _getNGO();
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
              key: paymentFormKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: donationAmountField,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.money_rounded),
                      labelText: 'Amount',
                      // floatingLabelBehavior: FloatingLabelBehavior.never,
                    ),
                    validator: (value) {
                      return checkValue(
                        value: value!,
                        checkInt: true,
                      );
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
                        final isValid = paymentFormKey.currentState!.validate();
                        if (isValid) {
                          KhaltiScope.of(context)
                              .pay(
                            config: PaymentConfig(
                              amount: int.parse(donationAmountField.text) * 100,
                              productIdentity: 'dells-sssssg5-g5510-2021',
                              productName: 'NGO Donation: ${ngo.orgName}',
                              mobile: ngo.epayAccount,
                              mobileReadOnly: true,
                            ),
                            preferences: [
                              // Not providing this will enable all the payment methods.
                              PaymentPreference.khalti,
                              PaymentPreference.connectIPS,
                              PaymentPreference.mobileBanking,
                            ],
                            onSuccess: (su) {
                              showSnackBar(
                                context: context,
                                message: 'Payment Successful',
                              );
                            },
                            onFailure: (fa) {
                              showSnackBar(
                                context: context,
                                message: 'Payment Failed',
                              );
                            },
                            onCancel: () {
                              showSnackBar(
                                  context: context,
                                  message: 'Payment Cancelled');
                            },
                          )
                              .then((value) {
                            Navigator.of(context).pop();
                            donationAmountField.clear();
                          });
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

  Widget customTile(IconData? leadingIcon, String trailing,
          {String? leading, Function? func}) =>
      materialTile(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              leading == null
                  ? Icon(
                      leadingIcon,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    )
                  : Text(
                      leading,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  reverse: true,
                  child: Text(
                    trailing,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        func: func,
      );

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: getCustomAppBar(context: context, title: 'View NGO'),
      body: isLoaded
          ? RefreshIndicator(
              onRefresh: _refresh,
              child: SingleChildScrollView(
                controller: scrollController,
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
                                _ngo!.orgPhoto,
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
                          height: 20,
                        ),
                        Text(
                          _ngo!.orgName,
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
                          isVerified: _ngo!.isVerified,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: getWrappedChips(
                            context: context,
                            list: _ngo!.fieldOfWork,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.05,
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
                              DateFormat.yMMMd().format(_ngo!.estDate),
                            ),
                            customTile(
                              Icons.location_pin,
                              _ngo!.address,
                              func: () {
                                launchMap(
                                  title: _ngo!.orgName,
                                  lat: _ngo!.latitude,
                                  lon: _ngo!.longitude,
                                );
                              },
                            ),
                            customTile(
                              Icons.phone_android_rounded,
                              _ngo!.phone,
                              func: () => setState(() {
                                launch(Uri(
                                  scheme: 'tel',
                                  path: _ngo!.phone,
                                ).toString());
                              }),
                            ),
                            customTile(
                              Icons.email_rounded,
                              _ngo!.email,
                              func: () => setState(() {
                                launch(Uri(
                                  scheme: 'mailto',
                                  path: _ngo!.email,
                                ).toString());
                              }),
                            ),
                            if (_ngo!.isVerified)
                              customTile(
                                Icons.account_balance_wallet_rounded,
                                _ngo!.epayAccount!,
                              ),
                            if (_ngo!.isVerified)
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
                                            _ngo!.swcCertificateURL!,
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
                    if (_ngo!.isVerified)
                      Card(
                        color: Theme.of(context).colorScheme.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              ListTile(
                                leading: Icon(
                                  Icons.account_balance_rounded,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                title: Text(
                                  'Bank',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                trailing: TextButton.icon(
                                  onPressed: () {
                                    String text =
                                        'Bank Name:\t\t ${_ngo!.bank!.bankName}\nBank Branch:\t\t ${_ngo!.bank!.bankBranch}\nBank BSB:\t\t ${_ngo!.bank!.bankBSB}\nAccount Name:\t ${_ngo!.bank!.bankAccountName}\nAccount Number:\t ${_ngo!.bank!.bankAccountNumber}';
                                    copyToClipboard(
                                      ctx: context,
                                      text: text,
                                    );
                                  },
                                  icon: Icon(
                                    Icons.copy_rounded,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  label: Text(
                                    'Copy',
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ),
                              customTile(
                                Icons.ac_unit,
                                _ngo!.bank!.bankName,
                                leading: 'Name',
                              ),
                              customTile(
                                Icons.ac_unit,
                                _ngo!.bank!.bankBranch,
                                leading: 'Branch',
                              ),
                              customTile(
                                Icons.ac_unit,
                                _ngo!.bank!.bankBSB.toString(),
                                leading: 'BSB',
                              ),
                              customTile(
                                Icons.ac_unit,
                                _ngo!.bank!.bankAccountName,
                                leading: 'Account Name',
                              ),
                              customTile(
                                Icons.ac_unit,
                                _ngo!.bank!.bankAccountNumber.toString(),
                                leading: 'Account Number',
                              ),
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
            )
          : const LinearProgressIndicator(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: isLoaded && _ngo!.isVerified
          ? CustomFAB(
              text: 'Donate',
              icon: Icons.hail_rounded,
              background: Theme.of(context).colorScheme.primary,
              foreground: Theme.of(context).colorScheme.onPrimary,
              func: () => showDonationModalSheet(context, _ngo!),
              width: 130,
              scrollController: scrollController,
            )
          : null,
    );
  }
}
