import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/auth_provider.dart';
import 'package:sasae_flutter_app/services/utilities.dart';
import 'package:sasae_flutter_app/ui/auth/module/login_button.dart';
import 'package:sasae_flutter_app/ui/auth/register_screen.dart';
import 'package:sasae_flutter_app/widgets/misc/annotated_scaffold.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_obscure_text_field.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_widgets.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth';
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<FormBuilderState> _loginFormKey, _passwordResetFormKey;
  final TextEditingController _userNameTEC, _passwordTEC, _resetEmailTEC;
  late final StreamSubscription<ConnectivityResult> subscription;

  _AuthScreenState()
      : _loginFormKey = GlobalKey<FormBuilderState>(),
        _passwordResetFormKey = GlobalKey<FormBuilderState>(),
        _userNameTEC = TextEditingController(),
        _passwordTEC = TextEditingController(),
        _resetEmailTEC = TextEditingController();

  @override
  void initState() {
    super.initState();
    subscription = getConnectivitySubscription(context);
  }

  @override
  void dispose() {
    subscription.cancel();
    _userNameTEC.dispose();
    _passwordTEC.dispose();
    _resetEmailTEC.dispose();
    super.dispose();
  }

  Widget _userName() => FormBuilderTextField(
        name: 'userName',
        key: const Key('usernameATF'),
        controller: _userNameTEC,
        decoration: InputDecoration(
          iconColor: Theme.of(context).colorScheme.secondary,
          prefixIcon: const Icon(
            Icons.account_circle_rounded,
          ),
          labelText: 'Username',
        ),
        validator: FormBuilderValidators.compose(
          [
            FormBuilderValidators.required(),
            FormBuilderValidators.maxLength(15),
            (value) =>
                value!.contains(' ') ? 'Username must be spaceless!' : null,
          ],
        ),
        maxLength: 15,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.text,
      );

  Widget _passwordField() => CustomObscureTextField(
        key: const Key('passwordATF'),
        labeltext: 'Password',
        textEditingController: _passwordTEC,
        validators: FormBuilderValidators.compose(
          [
            FormBuilderValidators.required(),
          ],
        ),
        prefixIcon: const Icon(
          Icons.password_rounded,
        ),
        keyboardType: TextInputType.visiblePassword,
      );

  Widget _loginButton() => LoginButton(
        loginFormKey: _loginFormKey,
        credential: Cred(_userNameTEC.text, _passwordTEC.text),
      );

  Widget _forgetButton() => TextButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        ),
        onPressed: () {
          if (!isInternetConnected(context)) return;
          showResetPasswordModal();
        },
        child: Text(
          'Forgot Password?',
          style: Theme.of(context)
              .textTheme
              .subtitle1!
              .copyWith(color: Theme.of(context).colorScheme.secondary),
        ),
      );

  Widget _createAccountLabel() => InkWell(
        borderRadius: BorderRadius.circular(25),
        onTap: () async {
          if (!isInternetConnected(context)) return;
          await Navigator.of(context).pushNamed(
            RegisterScreen.routeName,
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: 'Don\'t have an account?  ',
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
              children: [
                TextSpan(
                  text: 'Register',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _logo() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/logo.png',
            height: 120,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            'Sasae',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      );

  Widget _loginForm() => FormBuilder(
        key: _loginFormKey,
        child: Column(
          children: <Widget>[
            _userName(),
            _passwordField(),
          ],
        ),
      );

  Future<void> showResetPasswordModal() async => showModalSheet(
        ctx: context,
        topPadding: 30,
        bottomPadding: 20,
        leftPadding: 30,
        rightPadding: 30,
        children: [
          Text(
            'Forgot Password',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Text(
            'Enter your email address associated with your sasae account. We\'ll send you a link to your email for password reset process.',
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface,
              // fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          FormBuilder(
            key: _passwordResetFormKey,
            child: FormBuilderTextField(
              name: 'passwordReset',
              controller: _resetEmailTEC,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.email_rounded),
                labelText: 'Email',
                hintText: 'xyz@email.com',
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                FormBuilderValidators.email(),
              ]),
              keyboardType: TextInputType.emailAddress,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ConstrainedBox(
            constraints: const BoxConstraints.tightFor(
                height: 60, width: double.infinity),
            child: ElevatedButton(
              onPressed: () async {
                if (!isInternetConnected(context)) return;
                final isValid = _passwordResetFormKey.currentState!.validate();
                if (isValid) {
                  Navigator.of(context).pop();
                  bool success =
                      await Provider.of<AuthProvider>(context, listen: false)
                          .resetPassword(_resetEmailTEC.text);
                  _resetEmailTEC.clear();
                  if (success) {
                    showSnackBar(
                      context: context,
                      message: 'Password reset email sent',
                    );
                  } else {
                    showSnackBar(
                      context: context,
                      errorSnackBar: true,
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
              ),
              child: const Text(
                'Request reset link',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return AnnotatedScaffold(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: [
                Column(
                  children: <Widget>[
                    SizedBox(height: height * 0.17),
                    _logo(),
                    SizedBox(height: height * 0.04),
                    _loginForm(),
                    SizedBox(height: height * 0.026),
                    Row(
                      children: [
                        Expanded(
                          flex: 10,
                          child: _forgetButton(),
                        ),
                        const Spacer(
                          flex: 1,
                        ),
                        Expanded(
                          flex: 6,
                          child: _loginButton(),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                  child: _createAccountLabel(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
