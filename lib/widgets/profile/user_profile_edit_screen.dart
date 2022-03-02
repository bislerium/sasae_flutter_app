import 'package:flutter/material.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:sasae_flutter_app/models/user.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_appbar.dart';

class UserProfileEditScreen extends StatefulWidget {
  static const String routeName = '/editProfile';

  final User user;
  const UserProfileEditScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  _UserProfileEditScreenState createState() => _UserProfileEditScreenState();
}

class _UserProfileEditScreenState extends State<UserProfileEditScreen> {
  @override
  void initState() {
    super.initState();
  }

  Widget fullNameField() => FormBuilderTextField(
        name: 'fullName',
        // controller: targetTEC,
        decoration: const InputDecoration(
          labelText: 'Full Name',
        ),
        initialValue: widget.user.fullName,
        validator: FormBuilderValidators.compose(
          [
            FormBuilderValidators.numeric(context),
          ],
        ),
        keyboardType: TextInputType.name,
      );

  Widget genderField() => FormBuilderDropdown(
        name: 'gender',
        decoration: const InputDecoration(
          labelText: 'Gender',
        ),
        initialValue: widget.user.gender,
        hint: const Text(
          'Select gender',
        ),
        // onChanged: (value) => requestTypeTEC = value as String?,
        validator: FormBuilderValidators.compose(
            [FormBuilderValidators.required(context)]),
        items: const [
          DropdownMenuItem(
            value: 'Male',
            child: Text('Male'),
          ),
          DropdownMenuItem(
            value: 'Female',
            child: Text('Female'),
          ),
          DropdownMenuItem(
            value: 'LGBTQ+',
            child: Text('LGBTQ+'),
          )
        ],
      );

  Widget birthDateField() => FormBuilderDateTimePicker(
        name: 'birthDate',
        // controller: endsOnTEC,
        inputType: InputType.date,
        decoration: const InputDecoration(
          labelText: 'Birth Date',
        ),
        initialValue: widget.user.birthDate,
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(context),
        ]),
      );

  Widget emailField() => FormBuilderTextField(
        name: 'email',
        // controller: targetTEC,
        decoration: const InputDecoration(
          labelText: 'Email',
        ),
        initialValue: widget.user.email,
        validator: FormBuilderValidators.compose(
          [
            FormBuilderValidators.numeric(context),
            FormBuilderValidators.email(context),
          ],
        ),
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
      );

  Widget phoneField() => FormBuilderField(
        builder: (FormFieldState<dynamic> field) {
          return InternationalPhoneNumberInput(
            selectorConfig: const SelectorConfig(
              selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
            ),
            // initialValue: PhoneNumber(phoneNumber: user.phoneNumber),
            onInputChanged: (PhoneNumber value) {},
          );
        },
        name: 'phone',
      );

  Widget imageField() {
    double width = MediaQuery.of(context).size.width - 60;
    return FormBuilderImagePicker(
      name: 'photos',
      initialValue: [widget.user.citizenshipPhoto],
      decoration: const InputDecoration(
        labelText: 'Attach a citizenship photo',
        border: InputBorder.none,
      ),
      previewWidth: width,
      previewHeight: width,
      maxImages: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Update Profile',
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              fullNameField(),
              const SizedBox(
                height: 10,
              ),
              genderField(),
              const SizedBox(
                height: 10,
              ),
              birthDateField(),
              const SizedBox(
                height: 10,
              ),
              phoneField(),
              const SizedBox(
                height: 10,
              ),
              emailField(),
              const SizedBox(
                height: 10,
              ),
              imageField(),
            ],
          ),
        ),
      ),
    );
  }
}
