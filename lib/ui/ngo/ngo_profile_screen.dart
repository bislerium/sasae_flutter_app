import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/auth_provider.dart';
import 'package:sasae_flutter_app/providers/fab_provider.dart';
import 'package:sasae_flutter_app/providers/profile_provider.dart';
import 'package:sasae_flutter_app/ui/ngo/module/ngo_info_tab.dart';
import 'package:sasae_flutter_app/ui/profile/tab/info_post_tab_view.dart';
import 'package:sasae_flutter_app/widgets/misc/annotated_scaffold.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_appbar.dart';
import 'package:sasae_flutter_app/ui/profile/tab/profile_post_tab.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:sasae_flutter_app/providers/ngo_provider.dart';
import 'package:sasae_flutter_app/services/utilities.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_fab.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_scroll_animated_fab.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_widgets.dart';

class NGOProfileScreen extends StatefulWidget {
  static const String routeName = '/ngo/profile';
  final int ngoID;

  const NGOProfileScreen({Key? key, required this.ngoID}) : super(key: key);

  @override
  State<NGOProfileScreen> createState() => _NGOProfileScreenState();
}

class _NGOProfileScreenState extends State<NGOProfileScreen> {
  final ScrollController _infoScrollController;
  final ScrollController _postScrollController;

  _NGOProfileScreenState()
      : _infoScrollController = ScrollController(),
        _postScrollController = ScrollController();
  @override
  void dispose() {
    _infoScrollController.dispose();
    _postScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedScaffold(
      child: Scaffold(
        appBar: const CustomAppBar(
          title: 'View NGO',
        ),
        body: InfoPostTab(
          infoTab: NGOInfoTab(
            ngoID: widget.ngoID,
            scrollController: _infoScrollController,
          ),
          postTab: NGOProfilePostTab(
            userID: widget.ngoID,
            userType: UserType.ngo,
            scrollController: _postScrollController,
          ),
          infoScrollController: _infoScrollController,
          postScrollController: _postScrollController,
          tabBarMargin: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          fabType: FABType.donation,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton:
            Provider.of<DonationFABProvider>(context).getShowFAB
                ? NGODonationButton(
                    scrollController: _infoScrollController,
                  )
                : null,
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

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
                    if (!isInternetConnected(context)) return;
                    final isValid = _donationFormKey.currentState!.validate();
                    if (isValid) {
                      KhaltiScope.of(context)
                          .pay(
                        config: PaymentConfig(
                          amount: int.parse(_amountTEC.text) * 100,
                          productIdentity:
                              '[${Provider.of<AuthProvider>(context, listen: false).getAuth!.accountID}] [${donationTo.toLowerCase()}]',
                          productName: 'NGO Donation',
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
                            errorSnackBar: true,
                            message: 'Donation Failed',
                          );
                        },
                        onCancel: () {
                          showSnackBar(
                            context: context,
                            errorSnackBar: true,
                            message: 'Donation Cancelled',
                          );
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
            if (!isInternetConnected(context)) return;
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
