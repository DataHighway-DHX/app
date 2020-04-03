import 'package:flutter/material.dart';

Widget checkRule(content,{bool value = false,Function(bool) onChanged}){
  return ListTile(
    leading: Checkbox(
      value: value,
      onChanged: onChanged
    ),
    title: Text(
      content,
      style: TextStyle(
        fontSize: 14
      )
    ),
  );
}
