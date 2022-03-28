import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/post_provider.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/post_dependent_widgets/form_card_poll_post.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/post_dependent_widgets/form_card_request_post.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/post_dependent_widgets/post_photo_upload.dart';

class PostFormPerPostType extends StatelessWidget {
  final GlobalKey<FormBuilderState> pollFormKey;
  final GlobalKey<FormBuilderState> requestFormKey;
  const PostFormPerPostType(
      {Key? key, required this.pollFormKey, required this.requestFormKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (Provider.of<PostCreateProvider>(context).getCreatePostType) {
      case PostType.normalPost:
        return const PostPhotoUpload();
      case PostType.pollPost:
        return FormCardPollPost(formKey: pollFormKey);
      case PostType.requestPost:
        return FormCardRequestPost(
          formKey: requestFormKey,
        );
    }
    return const SizedBox.shrink();
  }
}
