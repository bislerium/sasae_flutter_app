import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/post_provider.dart';
import 'package:sasae_flutter_app/services/utilities.dart';
import 'package:sasae_flutter_app/ui/misc/custom_card.dart';
import 'package:sasae_flutter_app/ui/misc/custom_widgets.dart';

class PostTailCard extends StatelessWidget {
  final int postID;
  final DateTime createdOn;
  final DateTime? modifiedOn;
  final bool isReportButtonVisible;

  const PostTailCard({
    Key? key,
    required this.postID,
    required this.createdOn,
    this.modifiedOn,
    this.isReportButtonVisible = true,
  }) : super(key: key);

  void showDialog(BuildContext context) => showCustomDialog(
        context: context,
        title: 'Confirm Report',
        content:
            'Think wise & avoid unnecessary report just for personal annoyance & grudge!, ',
        okFunc: () async {
          Navigator.of(context).pop();
          if (!isInternetConnected(context)) return;
          if (!isProfileVerified(context)) return;
          bool success = await Provider.of<PostProvider>(context, listen: false)
              .report(postID: postID);
          if (success) {
            showSnackBar(
              context: context,
              message: 'Reported successfully',
            );
          } else {
            showSnackBar(
              context: context,
              errorSnackBar: true,
            );
          }
        },
      );

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      borderRadius: 30,
      cardColor: modifiedOn == null
          ? null
          : Theme.of(context).colorScheme.surfaceVariant,
      child: Tooltip(
        verticalOffset: 40,
        message: modifiedOn == null
            ? ''
            : 'Modified on: ${DateFormat.yMMMEd().format(modifiedOn!)}',
        child: SizedBox(
          height: 60,
          child: Row(
            children: [
              const SizedBox(
                width: 20,
              ),
              Icon(
                Icons.post_add,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  DateFormat.yMMMEd().format(createdOn),
                  style: Theme.of(context).textTheme.subtitle1?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              if (isReportButtonVisible)
                ConstrainedBox(
                  constraints: const BoxConstraints.tightFor(
                    height: 60,
                    width: 140,
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (!isInternetConnected(context)) return;
                      if (!isProfileVerified(context)) return;
                      showDialog(context);
                    },
                    icon: const Icon(Icons.report_outlined),
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).colorScheme.error,
                      onPrimary: Theme.of(context).colorScheme.onError,
                      shape: const StadiumBorder(),
                    ),
                    label: const Text(
                      'Report',
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
