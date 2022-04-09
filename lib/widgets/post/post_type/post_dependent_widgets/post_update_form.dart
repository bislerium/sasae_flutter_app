import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_chips_input/flutter_chips_input.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:sasae_flutter_app/models/post/ngo__.dart';
import 'package:sasae_flutter_app/providers/post_provider.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_card.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_widgets.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/post_dependent_widgets/form_card_poll_post.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/post_dependent_widgets/form_card_request_post.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/post_dependent_widgets/form_card_normal_post.dart';

class PostUpdateForm extends StatefulWidget {
  static const routeName = '/post/form';
  final List<NGO__> snapshotNGOList;
  final List<String> snapshotRelatedList;
  final ScrollController? scrollController;

  const PostUpdateForm(
      {Key? key,
      required this.snapshotNGOList,
      required this.snapshotRelatedList,
      this.scrollController})
      : super(key: key);

  @override
  _PostUpdateFormState createState() => _PostUpdateFormState();
}

class _PostUpdateFormState extends State<PostUpdateForm> {
  late dynamic _postHead;

  final GlobalKey<FormBuilderState> _superPostKey,
      _requestFormKey,
      _pollFormKey,
      _normalFormKey;
  late final PostUpdateProvider _postUpdateP;
  final GlobalKey<ChipsInputState> _chipKey;
  List<int>? pokedNGO;

  _PostUpdateFormState()
      : _superPostKey = GlobalKey<FormBuilderState>(),
        _normalFormKey = GlobalKey<FormBuilderState>(),
        _requestFormKey = GlobalKey<FormBuilderState>(),
        _pollFormKey = GlobalKey<FormBuilderState>(),
        _chipKey = GlobalKey<ChipsInputState>();

  @override
  void initState() {
    super.initState();
    _postUpdateP = Provider.of<PostUpdateProvider>(context, listen: false);
    switch (_postUpdateP.getUpdatePostType!) {
      case PostType.normal:
        _postHead = _postUpdateP.getNormalPostCU!;
        break;
      case PostType.poll:
        _postHead = _postUpdateP.getPollPostCU!;
        break;
      case PostType.request:
        _postHead = _postUpdateP.getRequestPostCU!;
        break;
    }
    WidgetsBinding.instance!
        .addPostFrameCallback((_) => setPostUpdateOnPressed());
  }

  void setPostUpdateOnPressed() {
    Provider.of<PostUpdateProvider>(context, listen: false).setPostHandler =
        postHandler;
  }

  Future<void> postHandler() async {
    bool isOtherPostFormValid = false;
    bool success = false;
    var postUpdateP = Provider.of<PostUpdateProvider>(context, listen: false);
    var postType = postUpdateP.getUpdatePostType;
    bool isSuperPostFormValid = _superPostKey.currentState!.validate();
    switch (postType!) {
      case PostType.normal:
        isOtherPostFormValid = _normalFormKey.currentState!.validate();
        if (isOtherPostFormValid) _normalFormKey.currentState!.save();
        break;
      case PostType.poll:
        isOtherPostFormValid = _pollFormKey.currentState!.validate();
        if (isOtherPostFormValid) _pollFormKey.currentState!.save();
        break;
      case PostType.request:
        isOtherPostFormValid = _requestFormKey.currentState!.validate();
        if (isOtherPostFormValid) _requestFormKey.currentState!.save();
        break;
    }
    if (isSuperPostFormValid && isOtherPostFormValid) {
      _superPostKey.currentState!.save();
      success = await postUpdateP.updatePost(
          postID: _postHead.getPostID, postType: postType);
      if (success) {
        showSnackBar(context: context, message: 'Successfully posted.');
        Navigator.of(context).pop();
      } else {
        showSnackBar(
            context: context,
            message: 'Something went wrong.',
            errorSnackBar: true);
      }
    }
  }

