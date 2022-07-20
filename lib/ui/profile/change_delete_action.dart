import 'dart:ui';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/auth_provider.dart';
import 'package:sasae_flutter_app/services/utilities.dart';
import 'package:sasae_flutter_app/ui/auth/auth_screen.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_obscure_text_field.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_widgets.dart';

class ChangeDeleteAction extends StatefulWidget {
  final bool deletable;
  const ChangeDeleteAction({Key? key, this.deletable = true}) : super(key: key);

  @override
  State<ChangeDeleteAction> createState() => _ChangeDeleteActionState();
}

class _ChangeDeleteActionState extends State<ChangeDeleteAction> {
  final GlobalKey<FormBuilderState> _deleteformKey, _changeformKey;
  final TextEditingController _oldPasswordTEC,
      _newPassword1TEC,
      _newPassword2TEC;

  _ChangeDeleteActionState()
      : _deleteformKey = GlobalKey<FormBuilderState>(),
        _changeformKey = GlobalKey<FormBuilderState>(),
        _oldPasswordTEC = TextEditingController(),
        _newPassword1TEC = TextEditingController(),
        _newPassword2TEC = TextEditingController();

  @override
  void dispose() {
    _oldPasswordTEC.dispose();
    _newPassword1TEC.dispose();
    _newPassword2TEC.dispose();
    super.dispose();
  }

  Future<void> showPasswordChangeModal() async {
    showModalSheet(
      context: context,
      topPadding: 40,
      bottomPadding: 20,
      leftPadding: 30,
      rightPadding: 30,
      children: [
        Text(
          'Change Password',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          'Enter your old and new password to proceed password change.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.subtitle2,
        ),
        const SizedBox(
          height: 20,
        ),
        FormBuilder(
          key: _changeformKey,
          child: Column(
            children: [
              CustomObscureTextField(
                labeltext: 'Old Password',
                textEditingController: _oldPasswordTEC,
                validators: FormBuilderValidators.compose(
                  [
                    FormBuilderValidators.required(),
                  ],
                ),
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.next,
              ),
              CustomObscureTextField(
                labeltext: 'New Password',
                textEditingController: _newPassword1TEC,
                validators: FormBuilderValidators.compose(
                  [
                    FormBuilderValidators.required(),
                  ],
                ),
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.next,
              ),
              CustomObscureTextField(
                labeltext: 'Confirm New Password',
                textEditingController: _newPassword2TEC,
                validators: FormBuilderValidators.compose(
                  [
                    FormBuilderValidators.required(),
                    (value) => value != _newPassword1TEC.text
                        ? 'Passwords did\'nt match!'
                        : null
                  ],
                ),
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.next,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        ConstrainedBox(
          constraints:
              const BoxConstraints.tightFor(height: 60, width: double.infinity),
          child: ElevatedButton(
            onPressed: () async {
              final isValid = _changeformKey.currentState!.validate();
              if (isValid) {
                Navigator.of(context).pop();
                if (!isInternetConnected(context)) return;
                bool success =
                    await Provider.of<AuthProvider>(context, listen: false)
                        .changePassword(
                  oldPassword: _oldPasswordTEC.text,
                  newPassword1: _newPassword1TEC.text,
                  newPassword2: _newPassword2TEC.text,
                );
                if (success) {
                  showSnackBar(
                    context: context,
                    message: 'Password changed successfully',
                  );
                } else {
                  showSnackBar(
                    context: context,
                    message: 'Unable to change password',
                    errorSnackBar: true,
                  );
                }
                _oldPasswordTEC.clear();
                _newPassword1TEC.clear();
                _newPassword2TEC.clear();
              }
            },
            child: const Text(
              'Change',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> showDeleteDialog() async {
    String a = faker.randomGenerator.string(8, min: 6);
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
              RichText(
                text: TextSpan(
                  text: 'Type ',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: ' $a ',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 16,
                        backgroundColor:
                            Theme.of(context).colorScheme.tertiaryContainer,
                        color:
                            Theme.of(context).colorScheme.onTertiaryContainer,
                      ),
                    ),
                    const TextSpan(text: ' to Confirm!'),
                  ],
                ),
              ),
              FormBuilder(
                key: _deleteformKey,
                child: FormBuilderTextField(
                  name: 'check',
                  validator: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.required(),
                      (value) => value != a ? 'Incorrect value' : null
                    ],
                  ),
                  // decoration: const InputDecoration(border: InputBorder.none),
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                bool isValid = _deleteformKey.currentState!.validate();
                if (isValid) {
                  Navigator.of(context).pop();
                  if (!isInternetConnected(context)) return;
                  bool success =
                      await Provider.of<AuthProvider>(context, listen: false)
                          .deleteUser();
                  if (success) {
                    await SessionManager().remove('auth_data');
                    showSnackBar(
                        context: context,
                        message: 'Account deleted successfully');
                    if (!mounted) return;
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        AuthScreen.routeName, (Route<dynamic> route) => false);
                  } else {
                    showSnackBar(
                        context: context,
                        message: 'Something went wrong',
                        errorSnackBar: true);
                  }
                }
              },
              child: const Text('I Confirm'),
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
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (widget.deletable)
            Ink(
              decoration: ShapeDecoration(
                color: Theme.of(context).colorScheme.tertiaryContainer,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
              ),
              child: IconButton(
                onPressed: () async {
                  if (!isInternetConnected(context)) return;
                  await showDeleteDialog();
                },
                icon: const Icon(Icons.person_remove_rounded),
                color: Theme.of(context).colorScheme.onTertiaryContainer,
              ),
            ),
          Ink(
            decoration: ShapeDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              shape: widget.deletable
                  ? const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    )
                  : const CircleBorder(),
            ),
            child: IconButton(
              onPressed: () async {
                if (!isInternetConnected(context)) return;
                await showPasswordChangeModal();
              },
              icon: const Icon(Icons.password_rounded),
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}
