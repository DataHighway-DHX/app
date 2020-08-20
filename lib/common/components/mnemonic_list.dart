import 'package:flutter/material.dart';

class MnemonicList extends StatelessWidget {
  final List<String> words;
  final void Function() onClear;
  MnemonicList({this.words = const [], this.onClear});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Container(
        constraints: BoxConstraints(minHeight: 90),
        padding: EdgeInsets.all(10),
        child: Stack(
          children: [
            Wrap(
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
            if (onClear != null)
              Positioned(
                right: 0,
                bottom: 0,
                child: SizedBox(
                  height: 16,
                  width: 16,
                  child: IconButton(
                    iconSize: 16,
                    padding: EdgeInsets.all(0),
                    icon: Icon(Icons.clear),
                    onPressed: onClear,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
