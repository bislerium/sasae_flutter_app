import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/post_provider.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/post_dependent_widgets/form_card_poll_post.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/post_dependent_widgets/form_card_request_post.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/post_dependent_widgets/post_photo_upload.dart';

class PostFormPerPostType extends StatelessWidget {
  final GlobalKey<FormBuilderState> normalFormKey;
  final GlobalKey<FormBuilderState> pollFormKey;
  final GlobalKey<FormBuilderState> requestFormKey;
  const PostFormPerPostType(
      {Key? key,
      required this.normalFormKey,
      required this.pollFormKey,
      required this.requestFormKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (Provider.of<PostCreateProvider>(context).getCreatePostType) {
      case PostType.normal:
        return PostPhotoUpload(formKey: normalFormKey);
      case PostType.poll:
        return FormCardPollPost(formKey: pollFormKey);
      case PostType.request:
        return FormCardRequestPost(formKey: requestFormKey);
    }
  }
}
