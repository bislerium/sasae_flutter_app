import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/models/post/post_create.dart';
import 'package:sasae_flutter_app/providers/post_provider.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_card.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class FormCardRequestPost extends StatefulWidget {
  final GlobalKey<FormBuilderState> formKey;
  const FormCardRequestPost({Key? key, required this.formKey})
      : super(key: key);

  @override
  _FormCardRequestPostState createState() => _FormCardRequestPostState();
}

class _FormCardRequestPostState extends State<FormCardRequestPost> {
  late final RequestPostCreate _requestPostCreate;
  final TextEditingController _minTEC;
  final TextEditingController _targetTEC;
  final TextEditingController _maxTEC;

  _FormCardRequestPostState()
      : _minTEC = TextEditingController(),
        _targetTEC = TextEditingController(),
        _maxTEC = TextEditingController();

  @override
  void initState() {
    super.initState();
    _requestPostCreate = Provider.of<PostCreateProvider>(context, listen: false)
        .getRequestPostCreate;
  }

  @override
  void dispose() {
    _minTEC.dispose();
    _targetTEC.dispose();
    _maxTEC.dispose();
    _requestPostCreate.nullifyRequest();
    super.dispose();
  }

  Widget minField() => Expanded(
        child: FormBuilderTextField(
          name: 'min',
          controller: _minTEC,
          decoration: const InputDecoration(
            labelText: 'Minimum',
          ),
          validator: FormBuilderValidators.compose(
            [
              FormBuilderValidators.required(context),
              FormBuilderValidators.numeric(context),
              FormBuilderValidators.min(context, 1, errorText: 'Minimum > 0'),
              FormBuilderValidators.maxLength(context, 8),
            ],
          ),
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          onSaved: (value) => _requestPostCreate.setMin = int.tryParse(value!),
        ),
      );

  Widget targetField() => Expanded(
        child: FormBuilderTextField(
          name: 'target',
          controller: _targetTEC,
          decoration: const InputDecoration(
            labelText: 'Target',
          ),
          validator: FormBuilderValidators.compose(
            [
              FormBuilderValidators.required(context),
              FormBuilderValidators.numeric(context),
              FormBuilderValidators.maxLength(context, 8),
              (value) => int.parse(value!) < int.parse(_minTEC.text)
                  ? 'Target >= Minimum'
                  : null
            ],
          ),
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          onSaved: (value) =>
              _requestPostCreate.setTarget = int.tryParse(value!),
        ),
      );

  Widget maximumField() => Expanded(
        child: FormBuilderTextField(
          name: 'max',
          controller: _maxTEC,
          decoration: const InputDecoration(
            labelText: 'Maximum',
          ),
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.numeric(context),
            FormBuilderValidators.maxLength(context, 8),
            (value) => _targetTEC.text.isEmpty || _maxTEC.text.isEmpty
                ? null
                : int.parse(value!) < int.parse(_targetTEC.text)
                    ? 'Maximum >= Target'
                    : null,
          ]),
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          onSaved: (value) => _requestPostCreate.setMax = int.tryParse(value!),
        ),
      );

  Widget requestTypeField() => Expanded(
        child: FormBuilderDropdown(
          name: 'requestType',
          decoration: const InputDecoration(
            labelText: 'Request type',
          ),
          allowClear: true,
          hint: const Text(
            'Select type',
          ),
          validator: FormBuilderValidators.compose(
            [
              FormBuilderValidators.required(context),
              (value) => value == 'Petition' && _maxTEC.text.isNotEmpty
                  ? '👈 Maximum not allowed.'
                  : null,
            ],
          ),
          items: ['Join', 'Petition']
              .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  ))
              .toList(),
          onSaved: (value) =>
              _requestPostCreate.setRequestType = value as String?,
          onChanged: (value) {
            if (value == 'Petition') {
              _maxTEC.clear();
            }
          },
        ),
      );

  Widget datetimeField() => FormBuilderDateTimePicker(
        name: 'RequestDuration',
        inputType: InputType.both,
        decoration: const InputDecoration(
          labelText: 'End Time',
        ),
        firstDate: DateTime.now(),
        currentDate: DateTime.now(),
        validator: FormBuilderValidators.compose(
          [
            FormBuilderValidators.required(context),
            (value) =>
                value!.isBefore(DateTime.now().add(const Duration(hours: 1)))
                    ? 'Must have minimum one hour duration'
                    : null
          ],
        ),
        onSaved: (value) => _requestPostCreate.setRequestDuration = value,
      );

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: FormBuilder(
          key: widget.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Request post',
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  minField(),
                  const SizedBox(
                    width: 20,
                  ),
                  targetField(),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  maximumField(),
                  const SizedBox(
                    width: 20,
                  ),
                  requestTypeField(),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              datetimeField(),
            ],
          ),
        ),
      ),
    );
  }
}
