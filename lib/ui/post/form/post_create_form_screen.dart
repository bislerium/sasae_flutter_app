import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/post_provider.dart';
import 'package:sasae_flutter_app/services/utilities.dart';
import 'package:sasae_flutter_app/ui/post/form/module/form_card_normal_post.dart';
import 'package:sasae_flutter_app/ui/post/form/module/form_card_poll_post.dart';
import 'package:sasae_flutter_app/ui/post/form/module/form_card_request_post.dart';
import 'package:sasae_flutter_app/widgets/misc/annotated_scaffold.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_appbar.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_loading.dart';
import 'package:sasae_flutter_app/widgets/misc/fetch_error.dart';
import 'package:flutter_chips_input/flutter_chips_input.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:sasae_flutter_app/models/post/ngo__.dart';
import 'package:sasae_flutter_app/models/post/post_create_update.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_card.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_image.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_widgets.dart';

class PostCreateFormScreen extends StatefulWidget {
  static const routeName = '/post/create/';

  const PostCreateFormScreen({Key? key}) : super(key: key);

  @override
  State<PostCreateFormScreen> createState() => _PostCreateFormScreenState();
}

class _PostCreateFormScreenState extends State<PostCreateFormScreen>
    with SingleTickerProviderStateMixin {
  late Future<void> _fetchrRelatedToOptionsFUTURE;
  late Future<void> _fetchNGOOptionsFUTURE;
  Future<void> Function()? postHandler;

  @override
  void initState() {
    super.initState();
    _fetchrRelatedToOptionsFUTURE = _fetchRelatedToOptions();
    _fetchNGOOptionsFUTURE = _fetchNGOOptions();
  }

  Future<void> _fetchRelatedToOptions() async {
    await Provider.of<PostCreateProvider>(context, listen: false)
        .initPostRelatedTo();
  }

  Future<void> _fetchNGOOptions() async {
    await Provider.of<PostCreateProvider>(context, listen: false)
        .initNGOOptions();
  }

  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context).colorScheme;
    return AnnotatedScaffold(
      systemNavigationBarColor: ElevationOverlay.colorWithOverlay(
          colors.surface, colors.primary, 3.0),
      child: Scaffold(
        appBar: const CustomAppBar(title: 'Post a Post'),
        body: FutureBuilder(
          future: Future.wait(<Future>[
            _fetchNGOOptionsFUTURE,
            _fetchrRelatedToOptionsFUTURE,
          ]),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? const ScreenLoading()
                  : Consumer<PostCreateProvider>(
                      builder: (context, postCreateP, child) =>
                          RefreshIndicator(
                        onRefresh: () async => await refreshCallBack(
                          context: context,
                          func: () async {
                            await postCreateP.refreshNGOOptions();
                            await postCreateP.refreshPostRelatedTo();
                          },
                        ),
                        child: postCreateP.getNGOOptionsData == null ||
                                postCreateP.getPostRelatedToData == null
                            ? const ErrorView()
                            : PostCreateForm(
                                snapshotNGOList: postCreateP.getNGOOptionsData!,
                                snapshotRelatedList:
                                    postCreateP.getPostRelatedToData!,
                              ),
                      ),
                    ),
        ),
        bottomNavigationBar: Consumer<PostCreateProvider>(
          builder: (context, postCreateP, child) =>
              postCreateP.getNGOOptionsData == null ||
                      postCreateP.getPostRelatedToData == null
                  ? const SizedBox.shrink()
                  : const PostBar(),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

class PostCreateForm extends StatefulWidget {
  static const routeName = '/post/form';
  final List<NGO__Model> snapshotNGOList;
  final List<String> snapshotRelatedList;

  const PostCreateForm(
      {Key? key,
      required this.snapshotNGOList,
      required this.snapshotRelatedList})
      : super(key: key);

  @override
  State<PostCreateForm> createState() => _PostCreateFormState();
}

class _PostCreateFormState extends State<PostCreateForm> {
  late final NormalPostCUModel _normalPostCreate;
  late final PollPostCUModel _pollPostCreate;
  late final RequestPostCUModel _requestPostCreate;

  final GlobalKey<FormBuilderState> _superPostKey,
      _requestFormKey,
      _pollFormKey,
      _normalFormKey;
  final GlobalKey<ChipsInputState> _chipKey;
  List<int>? _pokedNGO;

  _PostCreateFormState()
      : _superPostKey = GlobalKey<FormBuilderState>(),
        _normalFormKey = GlobalKey<FormBuilderState>(),
        _requestFormKey = GlobalKey<FormBuilderState>(),
        _pollFormKey = GlobalKey<FormBuilderState>(),
        _chipKey = GlobalKey<ChipsInputState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
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
            .map((e) => FormBuilderChipOption(value: e, child: Text(e)))
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
          var a = value!.cast<String>();
          _normalPostCreate.setRelatedTo = a;
          _pollPostCreate.setRelatedTo = a;
          _requestPostCreate.setRelatedTo = a;
        },
      );

  Widget pokeNGOField() => ChipsInput(
        key: _chipKey,
        allowChipEditing: true,
        decoration: const InputDecoration(
          labelText: 'Poke NGO',
          hintText: 'Let the NGO(s) know!',
        ),
        chipBuilder: (context, state, data) {
          return InputChip(
            key: ObjectKey(data),
            label: Text(
              (data as NGO__Model).orgName,
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
          List<NGO__Model> tempList = [];
          if (_pokedNGO == null || _pokedNGO!.isEmpty) {
            tempList = widget.snapshotNGOList;
          } else {
            tempList = widget.snapshotNGOList
                .where((element) => !_pokedNGO!.contains(element.id))
                .toList();
          }
          if (query.isEmpty) return tempList;
          return tempList
              .where((element) =>
                  element.orgName.toLowerCase().contains(query.toLowerCase()))
              .toList();
        },
        suggestionBuilder: (context, state, data) {
          data = data as NGO__Model;
          return ListTile(
            key: ObjectKey(data),
            leading: ClipOval(
              child: CustomImage(
                imageURL: data.orgPhoto,
                height: 40,
                width: 40,
              ),
            ),
            title: SizedBox(
              width: double.infinity,
              child: Text(
                data.orgName,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            onTap: () => state.selectSuggestion(data),
          );
        },
        initialSuggestions: widget.snapshotNGOList,
        onChanged: (value) {
          var selectedNGOs =
              (value as List<NGO__Model>).map((e) => e.id).toList();
          _normalPostCreate.setPokedNGO = selectedNGOs;
          _pollPostCreate.setPokedNGO = selectedNGOs;
          _requestPostCreate.setPokedNGO = selectedNGOs;
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
            FormBuilderValidators.required(),
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
        if (!mounted) return;
        Navigator.of(context).pop();
        showSnackBar(context: context, message: 'Successfully posted');
      } else {
        showSnackBar(context: context, errorSnackBar: true);
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
            index: postCreateP.getCreatePostType.index,
            children: [
              Visibility(
                maintainState: true,
                visible: postCreateP.getCreatePostType == PostType.normal,
                child: FormCardNormalPost(formKey: _normalFormKey),
              ),
              Visibility(
                maintainState: true,
                visible: postCreateP.getCreatePostType == PostType.poll,
                child: FormCardPollPost(formKey: _pollFormKey),
              ),
              Visibility(
                maintainState: true,
                visible: postCreateP.getCreatePostType == PostType.request,
                child: FormCardRequestPost(formKey: _requestFormKey),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

class PostBar extends StatefulWidget {
  const PostBar({Key? key}) : super(key: key);

  @override
  State<PostBar> createState() => _PostBarState();
}

class _PostBarState extends State<PostBar> {
  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context).colorScheme;
    return Container(
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      color: ElevationOverlay.colorWithOverlay(
          colors.surface, colors.primary, 3.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: const [
            PostTypeRow(),
            Spacer(),
            PostCreateButton(),
          ],
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

class PostCreateButton extends StatefulWidget {
  const PostCreateButton({Key? key}) : super(key: key);

  @override
  State<PostCreateButton> createState() => _PostCreateButtonState();
}

class _PostCreateButtonState extends State<PostCreateButton> {
  bool _isLoading;

  _PostCreateButtonState() : _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<PostCreateProvider>(
      builder: (context, postCreateP, child) => ConstrainedBox(
        constraints: const BoxConstraints.tightFor(
          height: 60,
          width: 120,
        ),
        child: ElevatedButton(
          onPressed: () async {
            if (_isLoading) return;
            if (!isInternetConnected(context)) return;
            if (!isProfileVerified(context)) return;
            setState(() => _isLoading = true);
            await postCreateP.getPostCreateHandler!();
            setState(() => _isLoading = false);
          },
          style: ElevatedButton.styleFrom(
            primary: Theme.of(context).colorScheme.primaryContainer,
            onPrimary: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _isLoading
                  ? ButtomLoading(
                      color: Theme.of(context).colorScheme.onPrimaryContainer)
                  : const Icon(
                      Icons.post_add_rounded,
                    ),
              if (!_isLoading) ...[
                const SizedBox(
                  width: 6,
                ),
                const Text(
                  'Post',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

class PostTypeRow extends StatelessWidget {
  const PostTypeRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PostCreateProvider>(
      builder: (context, postCreateP, child) => DefaultTabController(
        initialIndex: postCreateP.getCreatePostType.index,
        length: 3,
        child: TabBar(
          isScrollable: true,
          labelColor: Theme.of(context).colorScheme.onPrimaryContainer,
          unselectedLabelColor: Theme.of(context).colorScheme.outline,
          indicator: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(30),
          ),
          enableFeedback: true,
          onTap: (index) {
            switch (index) {
              case 0:
                postCreateP.setCreatePostType = PostType.normal;
                break;
              case 1:
                postCreateP.setCreatePostType = PostType.poll;
                break;
              case 2:
                postCreateP.setCreatePostType = PostType.request;
                break;
            }
          },
          tabs: const [
            Tooltip(
              message: 'Normal Post',
              child: Tab(
                icon: Icon(
                  Icons.add_circle_rounded,
                  size: 30,
                ),
              ),
            ),
            Tooltip(
              message: 'Poll Post',
              child: Tab(
                icon: Icon(
                  Icons.poll_rounded,
                  size: 30,
                ),
              ),
            ),
            Tooltip(
              message: 'Request Post',
              child: Tab(
                icon: Icon(
                  Icons.front_hand_rounded,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
