import 'package:flutter/material.dart';
import 'package:sasae_flutter_app/ui/misc/custom_card.dart';
import 'package:sasae_flutter_app/ui/misc/custom_image.dart';

class NormalImageAttachmentCard extends StatelessWidget {
  final String imageURL;

  const NormalImageAttachmentCard({Key? key, required this.imageURL})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              'Image Attachment:',
              style: Theme.of(context).textTheme.headline6?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ),
          CustomImage(
            imageURL: imageURL,
            title: 'View Attached Image',
            borderRadius:
                const BorderRadius.vertical(bottom: Radius.circular(12)),
            onTapViewImage: true,
            aspectRatio: 1 / 1,
            includeHero: true,
          ),
        ],
      ),
    );
  }
}
