import 'dart:math';

import 'package:flutter/material.dart';
import '../widgets/custom_filter_chip.dart';
import '../models/ngo.dart';
import 'package:faker/faker.dart';
import 'package:filter_list/filter_list.dart';

class NGOs extends StatefulWidget {
  const NGOs({Key? key}) : super(key: key);

  @override
  _NGOsState createState() => _NGOsState();
}

class _NGOsState extends State<NGOs> {
  var searchController = TextEditingController();

  List<NGO> ngoDataList = []; // Actual Untouched DataList
  List<NGO> dataToShow = []; // Filtered/search data

  void _getNGOData() {
    int length = Random().nextInt(100 - 20) + 20;
    ngoDataList = List.generate(
      length,
      (index) {
        return NGO(
          id: index,
          orgName: faker.company.name(),
          orgPhoto: 'https://picsum.photos/500/500',
          estDate: faker.date.dateTime(minYear: 2000, maxYear: 2022),
          address: faker.address.city(),
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

  @override
  void initState() {
    super.initState();
    _getNGOData();
  }

  Future<void> _refresh() async {
    // await Future.delayed(Duration(seconds: 2));
    setState(
      () {
        _getNGOData();
      },
    );
  }

  void _searchByName(String enteredName) {
    setState(
      () {
        if (enteredName.isEmpty) {
          dataToShow = ngoDataList;
        } else {
          dataToShow = ngoDataList
              .where((ngo) => ngo.orgName!
                  .toLowerCase()
                  .contains(enteredName.toLowerCase()))
              .toList();
        }
      },
    );
  }

  List<CustomFilterChip> selectedChips = [];
  List<Widget> filterChips = [];

  void getFilterChips() {
    Set<String> fieldOfWork = {};
    for (var ngo in ngoDataList) {
      for (var field in ngo.fieldOfWork!) {
        fieldOfWork.add(field);
      }
    }
    filterChips = fieldOfWork
        .map((e) => CustomFilterChip(
              chipLabel: e,
              selectionList: selectedChips,
            ))
        .toList();
  }

  void applyFilter() {
    List<String> fieldOfWork = selectedChips.map((e) {
      return e.chipLabel;
    }).toList();
    setState(() {
      dataToShow = ngoDataList.where((element) {
        return element.fieldOfWork!
            .any((element) => fieldOfWork.contains(element));
      }).toList();
    });
  }

  void showFilterModal(BuildContext ctx) {
    showModalBottomSheet(
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
                  fontSize: 15,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Spacer(
                  flex: 1,
                ),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 4,
                  child: TextButton(
                    child: const Text('Reset'),
                    onPressed: () {
                      if (selectedChips.isNotEmpty) {
                        selectedChips.clear();
                        clear(context);
                      }
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                const Spacer(
                  flex: 1,
                ),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 4,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigator.of(context).pop();
                      selectedChips.forEach((element) {
                        print(element.chipLabel);
                      });
                      applyFilter();
                    },
                    child: const Text('Apply'),
                  ),
                ),
                const Spacer(
                  flex: 1,
                ),
              ],
            ),
          ],
        );
      },
      // isDismissible: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(0),
            bottomLeft: Radius.circular(0)),
      ),
    );
  }

  void clear(BuildContext context) {
    searchController.clear();
    setState(() {
      dataToShow = ngoDataList;
    });
    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Theme.of(context).primaryColor.withAlpha(30),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          color: Theme.of(context).primaryColor,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: TextField(
                              keyboardType: TextInputType.text,
                              controller: searchController,
                              onChanged: (value) => _searchByName(value),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Search NGO by their Name',
                              ),
                            ),
                          ),
                        ),
                        if (searchController.text.isNotEmpty)
                          InkWell(
                            onTap: () => clear(context),
                            child: Icon(
                              Icons.clear,
                              color: Theme.of(context).primaryColor,
                            ),
                          )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: IconButton(
                  onPressed: () => showFilterModal(context),
                  icon: Icon(
                    Icons.filter_list,
                    size: 30,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: dataToShow.isEmpty
                  ? Center(
                      child: searchController.text.isEmpty
                          ? const Text('Empty NGO List, Please Refresh!')
                          : const Text('No NGO found 😔'),
                    )
                  : ListView.builder(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      itemCount: dataToShow.length,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Card(
                            elevation: 12,
                            shadowColor: Theme.of(context).primaryColorLight,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: InkWell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(14.0),
                                      child: Image.network(
                                        dataToShow[index].orgPhoto!,
                                        fit: BoxFit.cover,
                                        height: 100.0,
                                        width: 100.0,
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 100,
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 0, 0, 0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.location_pin,
                                                      size: 18,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                    ),
                                                    Text(
                                                      dataToShow[index]
                                                          .address!,
                                                      style: const TextStyle(
                                                          color:
                                                              Colors.black87),
                                                    )
                                                  ],
                                                ),
                                                Text(dataToShow[index]
                                                    .estDate!
                                                    .year
                                                    .toString()),
                                              ],
                                            ),
                                            Text(
                                              dataToShow[index].orgName!,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                            SizedBox(
                                              height: 40,
                                              child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: dataToShow[index]
                                                    .fieldOfWork!
                                                    .length,
                                                itemBuilder: (context, _) {
                                                  return Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 2),
                                                    child: Chip(
                                                      label: Text(
                                                        dataToShow[index]
                                                            .fieldOfWork![_],
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      backgroundColor:
                                                          Theme.of(context)
                                                              .primaryColor
                                                              .withAlpha(220),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () =>
                                  ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('You have clicked'),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
