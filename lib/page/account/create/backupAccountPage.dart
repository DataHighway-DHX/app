import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:polka_wallet/common/components/accountAdvanceOption.dart';
import 'package:polka_wallet/common/components/mnemonic_list.dart';
import 'package:polka_wallet/service/substrateApi/api.dart';
import 'package:polka_wallet/common/widgets/roundedButton.dart';
import 'package:polka_wallet/store/app.dart';
import 'package:polka_wallet/utils/UI.dart';
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

  AccountAdvanceOptionParams _advanceOptions = AccountAdvanceOptionParams();
  int _step = 0;

  List<String> _wordsSelected;
  List<String> _wordsLeft;

  Future<void> _importAccount() async {
    var acc = await webApi.account.importAccount(
      cryptoType:
          _advanceOptions.type ?? AccountAdvanceOptionParams.encryptTypeSR,
      derivePath: _advanceOptions.path ?? '',
    );

    if (acc['error'] != null) {
      UI.alertWASM(context, () {
        setState(() {
          _step = 0;
        });
      });
      return;
    }

    await store.account.addAccount(acc, store.account.newAccount.password);
    webApi.account.encodeAddress([acc['pubKey']]);

    store.assets.loadAccountCache();
    store.staking.loadAccountCache();

    // fetch info for the imported account
    String pubKey = acc['pubKey'];
    webApi.assets.fetchBalance();
    webApi.staking.fetchAccountStaking();
    webApi.account.fetchAccountsBonded([pubKey]);
    webApi.account.getPubKeyIcons([pubKey]);

    // go to home page
    Navigator.popUntil(context, ModalRoute.withName('/'));
  }

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
                    Padding(
                      padding: EdgeInsets.only(left: 16, right: 16),
                      child: Text(
                        i18n['create.warn3'],
                        style: Theme.of(context).textTheme.headline1,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        i18n['create.warn4'],
                      ),
                    ),
                    MnemonicList(
                      words: store.account.newAccount.key.split(' '),
                    ),
                    AccountAdvanceOption(
                      seed: store.account.newAccount.key ?? '',
                      onChange: (data) {
                        setState(() {
                          _advanceOptions = data;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(16),
                child: RoundedButton(
                  text: I18n.of(context).home['next'],
                  onPressed: () {
                    if (_advanceOptions.error ?? false) return;
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
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      i18n['backup'],
                      style: Theme.of(context).textTheme.headline1,
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      i18n['backup.confirm'],
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  MnemonicList(
                    words: _wordsSelected,
                    onClear: () {
                      setState(() {
                        _wordsLeft = store.account.newAccount.key.split(' ');
                        _wordsSelected = [];
                      });
                    },
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
