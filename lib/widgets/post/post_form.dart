import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chips_input/flutter_chips_input.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_appbar.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_card.dart';
import 'post_type/post_dependent_widgets/form_card_poll_post.dart';
import 'post_type/post_dependent_widgets/form_card_request_post.dart';

class PostForm extends StatefulWidget {
  static const routeName = '/post/form';

  const PostForm({Key? key}) : super(key: key);

  @override
  _PostFormState createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  _PostFormState()
      : pollItems = [],
        descriptionTEC = TextEditingController(),
        pollDuration = TextEditingController(),
        relatedto = [],
        isPostedAnonymous = false,
        postTypeIndex = postType.normalPost;

  late List<String> relatedToOptionList;
  late List<String> ngoOptionList;
  late final GlobalKey<FormBuilderState> superPostKey;
  late final GlobalKey<FormBuilderState> requestFormKey;
  late final GlobalKey<FormBuilderState> pollFormKey;
  late final GlobalKey<ChipsInputState> _chipKey;
  final TextEditingController descriptionTEC;
  final TextEditingController pollDuration;
  final List<String> pollItems;

  bool isPostedAnonymous;
  List<String>? relatedto;
  List<String>? pokedNGO;
  postType postTypeIndex;

  @override
  void initState() {
    super.initState();
    superPostKey = GlobalKey<FormBuilderState>();
    requestFormKey = GlobalKey<FormBuilderState>();
    pollFormKey = GlobalKey<FormBuilderState>();
    _chipKey = GlobalKey<ChipsInputState>();
    relatedToOptionList = getRelatedToOptions();
    ngoOptionList = getNGOOptions();
  }

  @override
  void dispose() {
    descriptionTEC.dispose();
    pollDuration.dispose();
    super.dispose();
  }

  void setPostTypeIndex(postType type) => setState(() {
        postTypeIndex = type;
      });

  List<String> getRelatedToOptions() => faker.lorem.words(40);
  List<String> getNGOOptions() => faker.lorem.words(40);

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
          late List<String> tempList;
          if (pokedNGO == null || pokedNGO!.isEmpty) {
            tempList = ngoOptionList;
          } else {
            tempList =
                List.from(ngoOptionList.toSet().difference(pokedNGO!.toSet()));
          }
          if (query.isEmpty) return tempList;
          return tempList
              .where((element) =>
                  element.toLowerCase().contains(query.toLowerCase()))
              .toList();
        },
        suggestionBuilder: (context, state, data) {
          return ListTile(
            key: ObjectKey(data),
            title: Text(data.toString()),
            onTap: () => state.selectSuggestion(data),
          );
        },
        onChanged: (value) => pokedNGO = value.cast<String>(),
        inputType: TextInputType.name,
      );

  Widget relatedToField() => FormBuilderFilterChip(
      name: 'filter_chip',
      maxChips: 5,
      decoration: const InputDecoration(
          labelText: 'Related to', hintText: 'What\'s your post related to?'),
      onSaved: (value) => relatedto = value!.cast<String>(),
      options: relatedToOptionList
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

  Widget imageField() {
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

  Widget buttonsPerPostType() {
    Color activeColor = Theme.of(context).colorScheme.primary;
    Color inActiveColor = Theme.of(context).colorScheme.onSurfaceVariant;
    return Row(
      children: [
        IconButton(
          onPressed: () => setState(() {
            setPostTypeIndex(postType.normalPost);
          }),
          icon: const Icon(
            Icons.file_present_rounded,
          ),
          color: postTypeIndex == postType.normalPost
              ? activeColor
              : inActiveColor,
          iconSize: 30,
          tooltip: 'Normal Post',
        ),
        IconButton(
          onPressed: () => setState(() {
            setPostTypeIndex(postType.pollPost);
          }),
          icon: const Icon(
            Icons.poll_rounded,
          ),
          color:
              postTypeIndex == postType.pollPost ? activeColor : inActiveColor,
          iconSize: 30,
          tooltip: 'Poll Post',
        ),
        IconButton(
          onPressed: () => setState(() {
            setPostTypeIndex(postType.requestPost);
          }),
          icon: const Icon(
            Icons.help_center,
          ),
          color: postTypeIndex == postType.requestPost
              ? activeColor
              : inActiveColor,
          iconSize: 30,
          tooltip: 'Request Post',
        ),
      ],
    );
  }

  Widget fieldsPerPostType() {
    late Widget widget;
    switch (postTypeIndex) {
      case postType.normalPost:
        widget = imageField();
        break;
      case postType.pollPost:
        widget = FormCardPollPost(
          formKey: pollFormKey,
          pollItems: pollItems,
          pollDuration: pollDuration,
        );
        break;
      case postType.requestPost:
        widget = FormCardRequestPost(
          formKey: requestFormKey,
        );
        break;
    }
    return widget;
  }

  Widget postButton() => ConstrainedBox(
        constraints: const BoxConstraints.tightFor(
          height: 60,
          width: 120,
        ),
        child: ElevatedButton.icon(
          onPressed: () {
            bool isSuperPostFormValid = superPostKey.currentState!.validate();
            bool isOtherPostFormValid = false;
            switch (postTypeIndex) {
              case postType.normalPost:
                isOtherPostFormValid = true;
                break;
              case postType.pollPost:
                isOtherPostFormValid = pollFormKey.currentState!.validate();
                break;
              case postType.requestPost:
                isOtherPostFormValid = requestFormKey.currentState!.validate();
                break;
            }
            if (isSuperPostFormValid && isOtherPostFormValid) {}
          },
          icon: const Icon(
            Icons.post_add_rounded,
          ),
          label: const Text(
            'Post',
          ),
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Post a Post'),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              superPostFields(),
              const SizedBox(
                height: 10,
              ),
              fieldsPerPostType(),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        color: Theme.of(context).colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              buttonsPerPostType(),
              const Spacer(),
              postButton(),
            ],
          ),
        ),
      ),
    );
  }
}

enum postType {
  normalPost,
  pollPost,
  requestPost,
}
