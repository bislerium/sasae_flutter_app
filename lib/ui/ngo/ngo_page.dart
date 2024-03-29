import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/ngo_provider.dart';
import 'package:sasae_flutter_app/providers/visibility_provider.dart';
import 'package:sasae_flutter_app/services/utilities.dart';
import 'package:sasae_flutter_app/ui/misc/custom_loading.dart';
import 'package:sasae_flutter_app/ui/misc/fetch_error.dart';
import 'package:sasae_flutter_app/ui/ngo/module/ngo_list.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sasae_flutter_app/ui/misc/custom_widgets.dart';

class NGOPage extends StatefulWidget {
  const NGOPage({Key? key}) : super(key: key);

  @override
  State<NGOPage> createState() => _NGOPageState();
}

class _NGOPageState extends State<NGOPage> with AutomaticKeepAliveClientMixin {
  late final Future<void> _fetchNGOFUTURE;
  final ScrollController _scrollController;
  late final NavigationBarProvider _navigationBarP;
  late final NGOProvider _ngoP;

  _NGOPageState() : _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _navigationBarP =
        Provider.of<NavigationBarProvider>(context, listen: false);
    _ngoP = Provider.of<NGOProvider>(context, listen: false);
    _scrollController.addListener(ngoListLS);
    _fetchNGOFUTURE = _fetchNGO();
  }

  @override
  void dispose() {
    _scrollController.removeListener(ngoListLS);
    _scrollController.dispose();
    _ngoP.disposeNGOs();
    super.dispose();
  }

  Future<void> _fetchNGO() async {
    await _ngoP.fetchNGOs();
  }

  void ngoListLS() {
    var direction = _scrollController.position.userScrollDirection;
    if (direction == ScrollDirection.reverse) {
      _navigationBarP.setShowNB = false;
    } else {
      _navigationBarP.setShowNB = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: _fetchNGOFUTURE,
      builder: (context, snapshot) =>
          snapshot.connectionState == ConnectionState.waiting
              ? const ScreenLoading()
              : Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: SearchFilterBar(),
                    ),
                    Expanded(
                      child: Consumer<NGOProvider>(
                        builder: (context, ngoP, child) => RefreshIndicator(
                          onRefresh: () async => await refreshCallBack(
                            context: context,
                            func: ngoP.refreshNGOs,
                          ),
                          child: ngoP.getIsFetchError
                              ? const ErrorView(
                                  fraction: 0.794,
                                )
                              : ngoP.getNGOs!.isEmpty
                                  ? const ErrorView(
                                      fraction: 0.794,
                                      errorIcon: Icons.emoji_nature_rounded,
                                    )
                                  : NGOList(
                                      scrollController: _scrollController,
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

////////////////////////////////////////////////////////////////////////////////

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
      context: context,
      children: [
        Text('Filter by Field of Work',
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(
          height: 20,
        ),
        Container(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.42),
          child: SingleChildScrollView(
            primary: true,
            child: FormBuilderFilterChip(
              name: 'filter_by_field_of_work',
              decoration: const InputDecoration(border: InputBorder.none),
              onChanged: (value) =>
                  _ngoP.setSelectedFOW = value!.cast<String>(),
              initialValue: _ngoP.getSelectedFOW,
              options: _ngoP.getFieldOfWork
                  .map((e) => FormBuilderChipOption(value: e, child: Text(e)))
                  .toList()
                ..sort((a, b) => a.value.compareTo(b.value)),
              spacing: 8,
              selectedColor: Theme.of(context).colorScheme.primaryContainer,
              backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
              alignment: WrapAlignment.center,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
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
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.check),
                  label: const Text('Apply'),
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
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: Provider.of<NavigationBarProvider>(context).getShowNB ? 68 : 0,
      child: Consumer<NGOProvider>(
        builder: ((context, ngoP, child) {
          bool isDataUnavailable = ngoP.getIsFetchError ||
              (ngoP.getNGOs!.isEmpty &&
                  !ngoP.getIsFiltered &&
                  !ngoP.getIsSearched);
          return Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      FittedBox(
                        child: Icon(
                          Icons.search,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
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
                          child: FittedBox(
                            child: Icon(
                              Icons.clear,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                  onPressed: isDataUnavailable
                      ? null
                      : () async {
                          if (ngoP.getIsSearched) {
                            ngoP.clear();
                          }
                          FocusScope.of(context).unfocus();
                          _searchTEC.clear();
                          await showFilterModal();
                        },
                  child: const FittedBox(
                    child: Icon(
                      Icons.filter_list,
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
