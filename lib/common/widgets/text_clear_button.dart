import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextClearButton extends StatelessWidget {
  final TextEditingController controller;
  TextClearButton(this.controller);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (_, TextEditingValue v, __) => v.text.isEmpty
          ? SizedBox()
          : IconButton(
              iconSize: 18,
              icon: Icon(
                CupertinoIcons.clear_thick_circled,
                color: Theme.of(context).unselectedWidgetColor,
              ),
              onPressed: () {
                WidgetsBinding.instance
                    .addPostFrameCallback((_) => controller.clear());
              },
            ),
    );
  }
}
