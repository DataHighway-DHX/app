import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:polka_wallet/common/components/mnemonic_list.dart';
import 'package:polka_wallet/service/substrateApi/api.dart';
import 'package:polka_wallet/common/widgets/roundedButton.dart';
import 'package:polka_wallet/store/app.dart';
import 'package:polka_wallet/utils/i18n/index.dart';

class BackupAccountPage extends StatefulWidget {
  const BackupAccountPage(this.store);

  static final String route = '/account/backup';
  final AppStore store;

  @override
  _BackupAccountPageState createState() => _BackupAccountPageState(store);
}

class _BackupAccountPageState extends State<BackupAccountPage> {
  _BackupAccountPageState(this.store);

  final AppStore store;

  int _step = 0;

  List<String> _wordsSelected;
  List<String> _wordsLeft;

  @override
  void initState() {
    webApi.account.generateAccount();
    super.initState();
  }

  Widget _buildStep0(BuildContext context) {
    final Map<String, String> i18n = I18n.of(context).account;

    return Observer(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: Text(I18n.of(context).home['create']),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(16),
                  children: <Widget>[
                    Text(
                      i18n['create.warn3'],
                      style: Theme.of(context).textTheme.display4,
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 16, bottom: 32),
                      child: Text(
                        i18n['create.warn4'],
                      ),
                    ),
                    MnemonicList(
                      words: store.account.newAccount.key.split(' '),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(16),
                child: RoundedButton(
                  text: I18n.of(context).home['next'],
                  onPressed: () {
                    setState(() {
                      _step = 1;
                      _wordsSelected = <String>[];
                      _wordsLeft = store.account.newAccount.key.split(' ');
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep1(BuildContext context) {
    final Map<String, String> i18n = I18n.of(context).account;

    return Scaffold(
      appBar: AppBar(
        title: Text(I18n.of(context).home['create']),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            setState(() {
              _step = 0;
            });
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(16),
                children: <Widget>[
                  Text(
                    i18n['backup'],
                    style: Theme.of(context).textTheme.display4,
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 16),
                    child: Text(
                      i18n['backup.confirm'],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      GestureDetector(
                        child: Container(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            i18n['backup.reset'],
                            style: TextStyle(
                                fontSize: 14, color: Colors.deepPurple),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            _wordsLeft =
                                store.account.newAccount.key.split(' ');
                            _wordsSelected = [];
                          });
                        },
                      )
                    ],
                  ),
                  MnemonicList(
                    words: _wordsSelected,
                  ),
                  _buildWordsButtons(),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: RoundedButton(
                text: I18n.of(context).home['confirm'],
                onPressed: _wordsSelected.join(' ') ==
                        store.account.newAccount.key
                    ? () async {
                        webApi.account.importAccount();
                        Navigator.popUntil(context, ModalRoute.withName('/'));
                      }
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWordsButtons() {
    if (_wordsLeft.length > 0) {
      _wordsLeft.sort();
    }

    var perRow = 3;
    var rowsCount = (_wordsLeft.length / perRow).ceil();

    var el = (String i) => Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            child: RoundedButton.dense(
              text: i,
              onPressed: () {
                setState(() {
                  _wordsLeft.remove(i);
                  _wordsSelected.add(i);
                });
              },
            ),
          ),
        );

    return Container(
      padding: EdgeInsets.only(top: 16),
      child: Column(
        children: [
          for (var i = 0; i < rowsCount; i++)
            Row(
              children: [
                for (var j = 0; j < perRow; j++)
                  i * perRow + j < _wordsLeft.length
                      ? el(_wordsLeft[i * perRow + j])
                      : Spacer(),
              ],
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (_step) {
      case 0:
        return _buildStep0(context);
      case 1:
        return _buildStep1(context);
      default:
        return Container();
    }
  }
}
