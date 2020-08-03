import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polka_wallet/common/widgets/roundedButton.dart';
import 'package:polka_wallet/page/account/create/createAccountPage.dart';
import 'package:polka_wallet/page/account/import/importAccountPage.dart';
import 'package:polka_wallet/utils/i18n/index.dart';

class CreateAccountEntryPage extends StatelessWidget {
  static final String route = '/account/entry';

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
                padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: RoundedButton(
                  text: I18n.of(context).home['import'],
                  onPressed: () {
                    Navigator.pushNamed(context, ImportAccountPage.route);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
