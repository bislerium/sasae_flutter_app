import 'package:flutter/material.dart';
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
  List<String> requestType;

  _FormCardRequestPostState()
      : requestType = ['Join', 'Petition'],
        minTEC = TextEditingController(),
        targetTEC = TextEditingController(),
        maxTEC = TextEditingController(),
        endsOnTEC = TextEditingController();

  final TextEditingController minTEC;
  final TextEditingController targetTEC;
  final TextEditingController maxTEC;
  String? requestTypeTEC;
  final TextEditingController endsOnTEC;

  @override
  void dispose() {
    minTEC.dispose();
    targetTEC.dispose();
    maxTEC.dispose();
    endsOnTEC.dispose();
    super.dispose();
  }

  Widget minField() => Expanded(
        child: FormBuilderTextField(
          name: 'min',
          controller: minTEC,
          decoration: const InputDecoration(
            labelText: 'Minimum',
          ),
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(context),
            FormBuilderValidators.numeric(context),
            FormBuilderValidators.max(context, 70),
          ]),
          keyboardType: TextInputType.number,
        ),
      );

  Widget targetField() => Expanded(
        child: FormBuilderTextField(
          name: 'target',
          controller: targetTEC,
          decoration: const InputDecoration(
            labelText: 'Target',
          ),
          validator: FormBuilderValidators.compose(
            [
              FormBuilderValidators.numeric(context),
              FormBuilderValidators.max(context, 70),
            ],
          ),
          keyboardType: TextInputType.number,
        ),
      );

  Widget maximumField() => Expanded(
        child: FormBuilderTextField(
          name: 'max',
          controller: maxTEC,
          decoration: const InputDecoration(
            labelText: 'Maximum',
          ),
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(context),
            FormBuilderValidators.numeric(context),
            FormBuilderValidators.max(context, 70),
          ]),
          keyboardType: TextInputType.number,
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
          onChanged: (value) => requestTypeTEC = value as String?,
          validator: FormBuilderValidators.compose(
              [FormBuilderValidators.required(context)]),
          items: requestType
              .map((gender) => DropdownMenuItem(
                    value: gender,
                    child: Text(gender),
                  ))
              .toList(),
        ),
      );

  Widget datetimeField() => FormBuilderDateTimePicker(
        name: 'Request duration',
        controller: endsOnTEC,
        inputType: InputType.both,
        decoration: const InputDecoration(
          labelText: 'End Time',
        ),
        firstDate: DateTime.now(),
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
