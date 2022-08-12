import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:sasae_flutter_app/models/ngo.dart';
import 'package:sasae_flutter_app/services/utilities.dart';
import 'package:sasae_flutter_app/ui/geolocation/map_screen.dart';
import 'package:sasae_flutter_app/ui/misc/custom_image.dart';
import 'package:sasae_flutter_app/ui/misc/custom_image_tile.dart';
import 'package:sasae_flutter_app/ui/misc/custom_info_tile.dart';
import 'package:sasae_flutter_app/ui/misc/custom_material_tile.dart';
import 'package:sasae_flutter_app/ui/misc/splash_over.dart';
import 'package:sasae_flutter_app/ui/misc/verified_chip.dart';
import 'package:sasae_flutter_app/ui/misc/wrapped_chips.dart';
import 'package:url_launcher/url_launcher.dart';

class NGOProfile extends StatelessWidget {
  final NGOModel ngoData;
  final bool isOwnProfile;

  const NGOProfile({
    Key? key,
    required this.ngoData,
    this.isOwnProfile = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var isDocumentViewable = isOwnProfile || ngoData.isVerified;
    return Column(
      children: [
        SizedBox(
          height: size.height * 0.1,
        ),
        CustomImage(
          width: size.width * 0.4,
          imageURL: ngoData.displayPicture,
          title: 'Display Picture',
          borderRadius: BorderRadius.circular(36.0),
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
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
            child: Column(
              children: [
                CustomInfoTile(
                  leadingIcon: Icons.today_rounded,
                  trailing: DateFormat.yMMMd().format(ngoData.estDate),
                ),
                CustomMapInfoTile(
                  orgName: ngoData.orgName,
                  address: ngoData.address,
                  latitude: ngoData.latitude,
                  longitude: ngoData.longitude,
                ),
                CustomInfoTile(
                  leadingIcon: Icons.phone_android_rounded,
                  trailing: ngoData.phone,
                  func: () => launchUrl(
                    Uri(
                      scheme: 'tel',
                      path: ngoData.phone,
                    ),
                  ).onError((error, stackTrace) => true),
                ),
                CustomInfoTile(
                  leadingIcon: Icons.email_rounded,
                  trailing: ngoData.email,
                  func: () => launchUrl(
                    Uri(
                      scheme: 'mailto',
                      path: ngoData.email,
                    ),
                  ).onError((error, stackTrace) => true),
                ),
                if (ngoData.isVerified && ngoData.epayAccount != null)
                  CustomInfoTile(
                    leadingIcon: Icons.account_balance_wallet_rounded,
                    trailing: ngoData.epayAccount!,
                  ),
                CustomInfoTile(
                  leadingIcon: Icons.post_add_rounded,
                  trailing: ngoData.postedPosts.length.toString(),
                ),
                if (isDocumentViewable && ngoData.swcCertificateURL != null)
                  CustomImageTile(
                    title: 'Social Welfare Council Affiliation',
                    imageURL: ngoData.swcCertificateURL!,
                    isImageVerified: ngoData.isVerified,
                  ),
                if (isDocumentViewable && ngoData.panCertificateURL != null)
                  CustomImageTile(
                    title: 'PAN Certificate',
                    imageURL: ngoData.panCertificateURL!,
                    isImageVerified: ngoData.isVerified,
                  ),
              ],
            ),
          ),
        ),
        if (ngoData.isVerified && ngoData.bank != null) ...[
          const SizedBox(
            height: 10,
          ),
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
      ],
    );
  }
}

class CustomMapInfoTile extends StatelessWidget {
  final String address;
  final String orgName;
  final double latitude;
  final double longitude;
  const CustomMapInfoTile(
      {Key? key,
      required this.address,
      required this.orgName,
      required this.latitude,
      required this.longitude})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final location = LatLng(latitude, longitude);
    final mapSize = MediaQuery.of(context).size.width - 20;
    return CustomMaterialTile(
      borderRadius: 12,
      child: Wrap(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.location_pin,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    child: Text(
                      address,
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
          SplashOver(
            onTap: () => Navigator.of(context).pushNamed(
              MapScreen.routeName,
              arguments: {
                'lat': latitude,
                'lng': longitude,
                'title': orgName,
              },
            ),
            borderRadius:
                const BorderRadius.vertical(bottom: Radius.circular(12)),
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(12)),
              child: SizedBox(
                width: mapSize,
                height: mapSize,
                child: FlutterMap(
                  key: ValueKey(location.hashCode),
                  options: MapOptions(
                    center: location,
                    zoom: 14,
                    maxZoom: 18.4,
                    interactiveFlags: InteractiveFlag.none,
                  ),
                  layers: [
                    TileLayerOptions(
                      urlTemplate:
                          "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                      userAgentPackageName: 'com.bishalgc.sasae.app',
                      tileProvider: NetworkTileProvider(),
                      backgroundColor: Theme.of(context).colorScheme.background,
                      tilesContainerBuilder:
                          Theme.of(context).brightness == Brightness.dark
                              ? darkModeTilesContainerBuilder
                              : null,
                    ),
                    MarkerLayerOptions(
                      markers: [
                        Marker(
                          rotate: true,
                          point: location,
                          builder: (context) => Icon(
                            Icons.location_pin,
                            size: 40,
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