  Widget relatedToField() => FormBuilderFilterChip(
        name: 'filterChip',
        maxChips: 10,
        decoration: const InputDecoration(
            labelText: 'Related to', hintText: 'What\'s your post related to?'),
        options: widget.snapshotRelatedList
            .map((e) => FormBuilderFieldOption(value: e, child: Text(e)))
            .toList(),
        spacing: 10,
        runSpacing: -5,
        selectedColor: Theme.of(context).colorScheme.primaryContainer,
        labelStyle: TextStyle(
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
        initialValue: _postHead.getRelatedTo!,
        validator: (value) =>
            value!.isEmpty ? 'Select what\'s your post related to.' : null,
        onSaved: (value) {
          var _ = value!.cast<String>();
          _postHead.setRelatedTo = _;
        },
      );

  Widget pokeNGOField() => ChipsInput(
        key: _chipKey,
        decoration: const InputDecoration(labelText: 'Poke NGO'),
        chipBuilder: (context, state, data) {
          return InputChip(
            key: ObjectKey(data),
            label: Text(
              (data as NGO__).orgName,
              overflow: TextOverflow.fade,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            onDeleted: () => state.deleteChip(data),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          );
        },
        initialValue: _postHead.getPokedNGO!
            .map<NGO__>((e) =>
                widget.snapshotNGOList.firstWhere((element) => element.id == e))
            .toList(),
        findSuggestions: (String query) {
          List<NGO__> tempList = [];
          if (pokedNGO == null || pokedNGO!.isEmpty) {
            tempList = widget.snapshotNGOList;
          } else {
            tempList = widget.snapshotNGOList
                .where((element) => !pokedNGO!.contains(element.id))
                .toList();
          }
          if (query.isEmpty) return tempList;
          return tempList
              .where((element) =>
                  element.orgName.toLowerCase().contains(query.toLowerCase()))
              .toList();
        },
        suggestionBuilder: (context, state, data) {
          data = data as NGO__;
          return ListTile(
            key: ObjectKey(data),
            leading: ClipOval(
              child: Image.network(
                data.orgPhoto,
                height: 40,
                width: 40,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(data.orgName),
            onTap: () => state.selectSuggestion(data),
          );
        },
        onChanged: (value) {
          var _ = (value as List<NGO__>).map((e) => e.id).toList();
          _postHead.setPokedNGO = _;
        },
        inputType: TextInputType.name,
      );

  Widget postContentField() => FormBuilderTextField(
        name: 'postContent',
        decoration: const InputDecoration(
          label: Text('Description'),
          hintText: "What's your post about?",
          alignLabelWithHint: true,
        ),
        validator: FormBuilderValidators.compose(
          [
            FormBuilderValidators.required(context),
          ],
        ),
        initialValue: _postHead.getPostContent,
        maxLength: 500,
        maxLines: 6,
        keyboardType: TextInputType.multiline,
        onSaved: (value) {
          _postHead.setPostContent = value;
        },
        textInputAction: TextInputAction.next,
      );

  Widget anonymousField() => FormBuilderSwitch(
        name: 'anonymous',
        initialValue: _postHead.getIsAnonymous!,
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),
        activeColor: Theme.of(context).colorScheme.primary,
        title: const Text('Post anonymously'),
        onSaved: (value) {
          var _ = value;
          _postHead.setIsAnonymous = value;
        },
      );

  Widget superPostFields() => CustomCard(
        child: FormBuilder(
          key: _superPostKey,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                relatedToField(),
                const SizedBox(
                  height: 10,
                ),
                postContentField(),
                const SizedBox(
                  height: 10,
                ),
                pokeNGOField(),
                const SizedBox(
                  height: 10,
                ),
                anonymousField(),
              ],
            ),
          ),
        ),
      );

  Widget getExtension() {
    switch (_postUpdateP.getUpdatePostType!) {
      case PostType.normal:
        return FormCardNormalPost(
          formKey: _normalFormKey,
          isUpdateMode: true,
        );
      case PostType.poll:
        return FormCardPollPost(
          formKey: _pollFormKey,
          isUpdateMode: true,
        );
      case PostType.request:
        return FormCardRequestPost(
          formKey: _requestFormKey,
          isUpdateMode: true,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: widget.scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      children: [
        superPostFields(),
        const SizedBox(
          height: 10,
        ),
        getExtension(),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
