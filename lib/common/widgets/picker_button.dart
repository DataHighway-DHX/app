import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PickerButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final VoidCallback onTap;
  final Widget leading;

  const PickerButton({
    Key key,
    @required this.title,
    @required this.subtitle,
    this.margin = const EdgeInsets.all(10),
    this.padding = const EdgeInsets.symmetric(
      horizontal: 10,
      vertical: 15,
    ),
    this.onTap,
    this.leading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: margin,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: padding,
          child: Row(
            children: <Widget>[
              if (leading != null) leading,
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
              Spacer(),
              SizedBox(
                width: 35,
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
