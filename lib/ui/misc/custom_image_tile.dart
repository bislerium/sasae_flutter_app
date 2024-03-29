import 'package:flutter/material.dart';
import 'package:sasae_flutter_app/ui/misc/custom_image.dart';
import 'package:sasae_flutter_app/ui/misc/custom_material_tile.dart';

class CustomImageTile extends StatelessWidget {
  final String title;
  final String imageURL;
  final bool isImageVerified;

  const CustomImageTile({
    Key? key,
    required this.title,
    required this.imageURL,
    this.isImageVerified = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomMaterialTile(
      borderRadius: 12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                if (!isImageVerified)
                  Tooltip(
                    message: 'Verification pending',
                    child: Icon(
                      Icons.pending_rounded,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
          CustomImage(
            imageURL: imageURL,
            onTapViewImage: true,
            aspectRatio: 6 / 4,
            borderRadius:
                const BorderRadius.vertical(bottom: Radius.circular(12)),
            includeHero: true,
          ),
        ],
      ),
    );
  }
}
