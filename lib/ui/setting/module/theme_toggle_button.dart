import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:sasae_flutter_app/main.dart';

class ThemeToggleButton extends StatefulWidget {
  const ThemeToggleButton({Key? key}) : super(key: key);

  @override
  State<ThemeToggleButton> createState() => _ThemeToggleButtonState();
}

class _ThemeToggleButtonState extends State<ThemeToggleButton> {
  // Light, Dark, System
  final List<bool> _toggleButtonsState = [false, false, false];

  @override
  void initState() {
    super.initState();
    deviceThemeMode != null
        ? _toggleButtonsState[deviceThemeMode!.index] = true
        : _toggleButtonsState[2] = true;
  }

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      children: const [
        Icon(Icons.light_mode_rounded),
        Icon(Icons.dark_mode_rounded),
        Icon(Icons.brightness_medium_rounded),
      ],
      onPressed: (int index) {
        setState(() {
          switch (index) {
            case 0:
              AdaptiveTheme.of(context).setLight();
              break;
            case 1:
              AdaptiveTheme.of(context).setDark();
              break;
            case 2:
              AdaptiveTheme.of(context).setSystem();
              break;
          }
          for (int buttonIndex = 0;
              buttonIndex < _toggleButtonsState.length;
              buttonIndex++) {
            if (buttonIndex == index) {
              _toggleButtonsState[buttonIndex] = true;
            } else {
              _toggleButtonsState[buttonIndex] = false;
            }
          }
        });
      },
      isSelected: _toggleButtonsState,
    );
  }
}
