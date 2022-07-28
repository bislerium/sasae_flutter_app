import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  final double fraction;
  final String errorMessage;

  const ErrorView({
    Key? key,
    this.fraction = 0.84,
    this.errorMessage = 'Something went wrong 😞...',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * fraction,
          child: Center(
            child: Text(errorMessage),
          ),
        ),
      ],
    );
  }
}
