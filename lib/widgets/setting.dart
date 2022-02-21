import 'package:flutter/material.dart';
import 'package:sasae_flutter_app/main.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> with AutomaticKeepAliveClientMixin {
  final String applicationName = 'Sasae';

  final String applicationVersion = 'v0.0.1';

  final Icon applicationIcon = const Icon(Icons.flutter_dash);

  final String applicationLegalese =
      'A Social Service Application to help NGO and the enthuhsiast people who wants to help others.';

  var isSwitched = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ListTile(
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
                            child: applicationIcon),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 24.0),
                            child: ListBody(
                              children: <Widget>[
                                Text(applicationName,
                                    style:
                                        Theme.of(context).textTheme.headline5),
                                Text(applicationVersion,
                                    style:
                                        Theme.of(context).textTheme.bodyText2),
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
                    child: Text(
                        MaterialLocalizations.of(context).closeButtonLabel),
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
        ),
        ListTile(
          leading: const Icon(Icons.source),
          iconColor: Theme.of(context).colorScheme.secondary,
          textColor: Theme.of(context).colorScheme.onBackground,
          title: const Text('Licenses'),
          onTap: () {
            showLicensePage(
              context: context,
              applicationName: applicationName,
              applicationVersion: applicationVersion,
              applicationIcon: applicationIcon,
              applicationLegalese: applicationLegalese,
            );
          },
        ),
        ListTile(
          iconColor: Theme.of(context).colorScheme.secondary,
          textColor: Theme.of(context).colorScheme.onBackground,
          leading: const Icon(Icons.dark_mode_rounded),
          title: const Text('Dark Mode'),
          trailing: Switch(
            value: isSwitched,
            activeColor: Theme.of(context).colorScheme.secondary,
            onChanged: (value) {
              setState(() {
                isSwitched = value;
                MyApp.of(context)?.enableDarkMode(value);
              });
            },
          ),
        )
      ],
    );
  }

  @override
  // ignore: todo
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
