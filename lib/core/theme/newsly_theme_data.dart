import 'package:flutter/material.dart';

import 'colors.dart';

class NewslyThemeData {

  static const primaryColor = Colors.white;
  static const accentColor = Color(0XFFAA2170);
  static const borderColor = Color(0XFFCCCCCC);
  static const textColor = Color(0XFF666666);
  static const iconColor = Color(0XFF666666);
  static const background = Color(0XFFE5E5E5);

  static ThemeData light() {
    final textTheme = _textTheme();
    return ThemeData(
      primaryColor: primaryColor,
      textTheme: textTheme,
      inputDecorationTheme: inputDecorationTheme(),
      primaryTextTheme: textTheme,
      appBarTheme: _appBarTheme(),
      colorScheme: ColorScheme.fromSwatch().copyWith(secondary: accentColor),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
      ),
    );
  }

  static AppBarTheme _appBarTheme() {
    return const AppBarTheme(
      elevation: 0,
      color: Colors.white,
      toolbarTextStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 12),
      titleTextStyle: TextStyle(color: kTextColor),
      iconTheme: IconThemeData(color: Colors.black),
    );
  }

  static TextTheme _textTheme() {
    return const TextTheme(
      headline5: TextStyle(color: kTextColor, fontFamily: "Roboto", fontWeight: FontWeight.bold, fontSize: 16,),
      bodyText1: TextStyle(color: kTextColor, fontFamily: "Roboto", fontSize: 14,),
      bodyText2: TextStyle(color: kTextColor, fontFamily: "Roboto", fontSize: 16,),
    );
  }

  static ThemeData dark() {
    final textTheme = _textTheme();

    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      textTheme: textTheme,
      inputDecorationTheme: inputDecorationTheme(),
      primaryTextTheme: textTheme,
      iconTheme: const IconThemeData(
        color: iconColor,
      ),
      // colorScheme: ColorScheme.fromSwatch().copyWith(secondary: accentColor),
    );
  }

  static InputDecorationTheme inputDecorationTheme() {

    var outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(11),
      borderSide: const BorderSide(
        color: borderColor,
        width: 2,
      ),
    );

    return InputDecorationTheme(
      fillColor: Colors.white,
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      enabledBorder: outlineInputBorder,
      focusedBorder: outlineInputBorder,
      disabledBorder: outlineInputBorder,
      border: outlineInputBorder,
      hintStyle: const TextStyle(
        color: textColor,
      ),
    );
  }

  static InputDecoration otpInputDecoration() {
    return InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
        enabledBorder: outlineInputBorder(),
        focusedBorder: outlineInputBorder(),
        counterText: "",
        border: outlineInputBorder()
    );
  }

  static OutlineInputBorder outlineInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0XFFE5E5E5)),
    );
  }
}