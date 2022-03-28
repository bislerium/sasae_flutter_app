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
    requestFormKey = GlobalKey<FormBuilderState>();
    pollFormKey = GlobalKey<FormBuilderState>();
    _chipKey = GlobalKey<ChipsInputState>();
    WidgetsBinding.instance!
        .addPostFrameCallback((_) => setPostButtonOnPressed());
  }

  initFormClass() {
    var postCreateP = Provider.of<PostCreateProvider>(context);
    normalPostCreate = postCreateP.getNormalPostCreate;
    pollPostCreate = postCreateP.getPollPostCreate;
    requestPostCreate = postCreateP.getRequestPostCreate;
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
              data.toString(),
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
            leading: Image.network(data.orgPhoto),
            title: Text(data.orgName),
            onTap: () => state.selectSuggestion(data),
          );
        },
        onChanged: (value) => pokedNGO = value as List<int>,
        inputType: TextInputType.name,
      );

  Widget relatedToField() => FormBuilderFilterChip(
      name: 'filter_chip',
      maxChips: 5,
      decoration: const InputDecoration(
          labelText: 'Related to', hintText: 'What\'s your post related to?'),
      onSaved: (value) => relatedto = value!.cast<String>(),
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
          value!.isEmpty ? 'Select what\'s your post related to.' : null);

  Widget descriptionField() => FormBuilderTextField(
        name: 'min',
        controller: descriptionTEC,
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
                descriptionField(),
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
    bool isSuperPostFormValid = superPostKey.currentState!.validate();
    bool isOtherPostFormValid = false;
    switch (Provider.of<PostCreateProvider>(context, listen: false)
        .getCreatePostType) {
      case PostType.normalPost:
        isOtherPostFormValid = true;
        break;
      case PostType.pollPost:
        isOtherPostFormValid = pollFormKey.currentState!.validate();
        break;
      case PostType.requestPost:
        isOtherPostFormValid = requestFormKey.currentState!.validate();
        break;
    }
    if (isSuperPostFormValid && isOtherPostFormValid) {
      Provider.of<PostCreateProvider>(context, listen: false).createNormalPost(
          relatedTo: relatedto ?? [],
          postContent: descriptionTEC.text,
          pokedToNGO: pokedNGO ?? []);
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
