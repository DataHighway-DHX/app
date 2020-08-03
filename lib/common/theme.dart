import 'package:flutter/material.dart';

final appTheme = ThemeData(
  primarySwatch: Colors.deepPurple,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    color: Colors.white,
    brightness: Brightness.light,
    elevation: 1,
    actionsIconTheme: IconThemeData(color: Colors.black),
    iconTheme: IconThemeData(color: Colors.black),
    textTheme: TextTheme(
      headline6: TextStyle(
        color: Colors.black,
        fontFamily: 'Roboto',
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
    ),
  ),
  textTheme: TextTheme(
    display1: TextStyle(
      fontSize: 24,
    ),
    display2: TextStyle(
      fontSize: 22,
    ),
    display3: TextStyle(
      fontSize: 20,
    ),
    display4: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Color(0xFF4665EA),
    ),
    button: TextStyle(
      color: Colors.white,
      fontSize: 18,
    ),
  ).copyWith(
    subtitle1: TextStyle(
      fontSize: 16,
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w500,
    ),
  ),
);
// TODO: dark theme has display issues
final darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.deepPurple,
  textTheme: TextTheme(
      display1: TextStyle(
        fontSize: 24,
      ),
      display2: TextStyle(
        fontSize: 22,
      ),
      display3: TextStyle(
        fontSize: 20,
      ),
      display4: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      button: TextStyle(
        color: Colors.white,
        fontSize: 18,
      )),
);
