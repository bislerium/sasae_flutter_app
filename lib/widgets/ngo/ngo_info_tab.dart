import 'package:flutter/material.dart';
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
  late NGOProvider _provider;
  late final Future<void> _fetchNGOFUTURE;

  @override
  void initState() {
    super.initState();
    _provider = Provider.of<NGOProvider>(context, listen: false);
    _fetchNGOFUTURE = _fetchNGO();
  }

  @override
  void dispose() {
    _provider.nullifyNGO();
    super.dispose();
  }

  Future<void> _fetchNGO() async {
    await _provider.initFetchNGO(
      ngoID: widget.ngoID,
    );
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
                    child: ngoP.ngoData == null
                        ? const FetchError()
                        : ListView(
                            controller: widget.scrollController,
                            children: [
                              NGOProfile(
                                ngoData: ngoP.ngoData!,
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
