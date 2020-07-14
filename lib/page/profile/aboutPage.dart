import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:polka_wallet/common/components/roundedButton.dart';
import 'package:polka_wallet/service/walletApi.dart';
import 'package:polka_wallet/utils/UI.dart';
import 'package:polka_wallet/utils/i18n/index.dart';

class AboutPage extends StatefulWidget {
  static final String route = '/profile/about';

  @override
  _AboutPage createState() => _AboutPage();
}

class _AboutPage extends State<AboutPage> {
  bool _loading = false;

  Future<void> _checkUpdate() async {
    setState(() {
      _loading = true;
    });
    Map versions = await WalletApi.getLatestVersion();
    setState(() {
      _loading = false;
    });
    UI.checkUpdate(context, versions);
  }

  @override
  Widget build(BuildContext context) {
    final Map dic = I18n.of(context).profile;
    return Scaffold(
      appBar: AppBar(
        title: Text(dic['about']),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 100,left: 48,right: 48, bottom: 48),
              child: Column(
                children: <Widget>[
                  Image.asset(
                    'assets/images/public/About_app.png',
                    width: 160,
                  ),
                ]
              )
            ),
            Expanded(
              flex: 3,
              child: Container()
            ),
            Text(
              dic['about.power'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(20),
                  child: Image.asset(
                    'assets/images/public/About_logo.png',
                  ),
                )
              ]
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: <Widget>[
            //     Text(
            //       dic['about.brif'],
            //       style: Theme.of(context).textTheme.display1,
            //     ),
            //   ],
            // ),
            Expanded(
              child: Text(
                'https://polkawallet.io',
              ),
            ),
            FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder:
                  (BuildContext context, AsyncSnapshot<PackageInfo> snapshot) {
                return snapshot.hasData
                    ? Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                            '${dic['about.version']}: v${snapshot.data.version}'),
                      )
                    : Container();
              },
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: RoundedButton(
                text: I18n.of(context).home['update'],
                onPressed: () {
                  _checkUpdate();
                },
                submitting: _loading,
              ),
            )
          ],
        ),
      ),
    );
  }
}
