import 'package:flutter/material.dart';
import 'package:sasae_flutter_app/providers/fab_provider.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_loading.dart';
import 'package:sasae_flutter_app/widgets/misc/fetch_error.dart';
import 'package:sasae_flutter_app/widgets/profile/ngo_profile.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/ngo_provider.dart';

class NGOInfoTab extends StatefulWidget {
  final int ngoID;
  final ScrollController scrollController;

  const NGOInfoTab(
      {Key? key, required this.ngoID, required this.scrollController})
      : super(key: key);

  @override
  _NGOInfoTabState createState() => _NGOInfoTabState();
}

class _NGOInfoTabState extends State<NGOInfoTab>
    with AutomaticKeepAliveClientMixin {
  late final NGOProvider _ngoP;
  late final DonationFABProvider _donationFABP;
  late final Future<void> _fetchNGOFUTURE;

  @override
  void initState() {
    super.initState();
    _fetchNGOFUTURE = _fetchNGO();
  }

  @override
  void dispose() {
    _ngoP.nullifyNGO();
    _donationFABP.resetFAB();
    super.dispose();
  }

  Future<void> _fetchNGO() async {
    _ngoP = Provider.of<NGOProvider>(context, listen: false);
    await _ngoP.initFetchNGO(
      ngoID: widget.ngoID,
    );
    var data = _ngoP.getNGO;
    if (data != null) {
      _donationFABP = Provider.of<DonationFABProvider>(context, listen: false);
      _donationFABP.setNGOVerified = data.isVerified;
      _donationFABP.setShowFAB = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: _fetchNGOFUTURE,
      builder: (context, snapshot) =>
          snapshot.connectionState == ConnectionState.waiting
              ? const CustomLoading()
              : Consumer<NGOProvider>(
                  builder: (context, ngoP, child) => RefreshIndicator(
                    onRefresh: () => ngoP.refreshNGO(ngoID: widget.ngoID),
                    child: ngoP.getNGO == null
                        ? const FetchError()
                        : ListView(
                            controller: widget.scrollController,
                            children: [
                              NGOProfile(
                                ngoData: ngoP.getNGO!,
                              ),
                            ],
                          ),
                  ),
                ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
