import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/people_provider.dart';
import 'package:sasae_flutter_app/ui/profile/profile_update_button.dart';
import 'package:sasae_flutter_app/widgets/misc/annotated_scaffold.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_appbar.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_loading.dart';
import 'package:sasae_flutter_app/widgets/misc/fetch_error.dart';
import 'package:sasae_flutter_app/ui/profile/people_profile_edit_form.dart';

class PeopleProfileEditScreen extends StatefulWidget {
  static const String routeName = '/profile/edit';

  const PeopleProfileEditScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<PeopleProfileEditScreen> createState() =>
      _PeopleProfileEditScreenState();
}

class _PeopleProfileEditScreenState extends State<PeopleProfileEditScreen> {
  final ScrollController _scrollController;
  final GlobalKey<FormBuilderState> _formKey;
  late final PeopleProvider peopleP;
  late final Future<void> _fetchPeopleUpdateFUTURE;

  _PeopleProfileEditScreenState()
      : _scrollController = ScrollController(),
        _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    _fetchPeopleUpdateFUTURE = _fetchPeopleUpdate();
  }

  Future<void> _fetchPeopleUpdate() async {
    peopleP = Provider.of<PeopleProvider>(context, listen: false);
    await peopleP.retrieveUpdatePeople();
  }

  @override
  void dispose() {
    super.dispose();
    peopleP.nullifyPeopleUpdate();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedScaffold(
      child: Scaffold(
        appBar: const CustomAppBar(title: 'Update Profile'),
        body: FutureBuilder(
          future: _fetchPeopleUpdateFUTURE,
          builder: (context, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? const ScreenLoading()
                  : Consumer<PeopleProvider>(
                      builder: (context, peopleP, child) =>
                          peopleP.getPeopleUpdate == null
                              ? const ErrorView()
                              : PeopleProfileEditForm(
                                  peopleUpdate: peopleP.getPeopleUpdate!,
                                  scrollController: _scrollController,
                                  formKey: _formKey),
                    ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: ProfileUpdateButton(
          formKey: _formKey,
          scrollController: _scrollController,
        ),
      ),
    );
  }
}
