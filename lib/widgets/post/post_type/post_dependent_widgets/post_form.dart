import 'package:flutter/material.dart';
import 'package:flutter_chips_input/flutter_chips_input.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/models/post/ngo__.dart';
import 'package:sasae_flutter_app/models/post/post_create.dart';
import 'package:sasae_flutter_app/providers/post_provider.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_card.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/post_dependent_widgets/post_form_per_type.dart';

class PostForm extends StatefulWidget {
  static const routeName = '/post/form';
  final List<NGO__> snapshotNGOList;
  final List<String> snapshotRelatedList;

  const PostForm(
      {Key? key,
      required this.snapshotNGOList,
      required this.snapshotRelatedList})
      : super(key: key);

  @override
  _PostFormState createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  _PostFormState()
      : pollItems = [],
        descriptionTEC = TextEditingController(),
        pollDuration = TextEditingController(),
        relatedto = [],
        isPostedAnonymous = false;

  late final NormalPostCreate normalPostCreate;
  late final PollPostCreate pollPostCreate;
  late final RequestPostCreate requestPostCreate;

  late final GlobalKey<FormBuilderState> superPostKey;
  late final GlobalKey<FormBuilderState> requestFormKey;
  late final GlobalKey<FormBuilderState> pollFormKey;
  late final GlobalKey<FormBuilderState> normalFormKey;
  late final GlobalKey<ChipsInputState> _chipKey;
  final TextEditingController descriptionTEC;
  final TextEditingController pollDuration;
  final List<String> pollItems;

  bool isPostedAnonymous;
  List<String>? relatedto;
  List<int>? pokedNGO;

  @override
  void initState() {
    super.initState();
    superPostKey = GlobalKey<FormBuilderState>();
    normalFormKey = GlobalKey<FormBuilderState>();
    requestFormKey = GlobalKey<FormBuilderState>();
    pollFormKey = GlobalKey<FormBuilderState>();
    _chipKey = GlobalKey<ChipsInputState>();
    WidgetsBinding.instance!
        .addPostFrameCallback((_) => setPostButtonOnPressed());
    initFormClass();
  }

  initFormClass() {
    var postCreateP = Provider.of<PostCreateProvider>(context, listen: false);
    normalPostCreate = postCreateP.getNormalPostCreate
      ..setRelatedTo = []
      ..setPokedNGO = []
      ..setIsAnonymous = false;
    pollPostCreate = postCreateP.getPollPostCreate
      ..setRelatedTo = []
      ..setRelatedTo = []
      ..setIsAnonymous = false;
    requestPostCreate = postCreateP.getRequestPostCreate
      ..setRelatedTo = []
      ..setPokedNGO = []
      ..setIsAnonymous = false;
  }

  void setPostButtonOnPressed() {
    Provider.of<PostCreateProvider>(context, listen: false).setPostHandler =
        postHandler;
  }

  @override
  void dispose() {
    descriptionTEC.dispose();
    pollDuration.dispose();
    super.dispose();
  }

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
          normalPostCreate.setPokedNGO = _;
          pollPostCreate.setPokedNGO = _;
          requestPostCreate.setPokedNGO = _;
        },
        inputType: TextInputType.name,
      );

  Widget relatedToField() => FormBuilderFilterChip(
        name: 'filterChip',
        maxChips: 5,
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
          normalPostCreate.setRelatedTo = _;
          pollPostCreate.setRelatedTo = _;
          requestPostCreate.setRelatedTo = _;
        },
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
          normalPostCreate.setPostContent = value;
          pollPostCreate.setPostContent = value;
          requestPostCreate.setPostContent = value;
        },
        textInputAction: TextInputAction.next,
      );

  Widget anonymousField() => FormBuilderSwitch(
        name: 'anonymous',
        initialValue: false,
        onSaved: (value) => isPostedAnonymous = value!,
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),
        activeColor: Theme.of(context).colorScheme.primary,
        title: const Text('Post anonymously'),
        onChanged: (value) {
          var _ = value;
          normalPostCreate.setIsAnonymous = value;
          pollPostCreate.setIsAnonymous = value;
          requestPostCreate.setIsAnonymous = value;
        },
      );

  Widget superPostFields() => CustomCard(
        child: FormBuilder(
          key: superPostKey,
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
    bool isSuperPostFormValid = superPostKey.currentState!.validate();
    switch (postType) {
      case PostType.normalPost:
        isOtherPostFormValid = normalFormKey.currentState!.validate();
        if (isOtherPostFormValid) normalFormKey.currentState!.save();
        break;
      case PostType.pollPost:
        isOtherPostFormValid = pollFormKey.currentState!.validate();
        if (isOtherPostFormValid) pollFormKey.currentState!.save();
        break;
      case PostType.requestPost:
        isOtherPostFormValid = requestFormKey.currentState!.validate();
        if (isOtherPostFormValid) requestFormKey.currentState!.save();
        break;
    }
    if (isSuperPostFormValid && isOtherPostFormValid) {
      superPostKey.currentState!.save();
      switch (postType) {
        case PostType.normalPost:
          success = await postCreateP.createNormalPost();
          break;
        case PostType.pollPost:
          break;
        case PostType.requestPost:
          break;
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
        PostFormPerPostType(
          normalFormKey: normalFormKey,
          pollFormKey: pollFormKey,
          requestFormKey: requestFormKey,
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
