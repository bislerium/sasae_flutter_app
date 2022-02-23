import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_card.dart';

import '../../../misc/custom_widgets.dart';

class PostTailCard extends StatelessWidget {
  final int postID;
  final DateTime createdOn;

  const PostTailCard({Key? key, required this.postID, required this.createdOn})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      margin: EdgeInsets.zero,
      borderRadius: 30,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
        child: Row(
          children: [
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
                onPressed: () {
                  showCustomDialog(
                    context: context,
                    title: 'Report',
                    content: 'Are you Sure?',
                    okFunc: () {},
                  );
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
    );
  }
}
