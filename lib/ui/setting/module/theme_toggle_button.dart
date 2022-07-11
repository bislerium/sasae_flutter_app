import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/main.dart';
import 'package:sasae_flutter_app/providers/theme_provider.dart';

class ThemeToggleButton extends StatefulWidget {
  const ThemeToggleButton({Key? key}) : super(key: key);

  @override
  State<ThemeToggleButton> createState() => _ThemeToggleButtonState();
}

class _ThemeToggleButtonState extends State<ThemeToggleButton> {
  // Light, Dark, System
  final List<bool> _toggleButtonsState = [false, false, false];
  late final ThemeProvider themeP;

  @override
  void initState() {
    super.initState();
    themeP = Provider.of<ThemeProvider>(context, listen: false);
    _toggleButtonsState[themeP.getThemeMode.index - 1] = true;
  }

  void setToggleButtonState(
      {bool light = false, bool dark = false, bool system = false}) {
    setState(() {
      _toggleButtonsState[0] = light;
      _toggleButtonsState[1] = dark;
      _toggleButtonsState[2] = system;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      onPressed: (int index) {
        switch (index) {
          case 0:
            themeP.setThemeMode = ThemeMode.light;
            setToggleButtonState(light: true);
            break;
          case 1:
            themeP.setThemeMode = ThemeMode.dark;
            setToggleButtonState(dark: true);
            break;
          case 2:
            themeP.setThemeMode = ThemeMode.system;
            setToggleButtonState(system: true);
            break;
        }
      },
      isSelected: _toggleButtonsState,
      children: const [
        Tooltip(
          message: 'Light Theme',
          child: Icon(Icons.light_mode_rounded),
        ),
        Tooltip(
          message: 'Dark Theme',
          child: Icon(Icons.dark_mode_rounded),
        ),
        Tooltip(
          message: 'System Theme',
          child: Icon(Icons.brightness_medium_rounded),
        ),
      ],
    );
  }
}
