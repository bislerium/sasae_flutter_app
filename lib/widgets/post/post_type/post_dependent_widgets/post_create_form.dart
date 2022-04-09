import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_chips_input/flutter_chips_input.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:sasae_flutter_app/models/post/ngo__.dart';
import 'package:sasae_flutter_app/models/post/post_create_update.dart';
import 'package:sasae_flutter_app/providers/post_provider.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_card.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_widgets.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/post_dependent_widgets/form_card_poll_post.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/post_dependent_widgets/form_card_request_post.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/post_dependent_widgets/form_card_normal_post.dart';

class PostCreateForm extends StatefulWidget {
  static const routeName = '/post/form';
  final List<NGO__> snapshotNGOList;
  final List<String> snapshotRelatedList;

  const PostCreateForm(
      {Key? key,
      required this.snapshotNGOList,
      required this.snapshotRelatedList})
      : super(key: key);

  @override
  _PostCreateFormState createState() => _PostCreateFormState();
}

class _PostCreateFormState extends State<PostCreateForm> {
  late final NormalPostCU _normalPostCreate;
  late final PollPostCU _pollPostCreate;
  late final RequestPostCU _requestPostCreate;

  final GlobalKey<FormBuilderState> _superPostKey,
      _requestFormKey,
      _pollFormKey,
      _normalFormKey;
  final GlobalKey<ChipsInputState> _chipKey;
  List<int>? pokedNGO;

  _PostCreateFormState()
      : _superPostKey = GlobalKey<FormBuilderState>(),
        _normalFormKey = GlobalKey<FormBuilderState>(),
        _requestFormKey = GlobalKey<FormBuilderState>(),
        _pollFormKey = GlobalKey<FormBuilderState>(),
        _chipKey = GlobalKey<ChipsInputState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!
        .addPostFrameCallback((_) => setPostCreateOnPressed());
    initFormClass();
  }

  initFormClass() {
    var postCreateP = Provider.of<PostCreateProvider>(context, listen: false);
    _normalPostCreate = postCreateP.getNormalPostCreate
      ..setRelatedTo = []
      ..setPokedNGO = []
      ..setIsAnonymous = false;
    _pollPostCreate = postCreateP.getPollPostCreate
      ..setRelatedTo = []
      ..setPokedNGO = []
      ..setIsAnonymous = false;
    _requestPostCreate = postCreateP.getRequestPostCreate
      ..setRelatedTo = []
      ..setPokedNGO = []
      ..setIsAnonymous = false;
  }

  void setPostCreateOnPressed() {
    Provider.of<PostCreateProvider>(context, listen: false).setPostHandler =
        postHandler;
  }

  @override
  void dispose() {
    _normalPostCreate.nullifyAll();
    _pollPostCreate.nullifyAll();
    _requestPostCreate.nullifyAll();
    super.dispose();
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
        validator: (value) =>
            value!.isEmpty ? 'Select what\'s your post related to.' : null,
        onSaved: (value) {
          var _ = value!.cast<String>();
          _normalPostCreate.setRelatedTo = _;
          _pollPostCreate.setRelatedTo = _;
          _requestPostCreate.setRelatedTo = _;
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
          _normalPostCreate.setPokedNGO = _;
          _pollPostCreate.setPokedNGO = _;
          _requestPostCreate.setPokedNGO = _;
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
        maxLength: 500,
        maxLines: 6,
        keyboardType: TextInputType.multiline,
        onSaved: (value) {
          _normalPostCreate.setPostContent = value;
          _pollPostCreate.setPostContent = value;
          _requestPostCreate.setPostContent = value;
        },
        textInputAction: TextInputAction.next,
      );

  Widget anonymousField() => FormBuilderSwitch(
        name: 'anonymous',
        initialValue: false,
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),
        activeColor: Theme.of(context).colorScheme.primary,
        title: const Text('Post anonymously'),
        onSaved: (value) {
          var _ = value;
          _normalPostCreate.setIsAnonymous = value;
          _pollPostCreate.setIsAnonymous = value;
          _requestPostCreate.setIsAnonymous = value;
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

  Future<void> postHandler() async {
    bool isOtherPostFormValid = false;
    bool success = false;
    var postCreateP = Provider.of<PostCreateProvider>(context, listen: false);
    var postType = postCreateP.getCreatePostType;
    bool isSuperPostFormValid = _superPostKey.currentState!.validate();
    switch (postType) {
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
      switch (postType) {
        case PostType.normal:
          success = await postCreateP.createNormalPost();
          break;
        case PostType.poll:
          success = await postCreateP.createPollPost();
          break;
        case PostType.request:
          success = await postCreateP.createRequestPost();
          break;
      }
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

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      children: [
        superPostFields(),
        const SizedBox(
          height: 10,
        ),
        Consumer<PostCreateProvider>(
          builder: (context, postCreateP, child) => IndexedStack(
            children: [
              Visibility(
                child: FormCardNormalPost(formKey: _normalFormKey),
                maintainState: true,
                visible: postCreateP.getCreatePostType == PostType.normal,
              ),
              Visibility(
                child: FormCardPollPost(formKey: _pollFormKey),
                maintainState: true,
                visible: postCreateP.getCreatePostType == PostType.poll,
              ),
              Visibility(
                child: FormCardRequestPost(formKey: _requestFormKey),
                maintainState: true,
                visible: postCreateP.getCreatePostType == PostType.request,
              ),
            ],
            index: postCreateP.getCreatePostType.index,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
