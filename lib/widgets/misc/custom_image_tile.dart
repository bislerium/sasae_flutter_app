import 'package:flutter/material.dart';
import 'package:sasae_flutter_app/ui/image_view_screen.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_image.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_material_tile.dart';

class CustomImageTile extends StatelessWidget {
  final String title;
  final String imageURL;

  const CustomImageTile({
    Key? key,
    required this.title,
    required this.imageURL,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomMaterialTile(
        borderRadius: 12,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              CustomImage(
                imageURL: imageURL,
                onTapViewImage: false,
                aspectRatio: 6 / 4,
                radius: 10,
                includeHero: true,
              ),
            ],
          ),
        ),
        func: () => Navigator.pushNamed(context, ImageViewScreen.routeName,
            arguments: {'title': title, 'imageURL': imageURL}));
  }
}
