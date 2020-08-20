import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TopTabs extends StatelessWidget {
  final List<String> names;
  final int activeTab;
  final void Function(int) onTab;

  const TopTabs({
    Key key,
    this.names,
    this.activeTab,
    this.onTab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: CupertinoSegmentedControl(
        children: names.asMap().map((key, value) => MapEntry(key, Text(value))),
        onValueChanged: (value) => onTab(value),
        groupValue: activeTab,
        selectedColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
