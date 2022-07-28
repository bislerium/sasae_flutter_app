import 'package:flutter/material.dart';

class VerifiedChip extends StatelessWidget {
  final bool isVerified;

  const VerifiedChip({Key? key, required this.isVerified}) : super(key: key);

  @override
  Widget build(BuildContext context) => Chip(
        backgroundColor: isVerified
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.error,
        avatar: Icon(
          isVerified ? Icons.verified : Icons.question_mark_rounded,
          color: isVerified
              ? Theme.of(context).colorScheme.onPrimary
              : Theme.of(context).colorScheme.onError,
        ),
        label: Text(
          isVerified ? 'Verified' : 'Unverified',
          style: Theme.of(context).textTheme.subtitle1?.copyWith(
                color: isVerified
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onError,
              ),
        ),
      );
}
