import 'package:flutter/material.dart';
import 'package:sasae_flutter_app/ui/setting/module/branding_color_tile.dart';
import 'package:sasae_flutter_app/ui/setting/module/theme_toggle_button.dart';

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
        _applicationLegalese =
            'A Social Service Application to bind NGOs and enthuhsiasts for social work.\n\n@BishalGhartiChhetri',
        _applicationIcon = const Icon(Icons.flutter_dash_rounded);

  final String _applicationName, _applicationVersion, _applicationLegalese;
  final Icon _applicationIcon;

  Widget about() => ListTile(
        leading: const Icon(Icons.info_rounded),
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
                              Text(_applicationLegalese,
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
        leading: const Icon(Icons.source_rounded),
        iconColor: Theme.of(context).colorScheme.secondary,
        textColor: Theme.of(context).colorScheme.onBackground,
        title: const Text('Licenses'),
        onTap: () {
          showLicensePage(
            context: context,
            applicationName: _applicationName,
            applicationVersion: _applicationVersion,
            applicationIcon: _applicationIcon,
            applicationLegalese: _applicationLegalese,
          );
        },
      );

  Widget themeToggleTile() => ListTile(
        iconColor: Theme.of(context).colorScheme.secondary,
        textColor: Theme.of(context).colorScheme.onBackground,
        leading: const Icon(Icons.contrast_rounded),
        title: const Text('Mode'),
        trailing: const ThemeToggleButton(),
      );

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        about(),
        licenses(),
        themeToggleTile(),
        const BrandingColorTile(),
      ],
    );
  }

  @override
  // ignore: todo
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
