import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sasae_flutter_app/providers/startup_provider.dart';
import 'package:sasae_flutter_app/ui/misc/custom_widgets.dart';
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

  void showColorPickerDialog() => showModalSheet(
        context: context,
        children: [
          Text(
            'Branding Color',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(
            height: 20,
          ),
          ColorPicker(
            onColorChanged: (color) => _selectedColor = color,
            color: _pickedColor,
            pickersEnabled: const <ColorPickerType, bool>{
              ColorPickerType.both: false,
              ColorPickerType.primary: true,
              ColorPickerType.accent: true,
              ColorPickerType.bw: false,
              ColorPickerType.custom: false,
              ColorPickerType.wheel: true
            },
            width: 85,
            height: 65,
            spacing: 8,
            runSpacing: 8,
            wheelDiameter: 260,
            padding: EdgeInsets.zero,
            showMaterialName: false,
            enableOpacity: false,
            enableShadesSelection: false,
            enableTonalPalette: false,
            showRecentColors: false,
            copyPasteBehavior: const ColorPickerCopyPasteBehavior(
                editFieldCopyButton: false, editUsesParsedPaste: false),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 60,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  flex: 10,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Cancel',
                    ),
                  ),
                ),
                const Spacer(
                  flex: 1,
                ),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 10,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.sync_rounded),
                    label: const Text('Change'),
                    onPressed: () {
                      _themeP.setBrandingColor = _pickedColor = _selectedColor;
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
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
