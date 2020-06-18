import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polka_wallet/common/components/checkRule.dart';
import 'package:polka_wallet/common/components/formulaComma.dart';
import 'package:polka_wallet/common/components/formulaInput.dart';
import 'package:polka_wallet/common/components/formulaLabel.dart';
import 'package:polka_wallet/common/components/goPageBtn.dart';
import 'package:polka_wallet/common/components/linkTap.dart';
import 'package:polka_wallet/common/components/lockAppBtn.dart';
import 'package:polka_wallet/common/components/selectPicker.dart';
import 'package:polka_wallet/common/components/subTitle.dart';
import 'package:polka_wallet/page/assets/lock/lockResultPage.dart';
import 'package:polka_wallet/store/app.dart';
import 'package:polka_wallet/utils/i18n/index.dart';

import '../../../constants.dart';

class LockDetailPage extends StatefulWidget {
  LockDetailPage(this.store);

  static final String route = '/assets/lock/detail';
  final AppStore store;

  @override
  _DetailPageState createState() => _DetailPageState(store);
}

class _DetailPageState extends State<LockDetailPage> {
  _DetailPageState(this.store);

  final AppStore store;

  int _selectedTokenIndex = 0;
  String _selectedTokenValue = 'MXC';
  List _durationData = [3, 6, 9, 12, 24, 36];
  int _durationIndex = -1;
  int _durationValue = 3;
  TextEditingController _durationCtl = TextEditingController(text: '');
  TextEditingController _amountCtl = TextEditingController(text: '');
  TextEditingController _publicKeyCtl = TextEditingController(text: '');
  TextEditingController _genesisValidator = TextEditingController(text: 'false');
  bool _qrcodeValue = false;
  bool _doubleCheckValue = false;

  @override
  Widget build(BuildContext context) {
    var dic = I18n.of(context).assets;

    return Scaffold(
      appBar: AppBar(
        title: Text(dic['lock.tokens'])
      ),
      body: SafeArea(
        child: Builder(
          builder: (BuildContext context) {
          return Scrollbar(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  Text(
                    dic['transaction.message'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      dic['lock.transaction.instruction'],
                      textAlign: TextAlign.center,
                    ),
                  ),
                  subTitle(dic['formula']),
                  Row(
                    children: <Widget>[
                      formulaInput(
                        type: 'picker',
                        lable: dic['lock.duration'],
                        controller: _durationCtl,
                        onSelected: () => selectPicker(
                        context,
                        data: _durationData, 
                        value: _durationIndex, 
                        onSelected: (index){
                          setState(() {
                            _durationIndex = index;
                            _durationCtl.text = _durationData[index].toString();
                          });
                        })
                      ),
                      formulaComma(),
                      formulaLabel(dic['lock']),
                      formulaComma(),
                      formulaInput(
                        controller: _amountCtl,
                        lable: dic['amount.tokens'],
                        onChanged: (value){
                          setState(() {});
                        }
                      ),
                    ]
                  ),
                  Row(
                    children: <Widget>[
                      formulaInput(
                        controller: _publicKeyCtl,
                        lable: dic['public.key'],
                        onChanged: (value){
                          setState(() {});
                        }
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      formulaInput(
                        controller: _genesisValidator,
                        lable: dic['genesis.validator'],
                        onChanged: (value){
                          setState(() {});
                        },
                        value: 'false'
                      )
                    ],
                  ),
                  linkTap(
                    dic['guide.public.key'],
                    onTap: (){}
                  ),
                  subTitle(
                    dic['your.transaction'],
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    title: Container(
                      padding: const EdgeInsets.all(5),
                      color: Colors.grey[200],
                      child: Text(
                        '${_durationCtl.text.isEmpty ? '??' : _durationCtl.text},Lock,${_amountCtl.text.isEmpty ? '??' : _amountCtl.text},${_publicKeyCtl.text.isEmpty ? '??' : _publicKeyCtl.text},${kContractAddrMXCTestnet},${_genesisValidator.text.isEmpty ? '??' : _genesisValidator.text}',
                        style: TextStyle(
                          fontSize: 12
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    trailing: Icon(Icons.content_copy),
                  ),
                  Text(
                    '${dic["expected"]} MSB: MSB',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12
                    )
                  ),
                  subTitle(
                    dic['your.convenience'],
                    alignment: Alignment.centerLeft
                  ),
                  checkRule(
                    dic['message.qrcode'],
                    value: _qrcodeValue,
                    onChanged: (newValue){
                      setState(() {
                        _qrcodeValue = newValue;
                      });
                    }
                  ),
                  checkRule(
                    dic['check.message'],
                    value: _doubleCheckValue,
                    onChanged: (newValue){
                      setState(() {
                        _doubleCheckValue = newValue;
                      });
                    }
                  ),
                  lockAppBtn(
                    context,
                    dic['signal.app'],
                    selectedValue: _selectedTokenIndex,
                    onSelected: (index,value){
                      setState(() {
                        _selectedTokenIndex = index;
                        _selectedTokenValue = value;
                      });
                    }
                  ),
                ]
              )
            )
          );
        }
      )),
      bottomNavigationBar: Container(
        color: Theme.of(context).bottomAppBarColor,
        child: ListTile(
          contentPadding: const EdgeInsets.only(left: 10,right: 10,bottom: 30),
          title: Row(children: <Widget>[
            Icon(Icons.chevron_left),
            goPageBtn(
              dic['back'],
              textAlign: TextAlign.left,
              onTap: () => Navigator.pop(context),
            ),
            goPageBtn(
              dic['understand'],
              onTap: () => Navigator.pushNamed(context, LockResultPage.route),
            ),
            Icon(Icons.chevron_right)
          ]),
        ),
      )
    );
  }
}
