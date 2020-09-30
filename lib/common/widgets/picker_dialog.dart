import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PickerDialog<T> extends StatelessWidget {
  final List<T> values;
  final String Function(T) stringifier;
  final T selectedValue;

  const PickerDialog({
    Key key,
    this.values,
    this.stringifier,
    this.selectedValue,
  }) : super(key: key);

  static Future<T> show<T>(
    BuildContext context,
    PickerDialog<T> dialog,
  ) async {
    final res = await showCupertinoModalPopup(
        context: context, builder: (ctx) => dialog);
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      actions: values
          .map(
            (e) => CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(context).pop(e);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  stringifier == null ? e.toString() : stringifier(e),
                  style: TextStyle(
                    color: selectedValue == e ? null : Colors.black,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
