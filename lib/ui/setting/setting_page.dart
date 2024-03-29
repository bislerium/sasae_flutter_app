import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/startup_provider.dart';
import 'package:sasae_flutter_app/ui/icon/custom_icons.dart';
import 'package:sasae_flutter_app/ui/setting/module/branding_color_tile.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sasae_flutter_app/ui/setting/module/theme_toggle_button.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen>
    with AutomaticKeepAliveClientMixin {
  _SettingScreenState()
      : _applicationLegalese =
            'A Social Service Application to bind NGOs and enthuhsiasts for effective & efficient social work.\n\n@BishalGhartiChhetri',
        _applicationIcon = const Icon(CustomIcons.sasae);

  late final PackageInfo _packageInfo;

  @override
  void initState() {
    super.initState();
    _setPackageInfo();
  }

  Future<void> _setPackageInfo() async {
    _packageInfo = await PackageInfo.fromPlatform();
    _applicationName = _packageInfo.appName;
    _applicationVersion =
        'v${_packageInfo.version} (build ${_packageInfo.buildNumber})';
  }

  late final String _applicationName, _applicationVersion, _applicationLegalese;
  final Icon _applicationIcon;

  Widget about() => SettingTile(
        leadingIcon: Icons.info_rounded,
        title: 'About',
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

  Widget licenses() => SettingTile(
        leadingIcon: Icons.source_rounded,
        title: 'Licenses',
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

  Widget themeToggleTile() => const SettingTile(
        leadingIcon: Icons.contrast_rounded,
        title: 'Mode',
        trailing: ThemeToggleButton(),
      );

  Widget shakeToFeedback() => const SettingTile(
        leadingIcon: Icons.feedback_rounded,
        title: 'Shake to feedback',
        trailing: ToggleShapeToFeedbackSwitch(),
      );

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          about(),
          licenses(),
          themeToggleTile(),
          const BrandingColorTile(),
          shakeToFeedback(),
        ],
      ),
    );
  }

  @override
  // ignore: todo
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class SettingTile extends StatelessWidget {
  final IconData leadingIcon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  const SettingTile(
      {Key? key,
      required this.leadingIcon,
      required this.title,
      this.trailing,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: ListTile(
          shape: const StadiumBorder(),
          iconColor: Theme.of(context).colorScheme.secondary,
          textColor: Theme.of(context).colorScheme.onBackground,
          leading: Icon(leadingIcon),
          title: Text(title),
          trailing: trailing,
          onTap: onTap,
        ),
      );
}

class ToggleShapeToFeedbackSwitch extends StatefulWidget {
  const ToggleShapeToFeedbackSwitch({Key? key}) : super(key: key);

  @override
  State<ToggleShapeToFeedbackSwitch> createState() =>
      _ToggleShapeToFeedbackSwitchState();
}

class _ToggleShapeToFeedbackSwitchState
    extends State<ToggleShapeToFeedbackSwitch> {
  late final StartupConfigProvider _startupP;
  late bool _toggleValue;

  @override
  void initState() {
    super.initState();
    _startupP = Provider.of<StartupConfigProvider>(context, listen: false);
    _toggleValue = _startupP.getShakeToFeedback;
  }

  @override
  Widget build(BuildContext context) => Switch(
        value: _toggleValue,
        activeColor: Theme.of(context).colorScheme.primary,
        onChanged: ((value) {
          if (_toggleValue != value) {
            _startupP.setShakeToFeedback(value);
            setState(() => _toggleValue = value);
          }
        }),
      );
}
