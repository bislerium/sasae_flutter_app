import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/people_provider.dart';
import 'package:sasae_flutter_app/services/utilities.dart';
import 'package:sasae_flutter_app/widgets/misc/annotated_scaffold.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_appbar.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_loading.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_widgets.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/auth/register';
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isLoading = false;
  final GlobalKey<FormBuilderState> _personalInfoFormKey;
  final GlobalKey<FormBuilderState> _addressFormKey;
  final GlobalKey<FormBuilderState> _contactFormKey;
  final GlobalKey<FormBuilderState> _accountFormKey;
  final GlobalKey<FormBuilderState> _verifyFormKey;

  final TextEditingController _passwordTEC;
  int _currentStep;
  final List<bool> _stepErrors;

  _RegisterScreenState()
      : _personalInfoFormKey = GlobalKey<FormBuilderState>(),
        _addressFormKey = GlobalKey<FormBuilderState>(),
        _contactFormKey = GlobalKey<FormBuilderState>(),
        _accountFormKey = GlobalKey<FormBuilderState>(),
        _verifyFormKey = GlobalKey<FormBuilderState>(),
        _passwordTEC = TextEditingController(),
        _currentStep = 0,
        _stepErrors = [
          false,
          false,
          false,
          false,
        ];

  String? _fullname;
  String? _gender;
  DateTime? _birthdate;
  String? _country;
  String? _province;
  String? _cityLocality;
  String? _stAddressHouseNum;
  String? _phone;
  String? _email;
  XFile? _displayPicture;
  String? _username;
  XFile? _citizenshipPhoto;

  @override
  void dispose() {
    _passwordTEC.dispose();
    super.dispose();
  }

  ListTile getPostModalItem(
      BuildContext ctx, IconData icon, String title, VoidCallback func) {
    return ListTile(
      leading: Icon(
        icon,
        size: 30,
        color: Theme.of(ctx).primaryColor,
      ),
      title: Text(title),
      onTap: func,
    );
  }

  Widget fullnameField() => FormBuilderTextField(
        name: 'full_name',
        decoration: const InputDecoration(
          label: Text('Full name'),
          icon: Icon(Icons.person),
        ),
        validator: FormBuilderValidators.compose(
          [FormBuilderValidators.required()],
        ),
        onSaved: (value) => _fullname = value,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.name,
      );

  Widget _genderField() => FormBuilderDropdown(
        name: 'gender',
        decoration: const InputDecoration(
          icon: Icon(Icons.transgender),
          labelText: 'Gender',
        ),
        validator: FormBuilderValidators.compose(
          [FormBuilderValidators.required()],
        ),
        onSaved: (value) => _gender = value.toString(),
        items: ['Male', 'Female', 'LGBTQ+']
            .map((String value) => DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                ))
            .toList(),
      );

  Widget _birthDateField() => FormBuilderDateTimePicker(
        name: 'RequestDuration',
        inputType: InputType.date,
        decoration: const InputDecoration(
          labelText: 'Birthdate',
          icon: Icon(Icons.calendar_today_rounded),
        ),
        firstDate: DateTime.now().subtract(const Duration(days: 365 * 122)),
        currentDate: DateTime.now(),
        validator: FormBuilderValidators.compose(
          [
            FormBuilderValidators.required(),
            (value) => value!.isAfter(
                    DateTime.now().subtract(const Duration(days: 365 * 16)))
                ? 'Must be 16 years or older'
                : null
          ],
        ),
        onSaved: (value) => _birthdate = value,
      );

  Widget countryField() => FormBuilderTextField(
        name: 'country',
        decoration: const InputDecoration(
          label: Text('Country'),
          icon: Icon(Icons.flag_rounded),
        ),
        validator: FormBuilderValidators.compose(
          [FormBuilderValidators.required()],
        ),
        onSaved: (value) => _country = value,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.text,
      );

  Widget provinceField() => FormBuilderTextField(
        name: 'province',
        decoration: const InputDecoration(
          label: Text('Province'),
          icon: Icon(Icons.local_parking_rounded),
        ),
        validator: FormBuilderValidators.compose(
          [FormBuilderValidators.required()],
        ),
        onSaved: (value) => _province = value,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
      );

  Widget cityLocalityField() => FormBuilderTextField(
        name: 'city_locality',
        decoration: const InputDecoration(
          label: Text('City/Locality'),
          icon: Icon(Icons.location_city_rounded),
        ),
        validator: FormBuilderValidators.compose(
          [FormBuilderValidators.required()],
        ),
        onSaved: (value) => _cityLocality = value,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.text,
      );

  Widget streetHouseField() => FormBuilderTextField(
        name: 'street_house',
        decoration: const InputDecoration(
          label: Text('Street name/House number'),
          icon: Icon(Icons.near_me),
        ),
        validator: FormBuilderValidators.compose(
          [FormBuilderValidators.required()],
        ),
        onSaved: (value) => _stAddressHouseNum = value,
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.streetAddress,
      );

  Widget phoneField() => FormBuilderTextField(
        name: 'phone',
        decoration: const InputDecoration(
          label: Text('Phone'),
          icon: Icon(Icons.phone_android_rounded),
          hintText: 'E.g. 9800740959',
        ),
        onSaved: (value) => _phone = value,
        validator: FormBuilderValidators.compose(
          [
            FormBuilderValidators.required(),
            FormBuilderValidators.match(r'(^[9][678][0-9]{8}$)',
                errorText: 'Must be valid number'),
          ],
        ),
        keyboardType: TextInputType.phone,
        textInputAction: TextInputAction.next,
      );

  Widget emailField() => FormBuilderTextField(
        name: 'email',
        decoration: const InputDecoration(
          label: Text('Email'),
          icon: Icon(Icons.email_rounded),
          hintText: 'Only unique email is accepted',
        ),
        onSaved: (value) => _email = value,
        validator: FormBuilderValidators.compose(
          [
            FormBuilderValidators.required(),
            FormBuilderValidators.email(),
          ],
        ),
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.done,
      );

  Widget displayPictureField() => FormBuilderImagePicker(
        name: 'display_picture',
        decoration: const InputDecoration(
          labelText: 'Display picture',
        ),
        iconColor: Theme.of(context).colorScheme.secondaryContainer,
        previewWidth: MediaQuery.of(context).size.width * 0.8,
        previewHeight: MediaQuery.of(context).size.width * 0.8,
        onSaved: (value) => _displayPicture = value?.first,
        maxImages: 1,
      );

  Widget usernameField() => FormBuilderTextField(
        name: 'userrname',
        decoration: const InputDecoration(
          label: Text('Username'),
          icon: Icon(Icons.account_circle_rounded),
        ),
        validator: FormBuilderValidators.compose(
          [
            FormBuilderValidators.required(),
            FormBuilderValidators.maxLength(15),
            (value) =>
                value!.contains(' ') ? 'Username must be spaceless' : null
          ],
        ),
        maxLength: 15,
        onSaved: (value) => _username = value,
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.next,
      );

  Widget password1Field() => FormBuilderTextField(
        name: 'password1',
        controller: _passwordTEC,
        decoration: const InputDecoration(
          label: Text('Password'),
          icon: Icon(Icons.password_rounded),
        ),
        validator: FormBuilderValidators.compose(
          [
            FormBuilderValidators.required(),
            FormBuilderValidators.minLength(12,
                errorText: 'Password must be 12 to 20 characters long'),
            FormBuilderValidators.maxLength(20),
          ],
        ),
        keyboardType: TextInputType.visiblePassword,
        textInputAction: TextInputAction.next,
      );

  Widget password2Field() => FormBuilderTextField(
        name: 'password2',
        decoration: const InputDecoration(
          label: Text('Confirm password'),
          icon: Icon(Icons.password_rounded),
        ),
        validator: FormBuilderValidators.compose(
          [
            FormBuilderValidators.required(),
            (value) =>
                (_passwordTEC.text != value) ? 'Passwords did not match' : null
          ],
        ),
        keyboardType: TextInputType.visiblePassword,
        textInputAction: TextInputAction.next,
      );

  Widget citizenshipField() => FormBuilderImagePicker(
        name: 'Citizenship photo',
        decoration: const InputDecoration(
          labelText: 'Attach a photo',
        ),
        iconColor: Theme.of(context).colorScheme.secondaryContainer,
        onSaved: (value) => _citizenshipPhoto = value?.first,
        previewWidth: MediaQuery.of(context).size.width * 0.8,
        previewHeight: MediaQuery.of(context).size.width * 0.8,
        maxImages: 1,
      );

  List<Step> getSteps() => [
        Step(
          state: _stepErrors[0]
              ? StepState.error
              : _currentStep > 0
                  ? StepState.complete
                  : StepState.indexed,
          isActive: _currentStep >= 0,
          title: const Text('Personal Info'),
          content: FormBuilder(
            key: _personalInfoFormKey,
            child: Column(
              children: [
                fullnameField(),
                const SizedBox(
                  height: 10,
                ),
                _genderField(),
                const SizedBox(
                  height: 10,
                ),
                _birthDateField(),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
        Step(
          state: _stepErrors[1]
              ? StepState.error
              : _currentStep > 1
                  ? StepState.complete
                  : StepState.indexed,
          isActive: _currentStep >= 1,
          title: const Text('Address'),
          content: FormBuilder(
            key: _addressFormKey,
            child: Column(
              children: [
                countryField(),
                const SizedBox(
                  height: 10,
                ),
                provinceField(),
                const SizedBox(
                  height: 10,
                ),
                cityLocalityField(),
                const SizedBox(
                  height: 10,
                ),
                streetHouseField(),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
        Step(
          state: _stepErrors[2]
              ? StepState.error
              : _currentStep > 2
                  ? StepState.complete
                  : StepState.indexed,
          isActive: _currentStep >= 2,
          title: const Text('Contact'),
          subtitle: const Text(
              'Email is not only used to contact but also to secure your account.'),
          content: FormBuilder(
            key: _contactFormKey,
            child: Column(
              children: [
                phoneField(),
                const SizedBox(
                  height: 10,
                ),
                emailField(),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
        Step(
          state: _stepErrors[3]
              ? StepState.error
              : _currentStep > 3
                  ? StepState.complete
                  : StepState.indexed,
          isActive: _currentStep >= 3,
          title: const Text('Account'),
          subtitle: const Text('Profile picture is optional.'),
          content: FormBuilder(
            key: _accountFormKey,
            child: Column(
              children: [
                displayPictureField(),
                const SizedBox(
                  height: 10,
                ),
                usernameField(),
                const SizedBox(
                  height: 10,
                ),
                password1Field(),
                const SizedBox(
                  height: 10,
                ),
                password2Field(),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
        Step(
          state: _currentStep > 4 ? StepState.complete : StepState.indexed,
          isActive: _currentStep >= 4,
          title: const Text('Verify'),
          subtitle: const Text(
              'This is optional.\n Please email us for profile verification.'),
          content: Column(
            children: [
              FormBuilder(
                key: _verifyFormKey,
                child: citizenshipField(),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ];

  List<bool Function()> validity() => [
        () => _personalInfoFormKey.currentState!.validate(),
        () => _addressFormKey.currentState!.validate(),
        () => _contactFormKey.currentState!.validate(),
        () => _accountFormKey.currentState!.validate(),
      ];

  @override
  Widget build(BuildContext context) {
    var isLastStep = _currentStep == getSteps().length - 1;
    return AnnotatedScaffold(
      child: Scaffold(
        appBar: const CustomAppBar(
          title: 'Register',
        ),
        body: Stepper(
          type: StepperType.vertical,
          steps: getSteps(),
          currentStep: _currentStep,
          onStepContinue: () async {
            if (_isLoading) return;
            if (isLastStep) {
              if (_stepErrors.contains(true)) {
                showSnackBar(
                  context: context,
                  message: 'Please fill required fields',
                  errorSnackBar: true,
                );
              } else {
                if (!isInternetConnected(context)) return;
                setState(() => _isLoading = true);
                _personalInfoFormKey.currentState!.save();
                _contactFormKey.currentState!.save();
                _addressFormKey.currentState!.save();
                _accountFormKey.currentState!.save();
                _verifyFormKey.currentState!.save();

                bool success =
                    await Provider.of<PeopleProvider>(context, listen: false)
                        .registerPeople(
                  username: _username!,
                  email: _email!,
                  password: _passwordTEC.text,
                  fullname: _fullname!,
                  gender: _gender!,
                  dob: _birthdate!,
                  address:
                      '$_stAddressHouseNum, $_cityLocality, $_province, $_country',
                  phone: _phone.toString(),
                  displayPicture: _displayPicture,
                  citizenshipPhoto: _citizenshipPhoto,
                );
                setState(() => _isLoading = false);

                if (success) {
                  if (!mounted) return;
                  Navigator.of(context).pop();
                  showSnackBar(
                    context: context,
                    message: 'Successfully registered',
                  );
                } else {
                  showSnackBar(
                    context: context,
                    errorSnackBar: true,
                  );
                }
              }
            } else {
              var valid = validity()[_currentStep]();
              setState(() {
                _stepErrors[_currentStep] = !valid;
                _currentStep++;
              });
            }
          },
          onStepCancel: () {
            if (_currentStep == 0) {
              null;
            } else {
              setState(() {
                _currentStep--;
              });
            }
          },
          onStepTapped: (value) {
            setState(() {
              if (!isLastStep) {
                for (int i = 0; i < value; i++) {
                  _stepErrors[i] = !validity()[i]();
                }
              }
              _currentStep = value;
            });
          },
          controlsBuilder: (BuildContext context, ControlsDetails details) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              height: 60,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: details.onStepCancel,
                      child: const Text(
                        'Back',
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: details.onStepContinue,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          isLastStep & _isLoading
                              ? const ButtomLoading()
                              : isLastStep & !_isLoading
                                  ? const Icon(Icons.how_to_reg)
                                  : const Icon(
                                      Icons.navigate_next,
                                    ),
                          if ((!_isLoading & isLastStep) || !isLastStep) ...[
                            const SizedBox(
                              width: 6,
                            ),
                            Text(
                              isLastStep ? 'Register' : 'Next',
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
