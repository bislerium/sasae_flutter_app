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
  List<String> _selectedChips;

  _SearchFilterBarState()
      : _searchTEC = TextEditingController(),
        _selectedChips = [];

  @override
  void dispose() {
    _searchTEC.dispose();
    super.dispose();
  }

  Future<void> showFilterModal(NGOProvider provider) async {
    _selectedChips.clear();
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
              onChanged: (value) => _selectedChips = value!.cast<String>(),
              options: provider.fieldOfWork
                  .map((e) => FormBuilderFieldOption(value: e, child: Text(e)))
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
                      provider.clear();
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
                      if (_selectedChips.isNotEmpty) {
                        provider.applyFieldOfWorkFilter(_selectedChips);
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
        bool isDataUnavailable = ngoP.fetchError ||
            (ngoP.ngosData!.isEmpty && !ngoP.isFiltered && !ngoP.isSearched);
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
                                if (ngoP.isFiltered) ngoP.clear();
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
                    color: ngoP.isFiltered
                        ? Theme.of(context).colorScheme.secondaryContainer
                        : Theme.of(context).colorScheme.background,
                    child: IconButton(
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                      onPressed: isDataUnavailable
                          ? null
                          : () async {
                              if (ngoP.isSearched || ngoP.isFiltered) {
                                ngoP.clear();
                              }
                              _searchTEC.clear();
                              await showFilterModal(ngoP);
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
