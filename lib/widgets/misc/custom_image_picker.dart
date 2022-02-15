import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CustomImagePicker extends StatefulWidget {
  final String title;
  final IconData icon;

  const CustomImagePicker({Key? key, required this.title, required this.icon})
      : super(key: key);

  @override
  _CustomImagePickerState createState() => _CustomImagePickerState();
}

class _CustomImagePickerState extends State<CustomImagePicker> {
  final ImagePicker _picker;
  final TextEditingController imagefield;

  _CustomImagePickerState()
      : _picker = ImagePicker(),
        imagefield = TextEditingController();

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

  File? _image;

  Future pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image == null) return;
      setState(() {
        _image = File(image.path);
      });
    } on PlatformException catch (e) {
      print(e);
      print('failed to pick');
    }
  }

  void showPickImageModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              getPostModalItem(_, Icons.file_upload, 'Pick image from gallery',
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
      controller: imagefield..text = _image == null ? '' : _image!.path,
      decoration: InputDecoration(
        label: Text(widget.title),
        icon: Icon(widget.icon),
      ),
      readOnly: true,
      onTap: () => showPickImageModal(context),
    );
  }
}
