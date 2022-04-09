import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/fab_provider.dart';
import 'package:sasae_flutter_app/providers/profile_provider.dart';
import 'package:sasae_flutter_app/widgets/ngo/ngo_info_tab.dart';
import 'package:sasae_flutter_app/widgets/profile/info_post_tab.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_appbar.dart';
import 'package:sasae_flutter_app/widgets/ngo/ngo_donation_button.dart';
import 'package:sasae_flutter_app/widgets/profile/user_post_tab.dart';

class NGOProfileScreen extends StatefulWidget {
  static const String routeName = '/ngo/profile';
  final int ngoID;

  const NGOProfileScreen({Key? key, required this.ngoID}) : super(key: key);

  @override
  _NGOProfileScreenState createState() => _NGOProfileScreenState();
}

class _NGOProfileScreenState extends State<NGOProfileScreen> {
  final ScrollController _infoScrollController;
  final ScrollController _postScrollController;

  _NGOProfileScreenState()
      : _infoScrollController = ScrollController(),
        _postScrollController = ScrollController();
  @override
  void dispose() {
    _infoScrollController.dispose();
    _postScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'View NGO',
      ),
      body: InfoPostTab(
        infoTab: NGOInfoTab(
          ngoID: widget.ngoID,
          scrollController: _infoScrollController,
        ),
        postTab: UserPostTab(
          userID: widget.ngoID,
          userType: UserType.ngo,
          scrollController: _postScrollController,
        ),
        infoScrollController: _infoScrollController,
        postScrollController: _postScrollController,
        tabBarMargin: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
        fabType: FABType.donation,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Provider.of<DonationFABProvider>(context).getShowFAB
          ? NGODonationButton(
              scrollController: _infoScrollController,
            )
          : null,
    );
  }
}
