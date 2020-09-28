import 'package:flutter/material.dart';
import 'package:polka_wallet/utils/i18n/index.dart';

Widget gasInput(title, gasText, subtile) {
  return Container(
    width: 300,
    height: 50,
    alignment: Alignment.center,
    color: Colors.red,
    child: Text('Rewrite'),
  );
  return ListTile(
    leading: Text(title, style: TextStyle(fontSize: 14)),
    title: TextField(
      controller: TextEditingController()..text = gasText,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 14),
    ),
    trailing: Text(subtile, style: TextStyle(fontSize: 14)),
  );
}

class GasInput extends StatefulWidget {
  final String title;
  final String subtitle;
  final void Function(String) onValue;
  final String defaultValue;

  const GasInput({
    Key key,
    this.title,
    this.defaultValue,
    this.onValue,
    this.subtitle,
  }) : super(key: key);

  @override
  _GasInputState createState() => _GasInputState();
}

class _GasInputState extends State<GasInput> {
  TextEditingController controller;
  bool error = false;

  @override
  void initState() {
    controller = TextEditingController(text: widget.defaultValue);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var dic = I18n.of(context).assets;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 5),
        Text('${widget.title} (${widget.subtitle})'),
        TextField(
          controller: controller,
          onChanged: (v) {
            final val = double.tryParse(v) == null ? null : v;
            setState(() => error = val == null);
            widget.onValue(val);
          },
          decoration: InputDecoration(
            isDense: true,
            errorText: error ? dic['amount.error'] : null,
          ),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 5),
      ],
    );
  }
}
