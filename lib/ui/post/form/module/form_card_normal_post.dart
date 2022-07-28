import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/models/post/post_create_update.dart';
import 'package:sasae_flutter_app/providers/post_provider.dart';
import 'package:sasae_flutter_app/ui/misc/custom_card.dart';

class FormCardNormalPost extends StatefulWidget {
  final bool isUpdateMode;
  final GlobalKey<FormBuilderState> formKey;

  const FormCardNormalPost(
      {Key? key, required this.formKey, this.isUpdateMode = false})
      : super(key: key);

  @override
  State<FormCardNormalPost> createState() => _FormCardNormalPostState();
}

class _FormCardNormalPostState extends State<FormCardNormalPost>
    with AutomaticKeepAliveClientMixin {
  late final NormalPostCUModel _normalPostCU;

  @override
  void initState() {
    super.initState();
    if (widget.isUpdateMode) {
      _normalPostCU = Provider.of<PostUpdateProvider>(context, listen: false)
          .getNormalPostCU!;
    } else {
      _normalPostCU = Provider.of<PostCreateProvider>(context, listen: false)
          .getNormalPostCreate;
    }
  }

  @override
  void dispose() {
    if (!widget.isUpdateMode) {
      _normalPostCU.nullifyNormal();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double width = MediaQuery.of(context).size.width - 60;
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Normal Post',
              style: Theme.of(context).textTheme.headline6?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(
              height: 15,
            ),
            FormBuilder(
              key: widget.formKey,
              child: FormBuilderImagePicker(
                name: 'photos',
                decoration: const InputDecoration(
                  labelText: 'Attach a photo',
                  border: InputBorder.none,
                ),
                initialValue:
                    widget.isUpdateMode ? [_normalPostCU.getPostImage] : null,
                previewWidth: width,
                previewHeight: width,
                maxImages: 1,
                iconColor: Theme.of(context).colorScheme.secondaryContainer,
                onSaved: (list) => list == null || list.isEmpty
                    ? _normalPostCU.setPostImage = null
                    : _normalPostCU.setPostImage = list.first,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
