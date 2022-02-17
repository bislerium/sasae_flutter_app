import 'dart:math';

import 'package:flutter/material.dart';
import './ngo_list.dart';
import './custom_filter_chip.dart';
import '../../models/ngo.dart';
import 'package:faker/faker.dart';

class NGOScreen extends StatefulWidget {
  const NGOScreen({Key? key}) : super(key: key);

  @override
  _NGOScreenState createState() => _NGOScreenState();
}

class _NGOScreenState extends State<NGOScreen>
    with AutomaticKeepAliveClientMixin {
  var searchController = TextEditingController();

  List<NGO> ngoDataList = []; // Actual Untouched DataList
  List<NGO> dataToShow = []; // Filtered/search data
  List<String> selectedChips = [];
  List<Widget> filterChips = [];
  var filtered = false;

  @override
  void initState() {
    super.initState();
    _getNGOData();
  }

  void _getNGOData() {
    int length = Random().nextInt(100 - 20) + 20;
    ngoDataList = List.generate(
      length,
      (index) {
        return NGO(
          id: index,
          orgName: faker.company.name(),
          orgPhoto: faker.image.image(random: true),
          estDate: faker.date.dateTime(minYear: 2000, maxYear: 2022),
          address: faker.address.city() + faker.address.streetAddress(),
          fieldOfWork: List.generate(
            Random().nextInt(8 - 1) + 1,
            (index) => faker.lorem.word(),
          ),
        );
      },
    );
    dataToShow = ngoDataList;
    getFilterChips();
  }

  Future<void> _refresh(BuildContext context) async {
    // await Future.delayed(Duration(seconds: 2));
    _getNGOData();
    clear(context);
  }

  void _searchByName(String enteredName) {
    setState(
      () {
        if (enteredName.isEmpty) {
          dataToShow = ngoDataList;
        } else {
          filtered = false;
          dataToShow = ngoDataList
              .where((ngo) => ngo.orgName!
                  .toLowerCase()
                  .contains(enteredName.toLowerCase()))
              .toList();
        }
      },
    );
  }

  void getFilterChips() {
    filtered = false;
    Set<String> fieldOfWork = {};
    for (var ngo in ngoDataList) {
      for (var field in ngo.fieldOfWork!) {
        fieldOfWork.add(field);
      }
    }
    List<CustomFilterChip> chips = fieldOfWork
        .map((e) => CustomFilterChip(
              chipLabel: e,
              selectionList: selectedChips,
            ))
        .toList();
    chips.sort((a, b) => a.chipLabel.compareTo(b.chipLabel));
    filterChips = chips;
  }

  void applyFilter() {
    setState(() {
      filtered = true;
      searchController.clear();
      dataToShow = ngoDataList.where((element) {
        return element.fieldOfWork!
            .any((element) => selectedChips.contains(element));
      }).toList();
      selectedChips.clear();
    });
  }

  void clear(BuildContext context) {
    setState(() {
      searchController.clear();
      selectedChips.clear();
      filtered = false;
      dataToShow = ngoDataList;
      FocusScope.of(context).unfocus();
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    searchController.dispose();
    super.dispose();
  }

  void showFilterModal(BuildContext ctx) {
    showModalBottomSheet(
      backgroundColor: Theme.of(context).colorScheme.surface,
      context: ctx,
      builder: (_) {
        return Column(
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
                    children: filterChips,
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
                          clear(context);
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
                            applyFilter();
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
      },
      // isDismissible: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: dataToShow.isEmpty & searchController.text.isEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/gif/no_result.gif',
                  height: 200,
                ),
                ElevatedButton.icon(
                    onPressed: () => _refresh(context),
                    style:
                        ElevatedButton.styleFrom(shape: const StadiumBorder()),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Refresh'))
              ],
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Theme.of(context).colorScheme.surface,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: TextField(
                                      keyboardType: TextInputType.text,
                                      controller: searchController,
                                      onChanged: (value) =>
                                          _searchByName(value),
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Search NGO by their Name',
                                      ),
                                      textInputAction: TextInputAction.search,
                                    ),
                                  ),
                                ),
                                if (searchController.text.isNotEmpty)
                                  InkWell(
                                    onTap: () => clear(context),
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
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: ClipOval(
                          child: Container(
                            color: filtered
                                ? Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer
                                : Theme.of(context).colorScheme.background,
                            child: IconButton(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer,
                              onPressed: () {
                                // clear(context);
                                showFilterModal(context);
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
                  child: dataToShow.isEmpty & searchController.text.isNotEmpty
                      ? const Center(
                          child: Text('No NGO found 😔'),
                        )
                      : RefreshIndicator(
                          onRefresh: () => _refresh(context),
                          child: NGOList(ngoList: dataToShow),
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
