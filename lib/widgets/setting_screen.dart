import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/app_preference_provider.dart';
import 'package:sasae_flutter_app/providers/auth_provider.dart';
import 'package:sasae_flutter_app/widgets/auth/auth_screen.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_fab.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_widgets.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen>
    with AutomaticKeepAliveClientMixin {
  _SettingScreenState()
      : _applicationName = 'Sasae',
        _applicationVersion = 'v0.0.1',
        _applicationIcon = const Icon(Icons.flutter_dash),
        _scrollController = ScrollController();

  final String _applicationName;
  final String _applicationVersion;
  final Icon _applicationIcon;
  final ScrollController _scrollController;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  final String applicationLegalese =
      'A Social Service Application to help NGO and the enthuhsiast people who wants to help others.';

  Widget fab() => CustomFAB(
        text: 'Logout',
        icon: Icons.logout,
        func: () => showCustomDialog(
            context: context,
            title: 'Logout',
            content: 'Do it with passion or not at all',
            okFunc: () async {
              var _ = Provider.of<AuthProvider>(context, listen: false);
              bool success = await _.logout();
              if (success) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    AuthScreen.routeName, (Route<dynamic> route) => false);
              } else {
                showSnackBar(
                    context: context,
                    message: 'Unable to logout!',
                    errorSnackBar: true);
              }
            }),
        foreground: Theme.of(context).colorScheme.onError,
        background: Theme.of(context).colorScheme.error,
      );

  Widget about() => ListTile(
        leading: const Icon(Icons.info),
        iconColor: Theme.of(context).colorScheme.secondary,
        textColor: Theme.of(context).colorScheme.onBackground,
        title: const Text('About'),
        onTap: () => showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: ListBody(
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      IconTheme(
                          data: Theme.of(context).iconTheme,
                          child: _applicationIcon),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: ListBody(
                            children: <Widget>[
                              Text(_applicationName,
                                  style: Theme.of(context).textTheme.headline5),
                              Text(_applicationVersion,
                                  style: Theme.of(context).textTheme.bodyText2),
                              const SizedBox(height: 18),
                              Text(applicationLegalese,
                                  style: Theme.of(context).textTheme.caption),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child:
                      Text(MaterialLocalizations.of(context).closeButtonLabel),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
              scrollable: true,
            );
          },
          barrierDismissible: false,
        ),
      );

  Widget licenses() => ListTile(
        leading: const Icon(Icons.source),
        iconColor: Theme.of(context).colorScheme.secondary,
        textColor: Theme.of(context).colorScheme.onBackground,
        title: const Text('Licenses'),
        onTap: () {
          showLicensePage(
            context: context,
            applicationName: _applicationName,
            applicationVersion: _applicationVersion,
            applicationIcon: _applicationIcon,
            applicationLegalese: applicationLegalese,
          );
        },
      );

  Widget darkMode() => Consumer<AppPreferenceProvider>(
        builder: (context, appPreference, child) => ListTile(
          iconColor: Theme.of(context).colorScheme.secondary,
          textColor: Theme.of(context).colorScheme.onBackground,
          leading: const Icon(Icons.dark_mode_rounded),
          title: const Text('Dark Mode'),
          trailing: Switch(
            activeColor: Theme.of(context).colorScheme.secondary,
            onChanged: (value) {
              appPreference.toggleDarkMode();
            },
            value: appPreference.darkMode,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          about(),
          licenses(),
          darkMode(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: fab(),
    );
  }

  @override
  // ignore: todo
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
