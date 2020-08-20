import 'package:flutter/material.dart';

final appTheme = ThemeData(
  primaryColor: Color(0xFF4665EA),
  scaffoldBackgroundColor: Colors.white,
  cardTheme: CardTheme(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  ),
  bottomAppBarTheme: BottomAppBarTheme(color: Colors.white),
  bottomAppBarColor: Colors.white,
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
      fontWeight: FontWeight.bold,
      fontSize: 20,
      color: Colors.black,
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
    bodyText1: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: Color(0xFF939393),
    ),
    bodyText2: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    ),
    subtitle1: TextStyle(
      fontSize: 16,
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w500,
    ),
    subtitle2: TextStyle(
      fontSize: 16,
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w400,
    ),
  ),
);
// TODO: dark theme has display issues
final darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.deepPurple,
  textTheme: TextTheme(
      headline1: TextStyle(
        fontSize: 24,
      ),
      headline2: TextStyle(
        fontSize: 22,
      ),
      headline3: TextStyle(
        fontSize: 20,
      ),
      headline4: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      button: TextStyle(
        color: Colors.white,
        fontSize: 18,
      )),
);

const MaterialColor kusamaBlack = const MaterialColor(
  0xFF222222,
  const <int, Color>{
    50: const Color(0xFF555555),
    100: const Color(0xFF444444),
    200: const Color(0xFF444444),
    300: const Color(0xFF333333),
    400: const Color(0xFF333333),
    500: const Color(0xFF222222),
    600: const Color(0xFF111111),
    700: const Color(0xFF111111),
    800: const Color(0xFF000000),
    900: const Color(0xFF000000),
  },
);

final appThemeKusama = ThemeData(
  primarySwatch: kusamaBlack,
  textTheme: TextTheme(
      headline1: TextStyle(
        fontSize: 24,
      ),
      headline2: TextStyle(
        fontSize: 22,
      ),
      headline3: TextStyle(
        fontSize: 20,
      ),
      headline4: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      button: TextStyle(
        color: Colors.white,
        fontSize: 18,
      )),
);

final appThemeAcala = ThemeData(
  primarySwatch: Colors.indigo,
  textTheme: TextTheme(
      headline1: TextStyle(
        fontSize: 24,
      ),
      headline2: TextStyle(
        fontSize: 22,
      ),
      headline3: TextStyle(
        fontSize: 20,
      ),
      headline4: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      button: TextStyle(
        color: Colors.white,
        fontSize: 18,
      )),
);
