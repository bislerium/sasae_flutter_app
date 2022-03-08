import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sasae_flutter_app/widgets/misc/fetch_error.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/ngo_provider.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_appbar.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_info_tile.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_material_tile.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_widgets.dart';
import 'package:sasae_flutter_app/widgets/misc/verified_chip.dart';
import 'package:sasae_flutter_app/widgets/ngo/ngo_donation_button.dart';

class NGOProfileScreen extends StatefulWidget {
  static const String routeName = '/ngo/profile';
  final int postID;

  const NGOProfileScreen({Key? key, required this.postID}) : super(key: key);

  @override
  _NGOProfileScreenState createState() => _NGOProfileScreenState();
}

class _NGOProfileScreenState extends State<NGOProfileScreen> {
  ScrollController scrollController;
  bool _isfetched;
  late NGOProvider _provider;

  _NGOProfileScreenState()
      : scrollController = ScrollController(),
        _isfetched = false;

  @override
  void dispose() {
    scrollController.dispose();
    _provider.nullifyNGO();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _provider = Provider.of<NGOProvider>(context, listen: false);
    _fetchNGO();
  }

  Future<void> _fetchNGO() async {
    await Provider.of<NGOProvider>(context, listen: false).fetchNGO(
      postID: widget.postID,
    );
    setState(() => _isfetched = true);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'View NGO',
      ),
      body: !_isfetched
          ? const LinearProgressIndicator()
          : Consumer<NGOProvider>(
              builder: (context, ngoP, child) => RefreshIndicator(
                onRefresh: () => ngoP.refreshNGO(widget.postID),
                child: ngoP.ngo == null
                    ? const FetchError()
                    : SingleChildScrollView(
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
                                        ngoP.ngo!.orgPhoto,
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
                                  ngoP.ngo!.orgName,
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
                                  isVerified: ngoP.ngo!.isVerified,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: getWrappedChips(
                                    context: context,
                                    list: ngoP.ngo!.fieldOfWork,
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
                                    CustomInfoTile(
                                      leadingIcon: Icons.calendar_today_rounded,
                                      trailing: DateFormat.yMMMd()
                                          .format(ngoP.ngo!.estDate),
                                    ),
                                    CustomInfoTile(
                                      leadingIcon: Icons.location_pin,
                                      trailing: ngoP.ngo!.address,
                                      func: () {
                                        launchMap(
                                          title: ngoP.ngo!.orgName,
                                          lat: ngoP.ngo!.latitude,
                                          lon: ngoP.ngo!.longitude,
                                        );
                                      },
                                    ),
                                    CustomInfoTile(
                                      leadingIcon: Icons.phone_android_rounded,
                                      trailing: ngoP.ngo!.phone,
                                      func: () => setState(() {
                                        launch(Uri(
                                          scheme: 'tel',
                                          path: ngoP.ngo!.phone,
                                        ).toString());
                                      }),
                                    ),
                                    CustomInfoTile(
                                      leadingIcon: Icons.email_rounded,
                                      trailing: ngoP.ngo!.email,
                                      func: () => setState(() {
                                        launch(Uri(
                                          scheme: 'mailto',
                                          path: ngoP.ngo!.email,
                                        ).toString());
                                      }),
                                    ),
                                    if (ngoP.ngo!.isVerified)
                                      CustomInfoTile(
                                        leadingIcon: Icons
                                            .account_balance_wallet_rounded,
                                        trailing: ngoP.ngo!.epayAccount!,
                                      ),
                                    if (ngoP.ngo!.isVerified)
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
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: AspectRatio(
                                                  aspectRatio: 6 / 4,
                                                  child: Image.network(
                                                    ngoP.ngo!
                                                        .swcCertificateURL!,
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
                            const SizedBox(
                              height: 10,
                            ),
                            if (ngoP.ngo!.isVerified)
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
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                        title: Text(
                                          'Bank',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        trailing: TextButton.icon(
                                          onPressed: () {
                                            String text =
                                                'Bank Name:\t\t ${ngoP.ngo!.bank!.bankName}\nBank Branch:\t\t ${ngoP.ngo!.bank!.bankBranch}\nBank BSB:\t\t ${ngoP.ngo!.bank!.bankBSB}\nAccount Name:\t ${ngoP.ngo!.bank!.bankAccountName}\nAccount Number:\t ${ngoP.ngo!.bank!.bankAccountNumber}';
                                            copyToClipboard(
                                              ctx: context,
                                              text: text,
                                            );
                                          },
                                          icon: Icon(
                                            Icons.copy_rounded,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                          label: Text(
                                            'Copy',
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                          ),
                                        ),
                                      ),
                                      CustomInfoTile(
                                        leading: 'Name',
                                        trailing: ngoP.ngo!.bank!.bankName,
                                      ),
                                      CustomInfoTile(
                                        leading: 'Branch',
                                        trailing: ngoP.ngo!.bank!.bankBranch,
                                      ),
                                      CustomInfoTile(
                                        leading: 'BSB',
                                        trailing:
                                            ngoP.ngo!.bank!.bankBSB.toString(),
                                      ),
                                      CustomInfoTile(
                                        leading: 'Account Name',
                                        trailing:
                                            ngoP.ngo!.bank!.bankAccountName,
                                      ),
                                      CustomInfoTile(
                                        leading: 'Account Number',
                                        trailing: ngoP
                                            .ngo!.bank!.bankAccountNumber
                                            .toString(),
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
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: NGODonationButton(
        scrollController: scrollController,
      ),
    );
  }
}
