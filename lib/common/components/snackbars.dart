import 'package:flutter/material.dart';

abstract class SnackBars {
  static SnackBar error(String content) {
    return SnackBar(
      content: Text(content),
      backgroundColor: Colors.red,
    );
  }
}
