import 'package:flutter/material.dart';

class WrappedChips extends StatelessWidget {
  final List<String> list;
  final bool center;
  const WrappedChips({
    Key? key,
    required this.list,
    this.center = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Wrap(
        alignment: center ? WrapAlignment.center : WrapAlignment.start,
        spacing: 8,
        runSpacing: -5,
        children: list
            .map(
              (e) => Chip(
                label: Text(
                  e,
                  style: Theme.of(context).textTheme.subtitle1?.copyWith(
                      color:
                          Theme.of(context).colorScheme.onSecondaryContainer),
                ),
                backgroundColor:
                    Theme.of(context).colorScheme.secondaryContainer,
              ),
            )
            .toList(),
      );
}
