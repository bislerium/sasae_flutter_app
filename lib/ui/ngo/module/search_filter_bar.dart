import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/ngo_provider.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_widgets.dart';

class SearchFilterBar extends StatefulWidget {
  const SearchFilterBar({Key? key}) : super(key: key);

  @override
  State<SearchFilterBar> createState() => _SearchFilterBarState();
}

class _SearchFilterBarState extends State<SearchFilterBar> {
  final TextEditingController _searchTEC;
  late final NGOProvider _ngoP;

  _SearchFilterBarState() : _searchTEC = TextEditingController();

  @override
  void initState() {
    super.initState();
    _ngoP = Provider.of<NGOProvider>(context, listen: false);
  }

  @override
  void dispose() {
    _searchTEC.dispose();
    super.dispose();
  }

  Future<void> showFilterModal() async {
    await showModalSheet(
      ctx: context,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text(
            'Filter by Field of Work',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        Container(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.4),
          child: SingleChildScrollView(
            child: FormBuilderFilterChip(
              name: 'filter_by_field_of_-work',
              decoration: const InputDecoration(border: InputBorder.none),
              onChanged: (value) =>
                  _ngoP.setSelectedFOW = value!.cast<String>(),
              initialValue: _ngoP.getSelectedFOW,
              options: _ngoP.getFieldOfWork
                  .map((e) => FormBuilderChipOption(value: e, child: Text(e)))
                  .toList()
                ..sort((a, b) => a.value.compareTo(b.value)),
              spacing: 10,
              runSpacing: -5,
              selectedColor: Theme.of(context).colorScheme.primaryContainer,
              labelStyle: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              alignment: WrapAlignment.center,
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
                      if (_ngoP.getIsFiltered) {
                        _ngoP.clear();
                      }
                      FocusScope.of(context).unfocus();
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
                      if (_ngoP.getSelectedFOW.isNotEmpty) {
                        _ngoP.applyFieldOfWorkFilter();
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
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NGOProvider>(
      builder: ((context, ngoP, child) {
        bool isDataUnavailable = ngoP.getIsFetchError ||
            (ngoP.getNGOs!.isEmpty &&
                !ngoP.getIsFiltered &&
                !ngoP.getIsSearched);
        return Padding(
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
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: TextField(
                              keyboardType: TextInputType.text,
                              controller: _searchTEC,
                              enabled: isDataUnavailable ? false : true,
                              onTap: () {
                                if (ngoP.getIsFiltered) ngoP.clear();
                              },
                              onChanged: (value) {
                                ngoP.searchByName(value.trim());
                              },
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Search NGO by name',
                              ),
                              textInputAction: TextInputAction.search,
                            ),
                          ),
                        ),
                        if (_searchTEC.text.isNotEmpty)
                          InkWell(
                            onTap: () {
                              ngoP.clear();
                              _searchTEC.clear();
                              FocusScope.of(context).unfocus();
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
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: ClipOval(
                  child: Container(
                    color: ngoP.getIsFiltered
                        ? Theme.of(context).colorScheme.secondaryContainer
                        : Theme.of(context).colorScheme.background,
                    child: IconButton(
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                      onPressed: isDataUnavailable
                          ? null
                          : () async {
                              if (ngoP.getIsSearched) {
                                ngoP.clear();
                              }
                              _searchTEC.clear();
                              await showFilterModal();
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
        );
      }),
    );
  }
}
