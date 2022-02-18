import 'package:flutter/material.dart';

class VerifiedChip extends StatelessWidget {
  final bool isVerified;

  const VerifiedChip({Key? key, required this.isVerified}) : super(key: key);

  @override
  Widget build(BuildContext context) => Chip(
        backgroundColor: isVerified
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.error,
        avatar: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Icon(
            isVerified ? Icons.verified : Icons.new_releases,
            color: isVerified
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onError,
          ),
        ),
        label: Text(
          isVerified ? 'Verified' : 'Unverified',
          style: TextStyle(
            color: isVerified
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onError,
          ),
        ),
      );
}
