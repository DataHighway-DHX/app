import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:polka_wallet/common/components/addressIcon.dart';
import 'package:polka_wallet/common/consts/settings.dart';
import 'package:polka_wallet/common/widgets/roundedButton.dart';
import 'package:polka_wallet/page/profile/aboutPage.dart';
import 'package:polka_wallet/page/profile/account/accountManagePage.dart';
import 'package:polka_wallet/page/profile/recovery/recoveryProofPage.dart';
import 'package:polka_wallet/page/profile/recovery/recoverySettingPage.dart';
import 'package:polka_wallet/page/profile/contacts/contactsPage.dart';
import 'package:polka_wallet/page/profile/recovery/recoveryStatePage.dart';
import 'package:polka_wallet/page/profile/settings/settingsPage.dart';
import 'package:polka_wallet/store/account/types/accountData.dart';
import 'package:polka_wallet/store/app.dart';
import 'package:polka_wallet/utils/format.dart';
import 'package:polka_wallet/utils/i18n/index.dart';

class Profile extends StatelessWidget {
  Profile(this.store);

  final AppStore store;

  void _showRecoveryMenu(BuildContext context) {
    final Map<String, String> dic = I18n.of(context).profile;
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: Text(dic['recovery.make']),
            onPressed: () {
              Navigator.of(context).popAndPushNamed(RecoverySettingPage.route);
            },
          ),
          CupertinoActionSheetAction(
            child: Text(dic['recovery.init']),
            onPressed: () {
              Navigator.of(context).popAndPushNamed(RecoveryStatePage.route);
            },
          ),
          CupertinoActionSheetAction(
            child: Text(dic['recovery.help']),
            onPressed: () {
              Navigator.of(context).popAndPushNamed(RecoveryProofPage.route);
            },
          )
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text(I18n.of(context).home['cancel']),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, String> dic = I18n.of(context).profile;
    final Color grey = Theme.of(context).unselectedWidgetColor;

    final bool isKusama =
        store.settings.endpoint.info == networkEndpointKusama.info;

    return Observer(builder: (_) {
      AccountData acc = store.account.currentAccount;
      return Scaffold(
        appBar: AppBar(
          title: Text(dic['title']),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: ListView(
          children: <Widget>[
            Card(
              margin: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 15,
              ),
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        AddressIcon('',
                            pubKey: store.account.currentAccountPubKey),
                        SizedBox(width: 16),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              acc.name ?? 'name',
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            Text(
                              Fmt.address(store.account.currentAddress) ?? '',
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                    RoundedButton.dense(
                      width: 150,
                      text: dic['account'],
                      onPressed: () =>
                          Navigator.pushNamed(context, AccountManagePage.route),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 24,
            ),
            isKusama
                ? ListTile(
                    leading: Container(
                      width: 32,
                      child: Icon(Icons.security, color: grey, size: 22),
                    ),
                    title: Text(dic['recovery']),
                    trailing: Icon(Icons.arrow_forward_ios, size: 18),
                    onTap: store.settings.loading
                        ? null
                        : () => _showRecoveryMenu(context),
                  )
                : Container(),
            ListTile(
              title: Text(dic['contact']),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: Colors.black,
              ),
              onTap: () => Navigator.of(context).pushNamed(ContactsPage.route),
            ),
            ListTile(
              title: Text(dic['setting']),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: Colors.black,
              ),
              onTap: () => Navigator.of(context).pushNamed(SettingsPage.route),
            ),
            ListTile(
              title: Text(dic['about']),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: Colors.black,
              ),
              onTap: () => Navigator.of(context).pushNamed(AboutPage.route),
            ),
            ListTile(
              title: Text(dic['password']),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: Colors.black,
              ),
              onTap: () {},
            ),
            ListTile(
              title: Text(dic['faceId']),
              trailing: CupertinoSwitch(
                value: true,
                onChanged: (_) {},
                activeColor: Theme.of(context).primaryColor,
              ),
              onTap: () {},
            ),
          ],
        ),
      );
    });
  }
}
