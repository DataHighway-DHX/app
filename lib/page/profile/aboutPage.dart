import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info/package_info.dart';
import 'package:polka_wallet/common/widgets/roundedButton.dart';
import 'package:polka_wallet/service/walletApi.dart';
import 'package:polka_wallet/utils/UI.dart';
import 'package:polka_wallet/utils/i18n/index.dart';
import 'package:url_launcher/url_launcher.dart';

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
    await UI.checkUpdate(context, versions: versions);
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
            Container(width: double.infinity),
            Spacer(),
            Expanded(
              flex: 5,
              child: Image.asset(
                'assets/images/public/About_app.png',
                fit: BoxFit.contain,
              ),
            ),
            GestureDetector(
              child: Text(
                'https://datahighway.com/',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              onTap: () => launch('https://datahighway.com/'),
            ),
            IconButton(
              icon: FaIcon(FontAwesomeIcons.github),
              onPressed: () => launch('https://github.com/DataHighway-DHX/app'),
            ),
            Spacer(),
            Text(
              dic['about.power'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/images/public/polkawallet.png'),
              ],
            ),
            SizedBox(height: 7),
            Text(
              'Polkawallet',
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              child: Text(
                'https://polkawallet.io',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              onTap: () => launch('https://polkawallet.io'),
            ),
            Spacer(),
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
                onPressed: _loading
                    ? null
                    : () {
                        _checkUpdate();
                      },
              ),
            )
          ],
        ),
      ),
    );
  }
}
