import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/people_provider.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_appbar.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_loading.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_scroll_animated_fab.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_widgets.dart';
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
    return Scaffold(
      appBar: const CustomAppBar(title: 'Update Profile'),
      body: FutureBuilder(
        future: _fetchPeopleUpdateFUTURE,
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const CustomLoading()
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Consumer<PeopleProvider>(
        builder: (context, peopleP, child) => peopleP.getPeopleUpdate == null
            ? const SizedBox.shrink()
            : CustomScrollAnimatedFAB(
                text: 'Done',
                background: Theme.of(context).colorScheme.primary,
                icon: Icons.done_rounded,
                func: () async {
                  bool validForm = _formKey.currentState!.validate();
                  if (validForm) {
                    showCustomDialog(
                      context: context,
                      title: 'Confirm Update',
                      content:
                          'Don\'t forget to refresh your profile page, once updated.',
                      okFunc: () async {
                        _formKey.currentState!.save();
                        Navigator.of(context)
                          ..pop()
                          ..pop();
                        bool success = await peopleP.updatePeople();
                        if (success) {
                          showSnackBar(
                              context: context, message: 'profile updated');
                        } else {
                          showSnackBar(
                              context: context,
                              message: 'Something went wrong',
                              errorSnackBar: true);
                        }
                      },
                    );
                  }
                },
                scrollController: _scrollController,
              ),
      ),
    );
  }
}
