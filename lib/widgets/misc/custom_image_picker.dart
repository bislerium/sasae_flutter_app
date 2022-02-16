import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CustomImagePicker extends StatefulWidget {
  final String title;
  final IconData icon;
  final void Function(File) setImageFileHandler;

  const CustomImagePicker(
      {Key? key,
      required this.title,
      required this.icon,
      required this.setImageFileHandler})
      : super(key: key);

  @override
  _CustomImagePickerState createState() => _CustomImagePickerState();
}

class _CustomImagePickerState extends State<CustomImagePicker> {
  final ImagePicker _picker;
  final TextEditingController imagefield;
  File? _image;

  _CustomImagePickerState()
      : _picker = ImagePicker(),
        imagefield = TextEditingController();

  @override
  void dispose() {
    imagefield.dispose();
    super.dispose();
  }

  ListTile getPostModalItem(
      BuildContext ctx, IconData icon, String title, VoidCallback func) {
    return ListTile(
      leading: Icon(
        icon,
        size: 30,
        color: Theme.of(ctx).primaryColor,
      ),
      title: Text(title),
      onTap: func,
    );
  }

  Future pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image == null) return;
      setState(() {
        _image = File(image.path);
        imagefield.text = _image!.path;
      });
      widget.setImageFileHandler(_image!);
    } on PlatformException catch (e) {
      print(e);
      print('failed to pick');
    }
  }

  void showPickImageModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              getPostModalItem(_, Icons.photo_album, 'Pick image from gallery',
                  () {
                pickImage(ImageSource.gallery);
                Navigator.pop(context);
              }),
              getPostModalItem(_, Icons.camera_alt, 'Click and pick image', () {
                pickImage(ImageSource.camera);
                Navigator.pop(context);
              }),
            ],
          ),
        );
      },
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: imagefield,
      decoration: InputDecoration(
        label: Text(widget.title),
        icon: Icon(widget.icon),
      ),
      readOnly: true,
      onTap: () => showPickImageModal(context),
    );
  }
}
