import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polka_wallet/common/widgets/roundedButton.dart';
import 'package:polka_wallet/constants.dart';
import 'package:polka_wallet/page/account/create/createAccountPage.dart';
import 'package:polka_wallet/page/account/import/importAccountPage.dart';
import 'package:polka_wallet/service/substrateApi/api.dart';
import 'package:polka_wallet/store/account/account.dart';
import 'package:polka_wallet/store/app.dart';
import 'package:polka_wallet/utils/i18n/index.dart';

class CreateAccountEntryPage extends StatelessWidget {
  static final String route = '/account/entry';
  final AppStore store;

  CreateAccountEntryPage(this.store);

  Future<void> demoLogin(BuildContext context) async {
    final keyType = AccountStore.seedTypeMnemonic;
    final cryptoType = 'sr25519';
    final derivePath = '';

    store.account.setNewAccount(demoUsername, demoPassword);

    String code =
        'account.recover("$keyType", "$cryptoType", \'$key$derivePath\', "$demoPassword")';
    code = code.replaceAll(RegExp(r'\t|\n|\r'), '');
    Map<String, dynamic> acc =
        await webApi.connector.eval(code, allowRepeat: true);
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
    Navigator.popUntil(context, ModalRoute.withName('/'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: AppBar(
        title: Text(I18n.of(context).home['create']),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/account/background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: <Widget>[
              Spacer(),
              Padding(
                padding: EdgeInsets.all(16),
                child: RoundedButton(
                  text: I18n.of(context).home['create'],
                  onPressed: () {
                    Navigator.pushNamed(context, CreateAccountPage.route);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16).copyWith(bottom: 12),
                child: RoundedButton(
                  text: I18n.of(context).home['import'],
                  onPressed: () {
                    Navigator.pushNamed(context, ImportAccountPage.route);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 22),
                child: InkWell(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                    child: Text(I18n.of(context).home['demo']),
                  ),
                  onTap: () => demoLogin(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
