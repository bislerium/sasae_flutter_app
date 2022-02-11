import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sasae_flutter_app/widgets/ngo_tile.dart';
import '../widgets/custom_filter_chip.dart';
import '../models/ngo.dart';
import 'package:faker/faker.dart';

class NGOs extends StatefulWidget {
  const NGOs({Key? key}) : super(key: key);

  @override
  _NGOsState createState() => _NGOsState();
}

class _NGOsState extends State<NGOs> {
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
    filterChips = fieldOfWork
        .map((e) => CustomFilterChip(
              chipLabel: e,
              selectionList: selectedChips,
            ))
        .toList();
  }

  void applyFilter() {
    setState(() {
      filtered = true;
      dataToShow = ngoDataList.where((element) {
        return element.fieldOfWork!
            .any((element) => selectedChips.contains(element));
      }).toList();
    });
  }

  void clear(BuildContext context) {
    searchController.clear();
    selectedChips.clear();
    filtered = false;
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

  void showFilterModal(BuildContext ctx) {
    selectedChips.clear();
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
            SizedBox(
              height: 60,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          )),
                        ),
                        onPressed: () {
                          if (selectedChips.isNotEmpty) {
                            applyFilter();
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
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(0),
            bottomLeft: Radius.circular(0)),
      ),
    );
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
                    color: Theme.of(context).primaryColorLight,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          color: Theme.of(context).primaryColorDark,
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
                              color: Theme.of(context).primaryColorDark,
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
                        ? Theme.of(context).primaryColorLight
                        : Colors.transparent,
                    child: IconButton(
                      color: Theme.of(context).primaryColorDark,
                      onPressed: () => showFilterModal(context),
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
          child: Container(
            margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
            child: RefreshIndicator(
              onRefresh: () => _refresh(context),
              child: dataToShow.isEmpty && searchController.text.isNotEmpty
                  ? const Center(
                      child: Text('No NGO found 😔'),
                    )
                  : ListView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: dataToShow.isEmpty
                          ? [
                              const Center(
                                child: Text('Empty NGO List, Please Refresh!'),
                              )
                            ]
                          : dataToShow
                              .map((e) => Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: NGOTile(
                                      key: ValueKey(e.id),
                                      ngo: e,
                                    ),
                                  ))
                              .toList(),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
