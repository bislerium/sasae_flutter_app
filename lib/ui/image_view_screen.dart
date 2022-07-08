import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_appbar.dart';

class ImageViewScreen extends StatelessWidget {
  static const String routeName = '/image/view';
  final String imageURL;
  final String title;

  const ImageViewScreen(
      {Key? key, this.title = 'View Image', required this.imageURL})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: title),
      body: PhotoView(
        key: ValueKey(imageURL),
        imageProvider: NetworkImage(imageURL),
        heroAttributes: PhotoViewHeroAttributes(tag: imageURL),
        backgroundDecoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
        ),
        enableRotation: true,
      ),
    );
  }
}
