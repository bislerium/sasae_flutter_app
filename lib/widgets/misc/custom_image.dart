import 'package:flutter/material.dart';
import 'package:sasae_flutter_app/widgets/image_view_screen.dart';

class CustomImage extends StatelessWidget {
  final String imageURL;
  final double? width;
  final double? height;
  final String title;
  final double aspectRatio;
  final double radius;
  final bool onTapViewImage;
  final bool includeHero;

  const CustomImage({
    Key? key,
    required this.imageURL,
    this.height,
    this.width,
    this.title = 'View Image',
    this.aspectRatio = 1 / 1,
    this.radius = 40,
    this.onTapViewImage = true,
    this.includeHero = true,
  }) : super(key: key);

  Widget imageFromURL() => Image.network(
        imageURL,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) =>
            loadingProgress == null ? child : const LinearProgressIndicator(),
      );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: GestureDetector(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: AspectRatio(
            aspectRatio: aspectRatio,
            child: includeHero
                ? Hero(tag: imageURL, child: imageFromURL())
                : imageFromURL(),
          ),
        ),
        onTap: onTapViewImage
            ? () => Navigator.pushNamed(context, ImageViewScreen.routeName,
                arguments: {'title': title, 'imageURL': imageURL})
            : null,
      ),
    );
  }
}