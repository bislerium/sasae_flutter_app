import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/ngo_provider.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_loading.dart';
import 'package:sasae_flutter_app/widgets/misc/fetch_error.dart';
import 'package:sasae_flutter_app/ui/ngo/module/ngo_list.dart';
import 'package:sasae_flutter_app/ui/ngo/module/search_filter_bar.dart';

class NGOPage extends StatefulWidget {
  const NGOPage({Key? key}) : super(key: key);

  @override
  _NGOPageState createState() => _NGOPageState();
}

class _NGOPageState extends State<NGOPage> with AutomaticKeepAliveClientMixin {
  late final Future<void> _fetchNGOFUTURE;

  @override
  void initState() {
    super.initState();
    _fetchNGOFUTURE = _fetchNGO();
  }

  Future<void> _fetchNGO() async {
    await Provider.of<NGOProvider>(context, listen: false).fetchNGOs();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: _fetchNGOFUTURE,
      builder: (context, snapshot) =>
          snapshot.connectionState == ConnectionState.waiting
              ? const CustomLoading()
              : Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: SearchFilterBar(),
                    ),
                    Expanded(
                      child: Consumer<NGOProvider>(
                        builder: (context, ngoP, child) => RefreshIndicator(
                          onRefresh: ngoP.refreshNGOs,
                          child: ngoP.getIsFetchError
                              ? const ErrorView(
                                  fraction: 0.75,
                                )
                              : ngoP.getNGOs!.isEmpty
                                  ? const Center(
                                      child: Text('No NGO found 🧐...'),
                                    )
                                  : NGOList(
                                      ngoList: ngoP.getNGOs!,
                                    ),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  @override
  // ignore: todo
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
