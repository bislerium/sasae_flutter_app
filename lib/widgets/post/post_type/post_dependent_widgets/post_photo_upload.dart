import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/post_provider.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_card.dart';

class PostPhotoUpload extends StatelessWidget {
  final GlobalKey<FormBuilderState> formKey;

  const PostPhotoUpload({Key? key, required this.formKey}) : super(key: key);

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
            FormBuilder(
              key: formKey,
              child: FormBuilderImagePicker(
                  name: 'photos',
                  decoration: const InputDecoration(
                    labelText: 'Attach a photo',
                    border: InputBorder.none,
                  ),
                  previewWidth: width,
                  previewHeight: width,
                  maxImages: 1,
                  onSaved: (list) =>
                      Provider.of<PostCreateProvider>(context, listen: false)
                          .getNormalPostCreate
                          .setPostImage = list?.first),
            ),
          ],
        ),
      ),
    );
  }
}
