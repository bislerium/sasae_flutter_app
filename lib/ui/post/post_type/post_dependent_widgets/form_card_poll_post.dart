import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/models/post/post_create_update.dart';
import 'package:sasae_flutter_app/providers/post_provider.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_card.dart';
import 'package:sasae_flutter_app/ui/post/post_type/post_dependent_widgets/dismissable_tile.dart';

class FormCardPollPost extends StatefulWidget {
  final GlobalKey<FormBuilderState> formKey;
  final bool isUpdateMode;

  const FormCardPollPost({
    Key? key,
    required this.formKey,
    this.isUpdateMode = false,
  }) : super(key: key);

  @override
  _FormCardPollPostState createState() => _FormCardPollPostState();
}

class _FormCardPollPostState extends State<FormCardPollPost>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _itemTEC;
  final GlobalKey<FormBuilderState> _optionsAddFormKey;
  late final PollPostCUModel _pollPostCU;

  _FormCardPollPostState()
      : _itemTEC = TextEditingController(),
        _optionsAddFormKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    if (widget.isUpdateMode) {
      _pollPostCU = Provider.of<PostUpdateProvider>(context, listen: false)
          .getPollPostCU!;
    } else {
      _pollPostCU = Provider.of<PostCreateProvider>(context, listen: false)
          .getPollPostCreate;
      _pollPostCU.setPollOptions = [];
    }
  }

  @override
  void dispose() {
    _itemTEC.dispose();
    if (!widget.isUpdateMode) {
      _pollPostCU.nullifyPoll();
    }
    super.dispose();
  }

  void addItem(String item) =>
      setState(() => _pollPostCU.getPollOptions!.add(item.trim()));

  void removeItem(String item) =>
      setState(() => _pollPostCU.getPollOptions!.remove(item));

  Widget pollTextField() => FormBuilder(
        key: _optionsAddFormKey,
        child: Expanded(
          child: FormBuilderTextField(
            name: 'pollOption',
            controller: _itemTEC,
            decoration: const InputDecoration(
              labelText: 'Option',
              hintText: 'Add a poll option',
              border: InputBorder.none,
            ),
            maxLength: 30,
            validator: FormBuilderValidators.compose(
              [
                FormBuilderValidators.required(),
                (value) => _pollPostCU.getPollOptions!.any((element) =>
                        element.toLowerCase() == value!.trim().toLowerCase())
                    ? 'The poll option is already added.'
                    : null,
              ],
            ),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
          ),
        ),
      );

  Widget addPollButton() => ConstrainedBox(
        constraints: const BoxConstraints.tightFor(width: 80, height: 50),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: const StadiumBorder(),
              primary: Theme.of(context).colorScheme.secondary),
          onPressed: () {
            if (_optionsAddFormKey.currentState!.validate()) {
              addItem(_itemTEC.text);
              _itemTEC.clear();
            }
          },
          child: const Text('Add'),
        ),
      );

  Widget polls() => FormBuilderField(
        name: 'pollField',
        validator: FormBuilderValidators.compose([
          (value) => (_pollPostCU.getPollOptions!.isEmpty ||
                  _pollPostCU.getPollOptions!.length < 2)
              ? 'Add at least two poll options'
              : null
        ]),
        builder: (FormFieldState<dynamic> field) {
          return InputDecorator(
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.only(top: 10.0, bottom: 0.0),
              errorText: field.errorText,
            ),
            child: Column(
              children: _pollPostCU.getPollOptions!
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: DissmissableTile(
                        item: e,
                        removeHandler: (value) => removeItem(e),
                      ),
                    ),
                  )
                  .toList(),
            ),
          );
        },
      );

  Widget datetimeField() => FormBuilderDateTimePicker(
      name: 'pollDuration',
      inputType: InputType.both,
      decoration: const InputDecoration(
        labelText: 'Poll duration',
      ),
      firstDate:
          widget.isUpdateMode ? _pollPostCU.getPollDuration : DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 6)),
      initialValue: widget.isUpdateMode ? _pollPostCU.getPollDuration : null,
      validator: FormBuilderValidators.compose([
        (value) => value != null &&
                value.isBefore(DateTime.now().add(const Duration(hours: 1)))
            ? 'Must have minimum one hour duration'
            : null
      ]),
      onSaved: (value) => _pollPostCU.setPollDuration = value);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: FormBuilder(
          key: widget.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Poll Post',
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  pollTextField(),
                  const SizedBox(
                    width: 10,
                  ),
                  addPollButton(),
                ],
              ),
              polls(),
              const SizedBox(
                height: 10,
              ),
              datetimeField(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
