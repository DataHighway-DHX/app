import 'package:flutter/material.dart';
import 'package:polka_wallet/common/widgets/picker_dialog.dart';
import 'package:polka_wallet/common/widgets/roundedButton.dart';
import 'package:polka_wallet/utils/i18n/index.dart';

class ClaimCreateInfo extends StatefulWidget {
  @override
  _ClaimCreateInfoState createState() => _ClaimCreateInfoState();
}

class _ClaimCreateInfoState extends State<ClaimCreateInfo>
    with SingleTickerProviderStateMixin {
  TextEditingController _hashCtl = TextEditingController(text: 'SampleValue');

  List<String> blockchains = [
    'Ethereum Testnet (Görli)',
    'Ethereum Mainnet',
  ];
  String selectedBlockchain;

  bool expanded = false;

  @override
  void initState() {
    selectedBlockchain = blockchains[0];
    super.initState();
  }

  Widget tableRow(String title, String content, {bool copyable = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Text(title),
          ),
          Expanded(
            child: Text(
              content,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          SizedBox(
            width: 35,
            child: copyable
                ? GestureDetector(
                    child: Icon(
                      Icons.content_copy,
                      size: 20,
                      color: Theme.of(context).primaryColor,
                    ),
                  )
                : null,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dic = I18n.of(context).assets;
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Center(
              child: Image.asset('assets/images/assets/claim_icon.png'),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text(dic['blockchain']),
                Spacer(),
                GestureDetector(
                  child: Row(
                    children: [
                      Text(
                        selectedBlockchain,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      GestureDetector(
                        child: Icon(Icons.keyboard_arrow_down),
                        onTap: () async {
                          final val = await PickerDialog.show(
                            context,
                            PickerDialog<String>(
                              values: blockchains,
                              selectedValue: selectedBlockchain,
                            ),
                          );
                          if (val != null)
                            setState(() => selectedBlockchain = val);
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: 30),
            TextField(
              controller: _hashCtl,
              decoration: InputDecoration(
                labelText: dic['transaction.hash'],
                floatingLabelBehavior: FloatingLabelBehavior.always,
                contentPadding: EdgeInsets.only(
                  bottom: 5,
                ),
              ),
              style: Theme.of(context).textTheme.bodyText2,
              readOnly: true,
            ),
            SizedBox(height: 20),
            AnimatedSize(
              duration: Duration(milliseconds: 250),
              vsync: this,
              curve: Curves.easeInOutCubic,
              child: !expanded
                  ? Container()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        tableRow(dic['from'], '0x84294...w3ergtf',
                            copyable: true),
                        tableRow(dic['to'], '0x84294...w3ergtf',
                            copyable: true),
                        tableRow(dic['amount'], '21.768 MXC'),
                        tableRow(dic['transaction.fee'], '\$ 25'),
                        tableRow(dic['expected.msb'], '1.00125'),
                        SizedBox(height: 25),
                        Text(
                          'Your Claim',
                          style: Theme.of(context).textTheme.headline1,
                        ),
                        SizedBox(height: 10),
                        Text(dic['transaction.success'])
                      ],
                    ),
            ),
            if (!expanded)
              RoundedButton.dense(
                text: dic['claim'],
                onPressed: () => setState(() => expanded = true),
                width: 150,
                height: 28,
              )
            else
              GestureDetector(
                onTap: () => setState(() => expanded = false),
                child: SizedBox(
                  height: 24,
                  width: 40,
                  child: Icon(
                    Icons.keyboard_arrow_up,
                    size: 36,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
