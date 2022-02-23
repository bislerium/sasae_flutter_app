import 'package:flutter/material.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_card.dart';

class PostContentCard extends StatelessWidget {
  final String content;

  const PostContentCard({Key? key, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Content:',
              style: Theme.of(context).textTheme.headline6?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              content,
              style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
