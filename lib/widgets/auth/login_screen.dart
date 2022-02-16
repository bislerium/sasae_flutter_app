import 'package:flutter/material.dart';
import 'package:sasae_flutter_app/main.dart';
import 'package:sasae_flutter_app/widgets/auth/register_screen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final passwordResetFormKey = GlobalKey<FormState>();
  var userIDField = TextEditingController();
  var passwordField = TextEditingController();
  var resetEmailField = TextEditingController();

  @override
  void dispose() {
    userIDField.dispose();
    passwordField.dispose();
    resetEmailField.dispose();
    super.dispose();
  }

  Widget _userIDField() => TextFormField(
        controller: userIDField,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.account_circle_rounded,
            color: Theme.of(context).primaryColor,
          ),
          labelText: 'Username',
          // floatingLabelBehavior: FloatingLabelBehavior.never,
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Enter your username!';
          } else if (value.contains(' ')) {
            return 'Username must be spaceless!';
          } else {
            return null;
          }
        },
        maxLength: 10,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.text,
      );

  Widget _passwordField() => TextFormField(
        controller: passwordField,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.password_rounded,
            color: Theme.of(context).primaryColor,
          ),
          labelText: 'Password',
          // floatingLabelBehavior: FloatingLabelBehavior.never,
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Enter the password!';
          } else {
            return null;
          }
        },
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
      );

  Widget _loginButton() => Builder(builder: (context) {
        return ElevatedButton(
          child: const Icon(
            Icons.navigate_next_rounded,
            size: 45,
          ),
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            primary: Theme.of(context).primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          ),
          onPressed: () {
            final isValid = formKey.currentState!.validate();
            FocusScope.of(context).unfocus();
            if (isValid) {
              var userID = userIDField.text;
              var password = passwordField.text;
              if (userID == 'user' && password == 'user') {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    HomePage.routeName, (Route<dynamic> route) => false);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Wrong User ID or Password!',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          },
        );
      });

  Widget _forgetButton() => Builder(builder: (context) {
        return TextButton(
          child: const Text(
            'Forget Password?',
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
              style: const TextStyle(
                color: Colors.black,
              ),
              children: [
                TextSpan(
                  text: 'Register',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
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
            height: 100,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            'Sasae',
            style: TextStyle(
              color: Theme.of(context).primaryColorDark,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );

  Widget _loginForm() => Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            _userIDField(),
            const SizedBox(
              height: 2,
            ),
            _passwordField(),
          ],
        ),
      );

  void showResetPasswordModal(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      isScrollControlled: true,
      context: context,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(_).viewInsets.bottom,
          ),
          child: Container(
            margin: const EdgeInsets.fromLTRB(40, 30, 40, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Forgot Password',
                  style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                const Text(
                  'Enter your email address associated with your sasae account. We\'ll send you a link to your email for password reset process.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 14, color: Colors.black54,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                  key: passwordResetFormKey,
                  child: TextFormField(
                    controller: resetEmailField,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email_rounded),
                      labelText: 'Email',
                      hintText: 'xyz@email.com',
                      // floatingLabelBehavior: FloatingLabelBehavior.never,
                    ),
                    validator: (value) {
                      const pattern =
                          r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)';
                      final regExp = RegExp(pattern);
                      if (value!.isEmpty) {
                        return 'Enter an email!';
                      } else if (!regExp.hasMatch(value)) {
                        return 'Enter a valid email!';
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints.tightFor(
                      height: 50, width: double.infinity),
                  child: ElevatedButton(
                    child: const Text(
                      'Request reset link',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    onPressed: () {
                      final isValid =
                          passwordResetFormKey.currentState!.validate();

                      if (isValid) {
                        var email = resetEmailField.text;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Password reset email sent, Check your inbox!',
                              // style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            backgroundColor: Colors.blue,
                          ),
                        );
                        resetEmailField.clear();
                        Navigator.of(_).pop();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
    );
  }

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
