
import 'package:flutter/material.dart';

Widget gasInput(title,gasText,subtile){
  return ListTile(
    leading: Text(
      title,
      style: TextStyle(
        fontSize: 14
      )
    ),
    title: TextField(
      controller: TextEditingController()..text = gasText,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 14
      ),
    ),
    trailing: Text(
      subtile,
      style: TextStyle(
        fontSize: 14
      )
    ),
  );
}
