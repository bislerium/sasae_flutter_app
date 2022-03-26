import 'package:flutter/material.dart';
import 'package:flutter_chips_input/flutter_chips_input.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/models/ngo_.dart';
import 'package:sasae_flutter_app/providers/ngo_provider.dart';
import 'package:sasae_flutter_app/providers/post_provider.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_appbar.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_card.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_widgets.dart';
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
        // descriptionTEC = TextEditingController(),
        pollDuration = TextEditingController(),
        relatedto = [],
        isPostedAnonymous = false,
        postTypeIndex = postType.normalPost;

  late Future<List<String>?> relatedToOptionList;
  late Future<List<NGO_>?> ngoOptionList;

  late final GlobalKey<FormBuilderState> superPostKey;
  late final GlobalKey<FormBuilderState> requestFormKey;
  late final GlobalKey<FormBuilderState> pollFormKey;
  static final GlobalKey<ChipsInputState> _chipKey =
      GlobalKey<ChipsInputState>();
  static final TextEditingController descriptionTEC = TextEditingController();
  final TextEditingController pollDuration;
  final List<String> pollItems;

  bool isPostedAnonymous;
  List<String>? relatedto;
  List<int>? pokedNGO;
  postType postTypeIndex;

  @override
  void initState() {
    super.initState();
    superPostKey = GlobalKey<FormBuilderState>();
    requestFormKey = GlobalKey<FormBuilderState>();
    pollFormKey = GlobalKey<FormBuilderState>();
    // _chipKey = GlobalKey<ChipsInputState>();
    relatedToOptionList = _getRelatedToOptions();
    ngoOptionList = _getNGOOptions();
  }

  @override
  void dispose() {
    descriptionTEC.dispose();
    pollDuration.dispose();
    super.dispose();
  }

  Future<List<String>?> _getRelatedToOptions() async {
    return await Provider.of<PostProvider>(context, listen: false)
        .getPostRelatedTo();
  }

  Future<List<NGO_>?> _getNGOOptions() async {
    await Provider.of<NGOProvider>(context, listen: false).fetchNGOs();
    return Provider.of<NGOProvider>(context, listen: false).ngosData;
  }

  void setPostTypeIndex(postType type) => setState(() {
        postTypeIndex = type;
      });

  Widget pokeNGOField({required List<NGO_> list}) => ChipsInput(
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
          List<NGO_> tempList = [];
          if (pokedNGO == null || pokedNGO!.isEmpty) {
            tempList = list;
          } else {
            tempList = list
                .where((element) => !pokedNGO!.contains(element.ngoID))
                .toList();
          }
          if (query.isEmpty) return tempList;
          return tempList
              .where((element) =>
                  element.orgName.toLowerCase().contains(query.toLowerCase()))
              .toList();
        },
        suggestionBuilder: (context, state, data) {
          data = data as NGO_;
          return ListTile(
            key: ObjectKey(data),
            leading: Image.network(data.orgPhoto),
            title: Text(data.orgName),
            trailing: Text(DateFormat.y().format(data.estDate)),
            onTap: () => state.selectSuggestion(data),
          );
        },
        onChanged: (value) => pokedNGO = value as List<int>,
        inputType: TextInputType.name,
      );

  Widget relatedToField({required List<String> list}) => FormBuilderFilterChip(
      name: 'filter_chip',
      maxChips: 5,
      decoration: const InputDecoration(
          labelText: 'Related to', hintText: 'What\'s your post related to?'),
      onSaved: (value) => relatedto = value!.cast<String>(),
      options: list
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

  Widget superPostFields(
          {required List<NGO_> ngoList, required List<String> relatedList}) =>
      CustomCard(
        child: FormBuilder(
          key: superPostKey,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                relatedToField(list: relatedList),
                const SizedBox(
                  height: 10,
                ),
                descriptionField(),
                const SizedBox(
                  height: 10,
                ),
                pokeNGOField(list: ngoList),
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
            if (isSuperPostFormValid && isOtherPostFormValid) {
              Provider.of<PostProvider>(context, listen: false)
                  .createNormalPost(
                      relatedTo: relatedto ?? [],
                      postContent: descriptionTEC.text,
                      pokedToNGO: pokedNGO ?? []);
            }
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
    return FutureBuilder(
      future: Future.wait(<Future>[
        ngoOptionList,
        relatedToOptionList,
      ]),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              LinearProgressIndicator(),
            ],
          );
        }
        if (snapshot.hasError) {
          showSnackBar(
            context: context,
            message: 'Something went wrong!',
            errorSnackBar: true,
          );
          Navigator.of(context).pop();
        }
        print('----------------------------');
        print(snapshot.data[0]);
        print('----------------------------');
        print(snapshot.data[1]);
        print('----------------------------');

        // relatedToOptionList = snapshot.data[0] ?? [];
        // ngoOptionList = snapshot.data[1] ?? [];
        return Scaffold(
          appBar: const CustomAppBar(title: 'Post a Post'),
          body: Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  superPostFields(
                    ngoList: snapshot.data[0],
                    relatedList: snapshot.data[1],
                  ),
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
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
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
      },
    );
  }
}

enum postType {
  normalPost,
  pollPost,
  requestPost,
}
