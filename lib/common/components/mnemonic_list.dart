import 'package:flutter/material.dart';

class MnemonicList extends StatelessWidget {
  final List<String> words;
  MnemonicList({this.words = const []});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Container(
        constraints: BoxConstraints(minHeight: 90),
        padding: EdgeInsets.all(10),
        child: Wrap(
          children: <Widget>[
            for (final w in words)
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 9,
                ),
                child: Text(
                  w,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
