import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sasae_flutter_app/models/ngo.dart';
import 'package:sasae_flutter_app/services/utilities.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_image.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_image_tile.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_info_tile.dart';
import 'package:sasae_flutter_app/widgets/misc/verified_chip.dart';
import 'package:sasae_flutter_app/widgets/misc/wrapped_chips.dart';
import 'package:url_launcher/url_launcher.dart';

class NGOProfile extends StatelessWidget {
  final NGOModel ngoData;

  const NGOProfile({
    Key? key,
    required this.ngoData,
  }) : super(key: key);

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
          imageURL: ngoData.displayPicture,
          title: 'Display Picture',
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          ngoData.orgName,
          textAlign: TextAlign.center,
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
          isVerified: ngoData.isVerified,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: WrappedChips(
            key: ValueKey(ngoData.fieldOfWork.hashCode),
            list: ngoData.fieldOfWork,
          ),
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
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Column(
              children: [
                CustomInfoTile(
                  leadingIcon: Icons.calendar_today_rounded,
                  trailing: DateFormat.yMMMd().format(ngoData.estDate),
                ),
                CustomInfoTile(
                  leadingIcon: Icons.location_pin,
                  trailing: ngoData.address,
                  func: () {
                    launchMap(
                      title: ngoData.orgName,
                      lat: ngoData.latitude,
                      lon: ngoData.longitude,
                    );
                  },
                ),
                CustomInfoTile(
                  leadingIcon: Icons.phone_android_rounded,
                  trailing: ngoData.phone,
                  func: () => launchUrl(
                    Uri(
                      scheme: 'tel',
                      path: ngoData.phone,
                    ),
                  ),
                ),
                CustomInfoTile(
                    leadingIcon: Icons.email_rounded,
                    trailing: ngoData.email,
                    func: () => launchUrl(
                          Uri(
                            scheme: 'mailto',
                            path: ngoData.email,
                          ),
                        )),
                if (ngoData.isVerified && ngoData.epayAccount != null)
                  CustomInfoTile(
                    leadingIcon: Icons.account_balance_wallet_rounded,
                    trailing: ngoData.epayAccount!,
                  ),
                CustomInfoTile(
                  leadingIcon: Icons.post_add_rounded,
                  trailing: ngoData.postedPosts.length.toString(),
                ),
                if (ngoData.isVerified &&
                    ngoData.swcCertificateURL != null &&
                    ngoData.panCertificateURL != null) ...[
                  CustomImageTile(
                    title: 'Social Welfare Council Affilation',
                    imageURL: ngoData.swcCertificateURL!,
                  ),
                  CustomImageTile(
                    title: 'PAN Certificate',
                    imageURL: ngoData.panCertificateURL!,
                  ),
                ]
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        if (ngoData.isVerified && ngoData.bank != null)
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
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: TextButton.icon(
                      onPressed: () {
                        String text =
                            'Bank Name:\t\t ${ngoData.bank!.bankName}\nBank Branch:\t\t ${ngoData.bank!.bankBranch}\nBank BSB:\t\t ${ngoData.bank!.bankBSB}\nAccount Name:\t ${ngoData.bank!.bankAccountName}\nAccount Number:\t ${ngoData.bank!.bankAccountNumber}';
                        copyToClipboard(
                          ctx: context,
                          text: text,
                        );
                      },
                      icon: Icon(
                        Icons.copy_rounded,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      label: Text(
                        'Copy',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  CustomInfoTile(
                    leading: 'Name',
                    trailing: ngoData.bank!.bankName,
                  ),
                  CustomInfoTile(
                    leading: 'Branch',
                    trailing: ngoData.bank!.bankBranch,
                  ),
                  CustomInfoTile(
                    leading: 'BSB',
                    trailing: ngoData.bank!.bankBSB,
                  ),
                  CustomInfoTile(
                    leading: 'Account Name',
                    trailing: ngoData.bank!.bankAccountName,
                  ),
                  CustomInfoTile(
                    leading: 'Account Number',
                    trailing: ngoData.bank!.bankAccountNumber,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
