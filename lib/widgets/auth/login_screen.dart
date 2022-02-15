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
  var userIDField = TextEditingController();
  var passwordField = TextEditingController();

  @override
  void dispose() {
    userIDField.dispose();
    passwordField.dispose();
    super.dispose();
  }

  Widget _userIDField() => TextFormField(
        controller: userIDField,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.account_circle_outlined,
            color: Theme.of(context).primaryColor,
          ),
          labelText: 'User ID',
          floatingLabelBehavior: FloatingLabelBehavior.never,
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'User ID is required!';
          } else if (int.tryParse(value) == null) {
            return 'User ID must be Numeric!';
          } else {
            return null;
          }
        },
        maxLength: 10,
        keyboardType: TextInputType.number,
      );

  Widget _passwordField() => TextFormField(
        controller: passwordField,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.password,
            color: Theme.of(context).primaryColor,
          ),
          labelText: 'Password',
          floatingLabelBehavior: FloatingLabelBehavior.never,
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Password is required!';
          } else {
            return null;
          }
        },
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
      );

  Widget _loginButton() => Builder(builder: (context) {
        return ElevatedButton.icon(
          icon: const Icon(Icons.login),
          label: const Text(
            'Login',
          ),
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            primary: Theme.of(context).primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          ),
          onPressed: () {
            final isValid = formKey.currentState!.validate();
            FocusScope.of(context).unfocus();
            if (isValid) {
              var userID = userIDField.text;
              var password = passwordField.text;
              if (userID == '12345' && password == 'admin') {
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
                    backgroundColor: Colors.redAccent,
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
          onPressed: () {},
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
              height: 10,
            ),
            _passwordField(),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: height * 0.2),
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
                    flex: 10,
                    child: _loginButton(),
                  ),
                ],
              ),
              SizedBox(height: height * 0.18),
              _createAccountLabel(),
            ],
          ),
        ),
      ),
    );
  }
}
