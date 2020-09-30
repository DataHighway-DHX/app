import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  RoundedButton({
    @required String text,
    this.onPressed,
    Widget icon,
    this.color,
    this.height,
    this.width,
    TextStyle style,
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
                style: style ?? Theme.of(context).textTheme.button,
              )
            ],
          ),
        ),
        assert(text != null);

  RoundedButton.custom({
    this.onPressed,
    this.color,
    this.height,
    this.width,
    this.padding = const EdgeInsets.fromLTRB(24, 12, 24, 12),
    @required this.child,
  }) : assert(child != null);

  RoundedButton.dense({
    Function onPressed,
    @required String text,
    double height = 30,
    double width,
    Color color,
  }) : this.custom(
          height: height,
          width: width,
          onPressed: onPressed,
          color: color,
          padding: const EdgeInsets.all(0),
          child: Builder(
            builder: (context) => Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .copyWith(color: Colors.white),
            ),
          ),
        );

  final Function onPressed;
  final Color color;
  final EdgeInsets padding;
  final Widget child;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: RaisedButton(
        padding: padding,
        color: color ?? Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: child,
        onPressed: onPressed,
      ),
    );
  }
}
