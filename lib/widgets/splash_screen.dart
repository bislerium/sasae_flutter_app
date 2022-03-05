import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: height * 0.45,
            width: double.infinity,
          ),
          Image.asset(
            'assets/images/logo.png',
            height: 140,
          ),
          const Expanded(child: SizedBox()),
          Text(
            'Sasae',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            'Social Service Application',
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              // fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          SizedBox(
            height: height * 0.06,
          ),
        ],
      ),
      bottomNavigationBar: const LinearProgressIndicator(
        minHeight: 4,
      ),
    );
  }
}
