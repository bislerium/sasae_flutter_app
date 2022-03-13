import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/ngo_provider.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_fab.dart';
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
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'NGO Donation',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(right: 10, left: 10, top: 12, bottom: 5),
            child: RichText(
              textAlign: TextAlign.justify,
              text: TextSpan(
                  text:
                      'Making a donation is the ultimate sign of solidarity. Actions speak louder than words.',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 15,
                  ),
                  children: [
                    TextSpan(
                      text: '\n- Ibrahim Hooper',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        height: 1.6,
                      ),
                    )
                  ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Column(
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
                      FormBuilderValidators.required(context),
                      FormBuilderValidators.integer(context),
                      FormBuilderValidators.min(context, 50),
                      FormBuilderValidators.max(context, 100000),
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
                    child: const Text(
                      'Donate with Khalti',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
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
                              message: 'Payment Successful',
                            );
                          },
                          onFailure: (fa) {
                            showSnackBar(
                              context: context,
                              message: 'Payment Failed',
                            );
                          },
                          onCancel: () {
                            showSnackBar(
                                context: context, message: 'Payment Cancelled');
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
                  ),
                )
              ],
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Consumer<NGOProvider>(
      builder: (context, ngoP, child) => Visibility(
        visible: ngoP.ngoData != null && ngoP.ngoData!.isVerified,
        child: CustomFAB(
          text: 'Donate',
          icon: Icons.hail_rounded,
          background: Theme.of(context).colorScheme.primary,
          foreground: Theme.of(context).colorScheme.onPrimary,
          func: () {
            showDonationModalSheet(
              ngoP.ngoData!.epayAccount!,
              ngoP.ngoData!.orgName,
            );
          },
          width: 130,
          scrollController: widget.scrollController,
        ),
      ),
    );
  }
}
