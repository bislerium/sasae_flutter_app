import 'package:flutter/widgets.dart';

class CustomIcons {
  CustomIcons._();

  static const _kFontFamSasae = 'SasaeIcon';
  static const _kFontFamCompass = 'CompassIcon';
  static const String? _kFontPkg = null;

  static const IconData sasae =
      IconData(0xe800, fontFamily: _kFontFamSasae, fontPackage: _kFontPkg);

  static const IconData compass =
      IconData(0xe801, fontFamily: _kFontFamCompass, fontPackage: _kFontPkg);
}
