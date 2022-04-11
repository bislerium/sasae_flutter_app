import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/models/post/post_create_update.dart';
import 'package:sasae_flutter_app/providers/post_provider.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_card.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class FormCardRequestPost extends StatefulWidget {
  final GlobalKey<FormBuilderState> formKey;
  final bool isUpdateMode;
  const FormCardRequestPost(
      {Key? key, required this.formKey, this.isUpdateMode = false})
      : super(key: key);

  @override
  _FormCardRequestPostState createState() => _FormCardRequestPostState();
}

class _FormCardRequestPostState extends State<FormCardRequestPost>
    with AutomaticKeepAliveClientMixin {
  late final RequestPostCUModel _requestPostCU;
  final TextEditingController _minTEC, _targetTEC, _maxTEC;

  _FormCardRequestPostState()
      : _minTEC = TextEditingController(),
        _targetTEC = TextEditingController(),
        _maxTEC = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isUpdateMode) {
      _requestPostCU = Provider.of<PostUpdateProvider>(context, listen: false)
          .getRequestPostCU!;
      if (widget.isUpdateMode && _requestPostCU.getMin != null) {
        _minTEC.text = _requestPostCU.getMin!.toString();
      }
      if (widget.isUpdateMode && _requestPostCU.getTarget != null) {
        _targetTEC.text = _requestPostCU.getTarget!.toString();
      }
      if (widget.isUpdateMode && _requestPostCU.getMax != null) {
        _maxTEC.text = _requestPostCU.getMax!.toString();
      }
    } else {
      _requestPostCU = Provider.of<PostCreateProvider>(context, listen: false)
          .getRequestPostCreate;
    }
  }

  @override
  void dispose() {
    _minTEC.dispose();
    _targetTEC.dispose();
    _maxTEC.dispose();
    if (!widget.isUpdateMode) {
      _requestPostCU.nullifyRequest();
    }
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
              FormBuilderValidators.required(),
              FormBuilderValidators.numeric(),
              FormBuilderValidators.min(1, errorText: 'Minimum > 0'),
              FormBuilderValidators.maxLength(8),
            ],
          ),
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          onSaved: (value) => _requestPostCU.setMin = int.tryParse(value!),
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
              FormBuilderValidators.required(),
              FormBuilderValidators.numeric(),
              FormBuilderValidators.maxLength(8),
              (value) => int.parse(value!) < int.parse(_minTEC.text)
                  ? 'Target >= Minimum'
                  : null
            ],
          ),
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          onSaved: (value) => _requestPostCU.setTarget = int.tryParse(value!),
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
            FormBuilderValidators.numeric(),
            FormBuilderValidators.maxLength(8),
            (value) => _targetTEC.text.isEmpty || _maxTEC.text.isEmpty
                ? null
                : int.parse(value!) < int.parse(_targetTEC.text)
                    ? 'Maximum >= Target'
                    : null,
          ]),
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          onSaved: (value) => _requestPostCU.setMax = int.tryParse(value!),
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
              FormBuilderValidators.required(),
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
          initialValue:
              widget.isUpdateMode ? _requestPostCU.getRequestType : null,
          onSaved: (value) => _requestPostCU.setRequestType = value as String?,
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
        firstDate: widget.isUpdateMode
            ? _requestPostCU.getRequestDuration
            : DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365 * 6)),
        initialValue:
            widget.isUpdateMode ? _requestPostCU.getRequestDuration : null,
        validator: FormBuilderValidators.compose(
          [
            FormBuilderValidators.required(),
            (value) =>
                value!.isBefore(DateTime.now().add(const Duration(hours: 1)))
                    ? 'Must have minimum one hour duration'
                    : null
          ],
        ),
        onSaved: (value) => _requestPostCU.setRequestDuration = value,
      );

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

  @override
  bool get wantKeepAlive => true;
}
