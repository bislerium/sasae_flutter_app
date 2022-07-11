import 'dart:ui';

import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/theme_provider.dart';

class BrandingColorTile extends StatefulWidget {
  const BrandingColorTile({Key? key}) : super(key: key);

  @override
  State<BrandingColorTile> createState() => _BrandingColorTileState();
}

class _BrandingColorTileState extends State<BrandingColorTile> {
  late final ThemeProvider _themeP;
  // create some values
  late Color _pickedColor;
  late Color _selectedColor;

  @override
  void initState() {
    super.initState();
    _themeP = Provider.of<ThemeProvider>(context, listen: false);
    _pickedColor = _selectedColor = _themeP.getBrandingColor;
  }

  void showColorPickerDialog() => showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          backgroundColor: Colors.transparent,
          scrollable: true,
          content: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 8,
              sigmaY: 8,
            ),
            child: ColorPicker(
              onColorChanged: (color) => _selectedColor = color,
              color: _pickedColor,
              pickersEnabled: const <ColorPickerType, bool>{
                ColorPickerType.both: false,
                ColorPickerType.primary: true,
                ColorPickerType.accent: false,
                ColorPickerType.bw: false,
                ColorPickerType.custom: false,
                ColorPickerType.wheel: false
              },
              width: 60,
              height: 60,
              title: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Text(
                  'Branding Color',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              padding: EdgeInsets.zero,
              showMaterialName: false,
              enableOpacity: false,
              enableShadesSelection: false,
              enableTonalPalette: false,
              showRecentColors: false,
              copyPasteBehavior: const ColorPickerCopyPasteBehavior(
                  editFieldCopyButton: false, editUsesParsedPaste: false),
            ),
          ),
          actions: <Widget>[
            ElevatedButton.icon(
              icon: const Icon(Icons.change_circle_rounded),
              label: const Text('Channge'),
              onPressed: () {
                _themeP.setBrandingColor = _pickedColor = _selectedColor;
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return ListTile(
      iconColor: Theme.of(context).colorScheme.secondary,
      textColor: Theme.of(context).colorScheme.onBackground,
      leading: const Icon(Icons.palette_rounded),
      title: const Text('Color'),
      trailing: GestureDetector(
        onTap: showColorPickerDialog,
        child: CircleAvatar(
          backgroundColor: _pickedColor,
        ),
      ),
    );
  }
}
