import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/ngo_provider.dart';
import 'package:sasae_flutter_app/widgets/misc/fetch_error.dart';
import 'package:sasae_flutter_app/widgets/ngo/ngo_list.dart';
import 'package:sasae_flutter_app/widgets/ngo/search_filter_bar.dart';

class NGOScreen extends StatefulWidget {
  const NGOScreen({Key? key}) : super(key: key);

  @override
  _NGOScreenState createState() => _NGOScreenState();
}

class _NGOScreenState extends State<NGOScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: Provider.of<NGOProvider>(context, listen: false).fetchNGOs(),
      builder: (context, snapshot) =>
          snapshot.connectionState == ConnectionState.waiting
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    LinearProgressIndicator(),
                  ],
                )
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
                          child: ngoP.fetchError
                              ? const FetchError(
                                  fraction: 0.75,
                                )
                              : ngoP.ngosData!.isEmpty
                                  ? const Center(
                                      child: Text('No NGO found!'),
                                    )
                                  : NGOList(
                                      ngoList: ngoP.ngosData!,
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
