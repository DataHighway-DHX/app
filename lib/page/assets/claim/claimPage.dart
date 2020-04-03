import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:polka_wallet/common/components/selectPicker.dart';
import 'package:polka_wallet/store/app.dart';
import 'package:polka_wallet/utils/i18n/index.dart';

class ClaimPage extends StatefulWidget {
  ClaimPage(this.store);

  static final String route = '/assets/claim';
  final AppStore store;

  @override
  _ClaimPageState createState() => _ClaimPageState(store);
}

class _ClaimPageState extends State<ClaimPage> {
  _ClaimPageState(this.store);

  final AppStore store;
  TapGestureRecognizer _tapRuleRecongnizer = TapGestureRecognizer()
    ..onTap = () => _tapRule();
  TextEditingController _hashCtl = TextEditingController(text: '');
  int _selectedValue = -1;

  @override
  Widget build(BuildContext context) {
    var dic = I18n.of(context).assets;
    bool isEnglish = store.settings.localeCode.contains('en');
    
    return Scaffold(
      appBar: AppBar(
        title: Text(dic['claim.transaction'])
      ),
      body: SafeArea(
        child: Builder(
          builder: (BuildContext context) {
          return ListView(
            shrinkWrap: true, 
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            children: <Widget>[
              Text(
                dic['claim.instruction'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16 
                ),
              ),
              Container(
                padding: EdgeInsets.only(top:100),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _hashCtl,
                      decoration: InputDecoration(
                        labelText: dic['claim.hash'],
                      ),
                      readOnly: true
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.content_copy), 
                    onPressed: null
                  )
                ],
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(dic['claim.which.chain']),
                trailing: Icon(Icons.chevron_right),
                onTap: () async{
                  List data = ['Ethereum Testnet (Görli)', 'Ethereum Mainnet'];
                  selectPicker(
                    context,
                    data: data,
                    value: _selectedValue,
                    onSelected: (res){
                    if(_hashCtl.text.isEmpty|| _selectedValue != res){
                      setState(() {
                        _selectedValue = res;
                        _hashCtl.text = data[res];
                      });
                    }
                  });
                }
              ),
            ]
          );
        }
      )),
      bottomNavigationBar: ListView(
        padding: const EdgeInsets.only(left: 10,right: 10,bottom: 20),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: <Widget>[
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: isEnglish ? dic['claim.token.instruction'] : dic['claim.token.instruction1']
                ),
                TextSpan(
                  text: dic["claim.dhx.document"],
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: _tapRuleRecongnizer
                ),
                TextSpan(
                  text: isEnglish ? '' : dic['claim.token.instruction2']
                )
              ]
            ),
            textAlign: TextAlign.center,
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Container(
              margin: const EdgeInsets.only(top: 30,right: 10,left: 10,bottom: 10),
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(10.0)
              ),
              child: OutlineButton(
                borderSide: BorderSide(
                  color: Colors.deepPurple
                ),
                padding: const EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)
                ),
                child: Text(
                  dic['claim'],
                  style: const TextStyle(
                    fontSize: 22.0,
                    color: Colors.white
                  ),
                ),
                onPressed: () => Navigator.pop(context)
              )
            )
          )
        ],
      ),
    );
  }
}

void _tapRule(){
  
}
