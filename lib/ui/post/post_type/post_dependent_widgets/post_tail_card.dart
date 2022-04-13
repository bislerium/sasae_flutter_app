import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/post_provider.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_card.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_widgets.dart';

class PostTailCard extends StatelessWidget {
  final int postID;
  final DateTime createdOn;
  final DateTime? modifiedOn;

  const PostTailCard(
      {Key? key,
      required this.postID,
      required this.createdOn,
      this.modifiedOn})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      margin: EdgeInsets.zero,
      borderRadius: 30,
      cardColor: modifiedOn == null
          ? null
          : Theme.of(context).colorScheme.surfaceVariant,
      child: Tooltip(
        verticalOffset: 40,
        message: modifiedOn == null
            ? ''
            : 'Modified on: ${DateFormat.yMMMEd().format(modifiedOn!)}',
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
            ConstrainedBox(
              constraints: const BoxConstraints.tightFor(
                height: 60,
                width: 140,
              ),
              child: ElevatedButton.icon(
                onPressed: () => showCustomDialog(
                  context: context,
                  title: 'Report',
                  content: 'Are you Sure?',
                  okFunc: () async {
                    Navigator.of(context).pop();
                    bool success =
                        await Provider.of<PostProvider>(context, listen: false)
                            .report(postID: postID);
                    if (success) {
                      showSnackBar(
                        context: context,
                        message: 'Reported successfully.',
                      );
                    } else {
                      showSnackBar(
                        context: context,
                        message: 'Unsuccessful report, Something went wrong!',
                        errorSnackBar: true,
                      );
                    }
                  },
                ),
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
    );
  }
}
