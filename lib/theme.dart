import 'package:flutter/material.dart';

ThemeData themeData = ThemeData(
  brightness: Brightness.light,
  primaryColor: Color(0xff004c92),
  accentColor: Color(0xffd44454),
  scaffoldBackgroundColor: Color(0xfff2f5f8),
  fontFamily: 'Karla',
  textTheme: TextTheme(
          display1: TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.w700,
          ),
          headline: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w700,
          ),
          body1: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w300,
              fontFamily: 'Montserrat'),
          button: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w300,
              fontFamily: 'Montserrat'))
      .apply(
    bodyColor: Color(0xff5f6a80),
  ),
);