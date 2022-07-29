import 'dart:ui';

import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/startup_provider.dart';
import 'package:sasae_flutter_app/ui/setting/setting_page.dart';

class BrandingColorTile extends StatefulWidget {
  const BrandingColorTile({Key? key}) : super(key: key);

  @override
  State<BrandingColorTile> createState() => _BrandingColorTileState();
}

class _BrandingColorTileState extends State<BrandingColorTile> {
  late final StartupConfigProvider _themeP;
  // create some values
  late Color _pickedColor;
  late Color _selectedColor;

  @override
  void initState() {
    super.initState();
    _themeP = Provider.of<StartupConfigProvider>(context, listen: false);
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
                child: Chip(
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  label: Text(
                    'Branding Color',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                  ),
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
    return SettingTile(
      leadingIcon: Icons.palette_rounded,
      title: 'Color',
      trailing: GestureDetector(
        onTap: showColorPickerDialog,
        child: CircleAvatar(
          backgroundColor: _pickedColor,
        ),
      ),
    );
  }
}
