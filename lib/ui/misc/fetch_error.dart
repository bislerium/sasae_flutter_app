import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  final double fraction;
  final IconData errorIcon;

  const ErrorView({
    Key? key,
    this.fraction = 0.875,
    this.errorIcon = Icons.link_off_rounded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * fraction,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                errorIcon,
                size: 60,
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
