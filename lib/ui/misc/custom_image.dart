import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sasae_flutter_app/image_view_screen.dart';
import 'package:sasae_flutter_app/ui/misc/splash_over.dart';

class CustomImage extends StatelessWidget {
  final String imageURL;
  final double? width;
  final double? height;
  final double loadingSize;
  final String title;
  final double aspectRatio;
  final BorderRadius? borderRadius;
  final bool onTapViewImage;
  final bool includeHero;

  const CustomImage({
    Key? key,
    required this.imageURL,
    this.height,
    this.width,
    this.loadingSize = 100,
    this.title = 'View Image',
    this.aspectRatio = 1 / 1,
    this.borderRadius,
    this.onTapViewImage = true,
    this.includeHero = true,
  }) : super(key: key);

  Widget imageFromURL() => CachedNetworkImage(
        imageUrl: imageURL,
        fit: BoxFit.cover,
        placeholder: (context, url) => Center(
          child: LoadingAnimationWidget.bouncingBall(
            color: Theme.of(context).colorScheme.primary,
            size: width == null ? loadingSize : width! * 0.5,
          ),
        ),
        errorWidget: (context, url, error) =>
            const Icon(Icons.broken_image_rounded),
      );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: SplashOver(
        onTap: onTapViewImage
            ? () => Navigator.pushNamed(context, ImageViewScreen.routeName,
                arguments: {'title': title, 'imageURL': imageURL})
            : null,
        borderRadius: borderRadius,
        child: ClipRRect(
          borderRadius: borderRadius ?? BorderRadius.circular(12),
          child: AspectRatio(
            aspectRatio: aspectRatio,
            child: includeHero
                ? Hero(tag: imageURL, child: imageFromURL())
                : imageFromURL(),
          ),
        ),
      ),
    );
  }
}
