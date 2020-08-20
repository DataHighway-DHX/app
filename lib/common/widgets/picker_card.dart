import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PickerCard<T> extends StatefulWidget {
  final String label;
  final T defaultValue;
  final String Function(T) stringifier;
  final void Function(T, int) onValueSelected;
  final List<T> values;
  final EdgeInsets margin;

  const PickerCard({
    Key key,
    @required this.label,
    @required this.values,
    @required this.onValueSelected,
    this.defaultValue,
    this.stringifier,
    this.margin = const EdgeInsets.all(10),
  }) : super(key: key);

  @override
  _PickerCardState createState() => _PickerCardState();
}

class _PickerCardState<T> extends State<PickerCard<T>> {
  int selectionIndex = 0;
  T selectedValue;

  void initState() {
    super.initState();
    final defaultValue = widget.defaultValue ?? widget.values.first;
    selectedValue = defaultValue;
    if (defaultValue != null) {
      selectionIndex = widget.values.indexOf(defaultValue);
    }
  }

  String _valueStr(T val) {
    return widget.stringifier != null
        ? widget.stringifier(val)
        : val.toString();
  }

  void _showDialog() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: MediaQuery.of(context).copyWith().size.height / 3,
        child: CupertinoPicker(
          backgroundColor: Colors.white,
          itemExtent: 56,
          scrollController:
              FixedExtentScrollController(initialItem: selectionIndex),
          children: widget.values
              .map((i) => Padding(
                  padding: EdgeInsets.all(16), child: Text(_valueStr(i))))
              .toList(),
          onSelectedItemChanged: (v) {
            setState(() {
              selectionIndex = v;
              selectedValue = widget.values[v];
            });
            widget.onValueSelected(selectedValue, v);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: widget.margin,
      child: InkWell(
        onTap: () {
          _showDialog();
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 15,
          ),
          height: 72,
          child: Row(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.label,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Spacer(),
                  Text(
                    _valueStr(selectedValue),
                  ),
                ],
              ),
              Spacer(),
              SizedBox(
                width: 35,
                child: Icon(Icons.arrow_forward_ios),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
