import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/ngo_provider.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_fab.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_scroll_animated_fab.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_widgets.dart';

class NGODonationButton extends StatefulWidget {
  final ScrollController scrollController;

  const NGODonationButton({Key? key, required this.scrollController})
      : super(key: key);

  @override
  State<NGODonationButton> createState() => _NGODonationButtonState();
}

class _NGODonationButtonState extends State<NGODonationButton> {
  final TextEditingController _amountTEC;
  final GlobalKey<FormBuilderState> _donationFormKey;

  _NGODonationButtonState()
      : _amountTEC = TextEditingController(),
        _donationFormKey = GlobalKey<FormBuilderState>();

  @override
  void dispose() {
    _amountTEC.dispose();
    super.dispose();
  }

  void showDonationModalSheet(String epayAccount, String donationTo) =>
      showModalSheet(
        ctx: context,
        topPadding: 40,
        bottomPadding: 20,
        leftPadding: 30,
        rightPadding: 30,
        children: [
          Text(
            'Donate to an NGO',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(
            height: 20,
          ),
          RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
                text:
                    'Making a donation is the ultimate sign of solidarity. Actions speak louder than words.',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                children: [
                  TextSpan(
                    text: '- Ibrahim Hooper',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      height: 1.6,
                    ),
                  )
                ]),
          ),
          const SizedBox(
            height: 20,
          ),
          Column(
            children: [
              FormBuilder(
                key: _donationFormKey,
                child: FormBuilderTextField(
                  name: 'donationAmount',
                  controller: _amountTEC,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.money_rounded),
                    labelText: 'Amount',
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.integer(),
                    FormBuilderValidators.min(10),
                    FormBuilderValidators.max(100000),
                  ]),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ConstrainedBox(
                constraints: const BoxConstraints.tightFor(
                    height: 60, width: double.infinity),
                child: ElevatedButton(
                  onPressed: () {
                    final isValid = _donationFormKey.currentState!.validate();
                    if (isValid) {
                      KhaltiScope.of(context)
                          .pay(
                        config: PaymentConfig(
                          amount: int.parse(_amountTEC.text) * 100,
                          productIdentity: 'dells-sssssg5-g5510-2021',
                          productName: 'NGO Donation: $donationTo',
                          // mobile: epayAccount,
                          // mobileReadOnly: true,
                        ),
                        preferences: [
                          // Not providing this will enable all the payment methods.
                          PaymentPreference.khalti,
                          PaymentPreference.connectIPS,
                          PaymentPreference.mobileBanking,
                        ],
                        onSuccess: (su) {
                          showSnackBar(
                            context: context,
                            message: 'Donation Successful',
                          );
                        },
                        onFailure: (fa) {
                          showSnackBar(
                            context: context,
                            message: 'Donation Failed',
                          );
                        },
                        onCancel: () {
                          showSnackBar(
                              context: context, message: 'Donation Cancelled');
                        },
                      )
                          .then((value) {
                        Navigator.of(context).pop();
                        _amountTEC.clear();
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                  ),
                  child: const Text(
                    'Donate with Khalti',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Consumer<NGOProvider>(
      builder: (context, ngoP, child) => CustomScrollAnimatedFAB(
        scrollController: widget.scrollController,
        child: CustomFAB(
          text: 'Donate',
          icon: Icons.hail_rounded,
          tooltip: 'Donate',
          func: () {
            showDonationModalSheet(
              ngoP.getNGO!.epayAccount!,
              ngoP.getNGO!.orgName,
            );
          },
        ),
      ),
    );
  }
}
