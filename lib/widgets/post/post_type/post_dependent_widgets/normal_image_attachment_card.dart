import 'package:flutter/material.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_card.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_image.dart';

class NormalImageAttachmentCard extends StatelessWidget {
  final String imageURL;

  const NormalImageAttachmentCard({Key? key, required this.imageURL})
      : super(key: key);

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
              'Image Attachment:',
              style: Theme.of(context).textTheme.headline6?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(
              height: 15,
            ),
            CustomImage(
              imageURL: imageURL,
              title: 'View Attached Image',
              onTapViewImage: true,
              aspectRatio: 1 / 1,
              radius: 10,
              includeHero: true,
            ),
          ],
        ),
      ),
    );
  }
}
