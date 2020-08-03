import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  RoundedButton({
    @required String text,
    this.onPressed,
    Widget icon,
    this.color,
    this.padding = const EdgeInsets.fromLTRB(24, 12, 24, 12),
  })  : child = Builder(
          builder: (context) => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (icon != null)
                Container(
                  width: 32,
                  child: icon,
                ),
              Text(
                text,
                style: Theme.of(context).textTheme.button,
              )
            ],
          ),
        ),
        assert(text != null);

  RoundedButton.custom({
    this.onPressed,
    this.color,
    this.padding = const EdgeInsets.fromLTRB(24, 12, 24, 12),
    @required this.child,
  }) : assert(child != null);

  final Function onPressed;
  final Color color;
  final EdgeInsets padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      padding: padding,
      color: color ?? Color(0xFF4665EA),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: child,
      onPressed: onPressed,
    );
  }
}
