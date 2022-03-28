import 'package:flutter/material.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_card.dart';

class PostPhotoUpload extends StatelessWidget {
  const PostPhotoUpload({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 60;
    return CustomCard(
      child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Normal post',
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              const SizedBox(
                height: 15,
              ),
              FormBuilderImagePicker(
                name: 'photos',
                decoration: const InputDecoration(
                  labelText: 'Attach a photo',
                  border: InputBorder.none,
                ),
                previewWidth: width,
                previewHeight: width,
                maxImages: 1,
              ),
            ],
          )),
    );
  }
}
