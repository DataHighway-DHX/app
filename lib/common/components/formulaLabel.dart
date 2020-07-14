import 'package:flutter/material.dart';

Widget formulaLabel(String name){
  return Container(
    margin: const EdgeInsets.only(top: 40.0),
    padding: const EdgeInsets.symmetric(horizontal: 30.0),
    child: Text(
      name ?? '',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 12
      )
    ),
  );
}