import 'package:flutter/material.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_loading.dart';
import 'package:sasae_flutter_app/widgets/misc/fetch_error.dart';
import 'package:sasae_flutter_app/widgets/profile/ngo_profile.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/ngo_provider.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_appbar.dart';
import 'package:sasae_flutter_app/widgets/ngo/ngo_donation_button.dart';

class NGOProfileScreen extends StatefulWidget {
  static const String routeName = '/ngo/profile';
  final int ngoID;

  const NGOProfileScreen({Key? key, required this.ngoID}) : super(key: key);

  @override
  _NGOProfileScreenState createState() => _NGOProfileScreenState();
}

class _NGOProfileScreenState extends State<NGOProfileScreen> {
  ScrollController scrollController;
  bool _isFetched;
  late NGOProvider _provider;

  _NGOProfileScreenState()
      : scrollController = ScrollController(),
        _isFetched = false;

  @override
  void initState() {
    super.initState();
    _provider = Provider.of<NGOProvider>(context, listen: false);
    _fetchNGO();
  }

  @override
  void dispose() {
    scrollController.dispose();
    _provider.nullifyNGO();
    super.dispose();
  }

  Future<void> _fetchNGO() async {
    await _provider.initFetchNGO(
      ngoID: widget.ngoID,
    );
    setState(() => _isFetched = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'View NGO',
      ),
      body: _isFetched
          ? Consumer<NGOProvider>(
              builder: (context, ngoP, child) => RefreshIndicator(
                onRefresh: () => ngoP.refreshNGO(ngoID: widget.ngoID),
                child: ngoP.ngoData == null
                    ? const FetchError()
                    : NGOProfile(
                        scrollController: scrollController,
                        ngoData: ngoP.ngoData!,
                      ),
              ),
            )
          : const CustomLoading(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: NGODonationButton(
        scrollController: scrollController,
      ),
    );
  }
}
