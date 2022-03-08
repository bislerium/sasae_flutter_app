import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/ngo_provider.dart';
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
      builder: (context, snapshot) => snapshot.connectionState ==
              ConnectionState.waiting
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
                    builder: (context, ngoP, child) => ngoP.ngoData.isEmpty &&
                            !ngoP.isFiltered &&
                            !ngoP.isSearched
                        ? Column(
                            children: [
                              const Spacer(),
                              Image.asset(
                                'assets/gif/no_result.gif',
                                height: 200,
                              ),
                              ElevatedButton.icon(
                                onPressed: () async {
                                  ngoP.setRefreshingStatus(true);
                                  await ngoP.refreshNGOs();
                                  ngoP.setRefreshingStatus(false);
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: const StadiumBorder(),
                                ),
                                icon: const Icon(Icons.refresh),
                                label: const Text('Refresh'),
                              ),
                              const Spacer(),
                              Visibility(
                                visible: ngoP.isNGOsLoading ? true : false,
                                child: const LinearProgressIndicator(),
                              ),
                            ],
                          )
                        : ngoP.ngoData.isEmpty &&
                                (ngoP.isSearched || ngoP.isFiltered)
                            ? const Center(
                                child: Text('No NGO found!'),
                              )
                            : RefreshIndicator(
                                onRefresh: ngoP.refreshNGOs,
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0),
                                    child: NGOList(ngoList: ngoP.ngoData)),
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
