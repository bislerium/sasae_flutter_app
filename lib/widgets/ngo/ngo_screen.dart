import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/ngo_provider.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_widgets.dart';
import 'package:sasae_flutter_app/widgets/ngo/custom_filter_chip.dart';
import 'package:sasae_flutter_app/widgets/ngo/ngo_list.dart';

class NGOScreen extends StatefulWidget {
  const NGOScreen({Key? key}) : super(key: key);

  @override
  _NGOScreenState createState() => _NGOScreenState();
}

class _NGOScreenState extends State<NGOScreen>
    with AutomaticKeepAliveClientMixin {
  TextEditingController searchController;
  List<String> selectedChips;

  _NGOScreenState()
      : searchController = TextEditingController(),
        selectedChips = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void showFilterModal(BuildContext ctx, NGOProvider provider) =>
      showModalSheet(
        ctx: ctx,
        height: MediaQuery.of(ctx).size.height * 0.6,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'Filter by Field of Work',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  children: provider.fieldOfWork
                      .map((e) => CustomFilterChip(
                            chipLabel: e,
                            selectionList: selectedChips,
                          ))
                      .toList()
                    ..sort((a, b) => a.chipLabel.compareTo(b.chipLabel)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              height: 60,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 10,
                    child: TextButton(
                      child: const Text('Reset'),
                      onPressed: () {
                        provider.reset();
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  const Spacer(
                    flex: 1,
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 10,
                    child: ElevatedButton(
                      child: const Text('Apply'),
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                      ),
                      onPressed: () {
                        if (selectedChips.isNotEmpty) {
                          provider.applyFieldOfWorkFilter(selectedChips);
                          FocusScope.of(context).unfocus();
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: Provider.of<NGOProvider>(context, listen: false).fetchNGO(),
      builder: (context, snapshot) => snapshot.connectionState ==
              ConnectionState.waiting
          ? Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                LinearProgressIndicator(),
              ],
            )
          : Consumer<NGOProvider>(
              builder: ((context, ngoP, child) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    child: ngoP.ngoData.isEmpty & searchController.text.isEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/gif/no_result.gif',
                                height: 200,
                              ),
                              ElevatedButton.icon(
                                  onPressed: () => ngoP.refresh(),
                                  style: ElevatedButton.styleFrom(
                                      shape: const StadiumBorder()),
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('Refresh'))
                            ],
                          )
                        : Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.search,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimaryContainer,
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10),
                                                  child: TextField(
                                                    keyboardType:
                                                        TextInputType.text,
                                                    controller:
                                                        searchController,
                                                    onChanged: (value) => ngoP
                                                        .searchByName(value),
                                                    decoration:
                                                        const InputDecoration(
                                                      border: InputBorder.none,
                                                      hintText:
                                                          'Search NGO by their Name',
                                                    ),
                                                    textInputAction:
                                                        TextInputAction.search,
                                                  ),
                                                ),
                                              ),
                                              if (searchController
                                                  .text.isNotEmpty)
                                                InkWell(
                                                  onTap: () {
                                                    ngoP.reset();
                                                    searchController.clear();
                                                    FocusScope.of(context)
                                                        .unfocus();
                                                  },
                                                  child: Icon(
                                                    Icons.clear,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onPrimaryContainer,
                                                  ),
                                                )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      child: ClipOval(
                                        child: Container(
                                          color: ngoP.isFiltered
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .secondaryContainer
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .background,
                                          child: IconButton(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSecondaryContainer,
                                            onPressed: () {
                                              // clear(context);
                                              showFilterModal(context, ngoP);
                                            },
                                            icon: const Icon(
                                              Icons.filter_list,
                                              size: 30,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: ngoP.ngoData.isEmpty &
                                        searchController.text.isNotEmpty
                                    ? const Center(
                                        child: Text('No NGO found 😔'),
                                      )
                                    : RefreshIndicator(
                                        onRefresh: () => ngoP.refresh(),
                                        child: NGOList(ngoList: ngoP.ngoData),
                                      ),
                              ),
                            ],
                          ),
                  )),
            ),
    );
  }

  @override
  // ignore: todo
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
