import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_card.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_image_picker.dart';

class FormCardNormalPost extends StatefulWidget {
  const FormCardNormalPost({Key? key}) : super(key: key);

  static _FormCardNormalPostState? of(BuildContext context) =>
      context.findAncestorStateOfType<_FormCardNormalPostState>();

  @override
  _FormCardNormalPostState createState() => _FormCardNormalPostState();
}

class _FormCardNormalPostState extends State<FormCardNormalPost> {
  File? _image;

  void getImage() => _image;

  @override
  void dispose() {
    super.dispose();
  }

  void setFile(File? file) => setState(() {
        _image = file;
      });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              CustomImagePicker(
                title: 'Attach an Image',
                icon: Icons.image_rounded,
                setImageFileHandler: (file) => setFile(file),
              ),
              const SizedBox(
                height: 20,
              ),
              if (_image != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    _image!,
                    width: double.infinity,
                  ),
                ),
            ],
          )),
    );
  }
}
