import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/auth_provider.dart';
import 'package:sasae_flutter_app/widgets/auth/register_screen.dart';
import 'package:sasae_flutter_app/widgets/home_page.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_widgets.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth';
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<FormBuilderState> _loginFormKey;
  final GlobalKey<FormBuilderState> _passwordResetFormKey;
  final TextEditingController _userNameTEC;
  final TextEditingController _passwordTEC;
  final TextEditingController _resetEmailTEC;

  _AuthScreenState()
      : _loginFormKey = GlobalKey<FormBuilderState>(),
        _passwordResetFormKey = GlobalKey<FormBuilderState>(),
        _userNameTEC = TextEditingController(),
        _passwordTEC = TextEditingController(),
        _resetEmailTEC = TextEditingController();

  @override
  void dispose() {
    _userNameTEC.dispose();
    _passwordTEC.dispose();
    _resetEmailTEC.dispose();
    super.dispose();
  }

  Widget _userName() => FormBuilderTextField(
        name: 'userName',
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
            FormBuilderValidators.required(context),
            (value) =>
                value!.contains(' ') ? 'Username must be spaceless!' : null,
          ],
        ),
        maxLength: 10,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.text,
      );

  Widget _passwordField() => FormBuilderTextField(
        name: 'password',
        controller: _passwordTEC,
        decoration: InputDecoration(
          iconColor: Theme.of(context).colorScheme.secondary,
          prefixIcon: const Icon(
            Icons.password_rounded,
          ),
          labelText: 'Password',
        ),
        validator: FormBuilderValidators.compose(
          [
            FormBuilderValidators.required(context),
          ],
        ),
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
      );

  Widget _loginButton() => Consumer<AuthProvider>(
        builder: ((context, authP, child) => ElevatedButton(
              child: authP.isAuthenticating
                  ? const Padding(
                      padding: EdgeInsets.all(7.0),
                      child: CircularProgressIndicator(),
                    )
                  : Icon(
                      Icons.navigate_next_rounded,
                      size: 50,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                primary: Theme.of(context).colorScheme.secondaryContainer,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              ),
              onPressed: () async {
                final isValid = _loginFormKey.currentState!.validate();
                FocusScope.of(context).unfocus();
                if (isValid) {
                  await authP.login(
                    username: _userNameTEC.text,
                    password: _passwordTEC.text,
                  );
                  if (authP.isAuth) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        HomePage.routeName, (Route<dynamic> route) => false);
                  } else {
                    showSnackBar(
                      context: context,
                      message: 'Unable to login!',
                      errorSnackBar: true,
                    );
                  }
                }
              },
            )),
      );

  Widget _forgetButton() => Builder(builder: (context) {
        return TextButton(
          child: Text(
            'Forget Password?',
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          ),
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          ),
          onPressed: () => showResetPasswordModal(context),
        );
      });

  Widget _createAccountLabel() => InkWell(
        splashColor: Theme.of(context).primaryColorLight,
        onTap: () {
          Navigator.of(context).pushNamed(
            RegisterScreen.routeName,
          );
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          padding: const EdgeInsets.all(10),
          width: double.infinity,
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: 'Don\'t have an account?  ',
              style: TextStyle(
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
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 20,
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
            const SizedBox(
              height: 2,
            ),
            _passwordField(),
          ],
        ),
      );

  void showResetPasswordModal(BuildContext ctx) => showModalSheet(
        ctx: ctx,
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
                FormBuilderValidators.required(context),
                FormBuilderValidators.email(context),
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
              child: const Text(
                'Request reset link',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              onPressed: () async {
                final isValid = _passwordResetFormKey.currentState!.validate();
                if (isValid) {
                  bool success =
                      await Provider.of<AuthProvider>(context, listen: false)
                          .resetPassword(_resetEmailTEC.text);
                  if (success) {
                    showSnackBar(
                      context: ctx,
                      message: 'Password reset email sent, Check your inbox!',
                    );
                    _resetEmailTEC.clear();
                    Navigator.of(ctx).pop();
                  } else {
                    showSnackBar(
                      context: ctx,
                      message: 'Something went wrong!',
                      errorSnackBar: true,
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
              ),
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: height * 0.20),
              _logo(),
              const SizedBox(height: 50),
              _loginForm(),
              const SizedBox(height: 20),
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
              SizedBox(height: height * 0.16),
              _createAccountLabel(),
            ],
          ),
        ),
      ),
    );
  }
}
