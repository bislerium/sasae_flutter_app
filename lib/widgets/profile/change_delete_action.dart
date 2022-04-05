import 'dart:ui';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/people_provider.dart';
import 'package:sasae_flutter_app/widgets/auth/auth_screen.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_widgets.dart';

class ChangeDeleteAction extends StatefulWidget {
  final bool deletable;
  const ChangeDeleteAction({Key? key, this.deletable = true}) : super(key: key);

  @override
  State<ChangeDeleteAction> createState() => _ChangeDeleteActionState();
}

class _ChangeDeleteActionState extends State<ChangeDeleteAction> {
  final GlobalKey<FormBuilderState> _formKey;

  _ChangeDeleteActionState() : _formKey = GlobalKey<FormBuilderState>();

  Future<void> showDeleteDialog() async {
    int min = 0;
    int max = 20;
    int _ = faker.randomGenerator.integer(max, min: min + 1);
    await showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 8,
          sigmaY: 8,
        ),
        child: AlertDialog(
          scrollable: true,
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 3,
          title: const Text('Delete Account'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Once deleted, You might not be able to recover.'),
              const SizedBox(height: 10),
              Text('"Slide the slider to $_ to confirm!"'),
              FormBuilder(
                key: _formKey,
                child: FormBuilderSlider(
                  name: 'check',
                  initialValue: min.toDouble(),
                  min: min.toDouble(),
                  max: max.toDouble(),
                  divisions: max,
                  validator: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.required(context),
                      (value) => value != _ ? 'Incorrect!' : null
                    ],
                  ),
                  decoration: const InputDecoration(border: InputBorder.none),
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                bool isValid = _formKey.currentState!.validate();
                if (isValid) {
                  bool success =
                      await Provider.of<PeopleProvider>(context, listen: false)
                          .deletePeople();
                  if (success) {
                    await SessionManager().remove('auth_data');
                    showSnackBar(
                        context: context,
                        message: 'Account deleted successfully!');
                    await Navigator.of(context).pushNamedAndRemoveUntil(
                        AuthScreen.routeName, (Route<dynamic> route) => false);
                  } else {
                    showSnackBar(
                        context: context,
                        message: 'Something went wrong!',
                        errorSnackBar: true);
                  }
                }
              },
              child: const Text('Confirm'),
            ),
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'Cancel',
                ))
          ],
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 60,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.password_rounded),
                label: const Text('Change'),
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).colorScheme.surfaceVariant,
                  onPrimary: Theme.of(context).colorScheme.onSurfaceVariant,
                  shape: const StadiumBorder(),
                ),
              ),
            ),
          ),
          if (widget.deletable) ...[
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: SizedBox(
                height: 60,
                child: ElevatedButton.icon(
                  onPressed: () async => showDeleteDialog(),
                  icon: const Icon(Icons.person_remove_rounded),
                  label: const Text('Delete'),
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).colorScheme.error,
                    onPrimary: Theme.of(context).colorScheme.onError,
                    shape: const StadiumBorder(),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
