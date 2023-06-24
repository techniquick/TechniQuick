import 'package:flutter/material.dart';

import '../constant.dart';

abstract class TextStyles {
  static TextStyle headLine31 = const TextStyle(
    fontSize: 28,
    fontFamily: "Inter",
    fontWeight: FontWeight.bold,
  );
  static TextStyle textButton14 = const TextStyle(
      fontSize: 14,
      fontFamily: "Inter",
      fontWeight: FontWeight.w800,
      color: mainColor);
  static TextStyle bodyText12 = const TextStyle(
    fontSize: 12,
    fontFamily: "Inter",
    fontWeight: FontWeight.w400,
  );
  static TextStyle bodyText14 = const TextStyle(
    fontSize: 14,
    fontFamily: "Inter",
    fontWeight: FontWeight.w400,
  );
  static TextStyle bodyText16 = const TextStyle(
    fontSize: 14,
    fontFamily: "Inter",
    fontWeight: FontWeight.w500,
  );
  static TextStyle bodyText18 = const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      fontFamily: "Inter",
      color: black);
  static TextStyle bodyText20 = const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      fontFamily: "Inter",
      color: black);
  static TextStyle bodyText28 = const TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      fontFamily: "Inter",
      color: black);
  static TextStyle buttonText16 = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w800,
      fontFamily: "Inter",
      color: white);
}
