import 'package:flutter/material.dart';

final appTheme = ThemeData(
  primarySwatch: Colors.purple,
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
// TODO: dark theme has display issues
final darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.purple,
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
