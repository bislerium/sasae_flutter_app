import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle getTextStyle({
  double? fontSize,
  FontWeight? fontWeight,
  double? letterSpacing,
}) =>
    GoogleFonts.openSans(
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
    );

var textTheme = TextTheme(
  headline1: getTextStyle(
      fontSize: 96, fontWeight: FontWeight.w300, letterSpacing: -1.5),
  headline2: getTextStyle(
      fontSize: 60, fontWeight: FontWeight.w300, letterSpacing: -0.5),
  headline3: getTextStyle(fontSize: 48, fontWeight: FontWeight.w400),
  headline4: getTextStyle(
      fontSize: 34, fontWeight: FontWeight.w400, letterSpacing: 0.25),
  headline5: getTextStyle(fontSize: 24, fontWeight: FontWeight.w400),
  headline6: getTextStyle(
      fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: 0.15),
  subtitle1: getTextStyle(
      fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.15),
  subtitle2: getTextStyle(
      fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
  bodyText1: getTextStyle(
      fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
  bodyText2: getTextStyle(
      fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
  button: getTextStyle(
      fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1.25),
  caption: getTextStyle(
      fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
  overline: getTextStyle(
      fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5),
);
