import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:polka_wallet/common/configs/sys.dart';
import 'package:polka_wallet/page/assets/asset/assetPage.dart';
import 'package:polka_wallet/page/assets/asset_card.dart';
import 'package:polka_wallet/page/assets/claim/claimPage.dart';
import 'package:polka_wallet/page/assets/lock/lock_page.dart';
import 'package:polka_wallet/page/assets/receive/receivePage.dart';
import 'package:polka_wallet/page/assets/signal/signal_page.dart';
import 'package:polka_wallet/service/ethereumApi/api.dart';
import 'package:polka_wallet/common/components/passwordInputDialog.dart';
import 'package:polka_wallet/common/consts/settings.dart';
import 'package:polka_wallet/page/account/scanPage.dart';
import 'package:polka_wallet/page/account/uos/qrSignerPage.dart';
import 'package:polka_wallet/page/assets/asset/assetPage.dart';
import 'package:polka_wallet/page/assets/claim/attestPage.dart';
import 'package:polka_wallet/page/assets/claim/claimPage.dart';
import 'package:polka_wallet/page/assets/receive/receivePage.dart';
import 'package:polka_wallet/page/assets/index.dart';
import 'package:polka_wallet/service/notification.dart';
import 'package:polka_wallet/service/substrateApi/api.dart';
import 'package:polka_wallet/common/components/BorderedTitle.dart';
import 'package:polka_wallet/common/components/addressIcon.dart';
import 'package:polka_wallet/common/components/roundedCard.dart';
import 'package:polka_wallet/store/account/types/accountData.dart';
import 'package:polka_wallet/store/app.dart';
import 'package:polka_wallet/store/assets/types/balancesInfo.dart';
import 'package:polka_wallet/utils/UI.dart';
import 'package:polka_wallet/utils/format.dart';

import 'package:polka_wallet/utils/i18n/index.dart';

import '../../service/ethereumApi/apiAssetsMXC.dart';
import '../../service/ethereumApi/apiMiningMXC.dart';
import '../../service/ethereumApi/lockdrop.dart';
import '../../constants.dart';
import 'package:polka_wallet/common/widgets/roundedButton.dart';

import 'table_source.dart';

class Assets extends StatefulWidget {
  Assets(this.store);

  final AppStore store;

  @override
  _AssetsState createState() => _AssetsState(store);
}

class _AssetsState extends State<Assets> {
  _AssetsState(this.store);

  final AppStore store;

  bool _faucetSubmitting = false;
  bool _preclaimChecking = false;

  Future<void> _fetchBalance() async {
    await Future.wait(
        [webApi.assets.fetchBalance(), webApi.staking.fetchAccountStaking()]);
  }

  Future<void> _handleScan() async {
    final Map dic = I18n.of(context).account;
    final data = await Navigator.pushNamed(
      context,
      ScanPage.route,
      arguments: 'tx',
    );
    if (data != null) {
      if (store.account.currentAccount.observation ?? false) {
        showCupertinoDialog(
          context: context,
          builder: (_) {
            return CupertinoAlertDialog(
              title: Text(dic['uos.title']),
              content: Text(dic['uos.acc.invalid']),
              actions: <Widget>[
                CupertinoButton(
                  child: Text(I18n.of(context).home['ok']),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            );
          },
        );
        return;
      }

      final Map sender =
          await webApi.account.parseQrCode(data.toString().trim());
      if (sender['signer'] != store.account.currentAddress) {
        showCupertinoDialog(
          context: context,
          builder: (_) {
            return CupertinoAlertDialog(
              title: Text(dic['uos.title']),
              content: sender['error'] != null
                  ? Text(sender['error'])
                  : sender['signer'] == null
                      ? Text(dic['uos.qr.invalid'])
                      : Text(dic['uos.acc.mismatch']),
              actions: <Widget>[
                CupertinoButton(
                  child: Text(I18n.of(context).home['ok']),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            );
          },
        );
      } else {
        showCupertinoDialog(
          context: context,
          builder: (_) {
            return PasswordInputDialog(
              account: store.account.currentAccount,
              title: Text(dic['uos.title']),
              onOk: (password) {
                print('pass ok: $password');
                _signAsync(password);
              },
            );
          },
        );
      }
    }
  }

  Future<void> _signAsync(String password) async {
    final Map dic = I18n.of(context).account;
    final Map signed = await webApi.account.signAsync(password);
    print('signed: $signed');
    if (signed['error'] != null) {
      showCupertinoDialog(
        context: context,
        builder: (_) {
          return CupertinoAlertDialog(
            title: Text(dic['uos.title']),
            content: Text(signed['error']),
            actions: <Widget>[
              CupertinoButton(
                child: Text(I18n.of(context).home['ok']),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
      return;
    }
    Navigator.of(context).pushNamed(
      QrSignerPage.route,
      arguments: signed['signature'].toString().substring(2),
    );
  }

  Future<String> _checkPreclaim() async {
    setState(() {
      _preclaimChecking = true;
    });
    String address = store.account.currentAddress;
    String ethAddress =
        await webApi.connector.eval('api.query.claims.preclaims("$address")');
    setState(() {
      _preclaimChecking = false;
    });
    if (ethAddress == null) {
      Navigator.of(context).pushNamed(ClaimPage.route, arguments: '');
    } else {
      Navigator.of(context).pushNamed(AttestPage.route, arguments: ethAddress);
    }
    return ethAddress;
  }

  Widget _buildTopCard(BuildContext context) {
    var dic = I18n.of(context).assets;
    String network = store.settings.loading
        ? dic['node.connecting']
        : store.settings.networkName ?? dic['node.failed'];

    AccountData acc = store.account.currentAccount;

    bool isAcala = store.settings.endpoint.info == networkEndpointAcala.info;
    bool isKusama = store.settings.endpoint.info == networkEndpointKusama.info;
    bool isPolkadot =
        store.settings.endpoint.info == networkEndpointPolkadot.info;

    return RoundedCard(
      color: Theme.of(context).primaryColor,
      padding: EdgeInsets.all(8),
      child: Column(
        children: <Widget>[
          ListTile(
            leading: AddressIcon('', pubKey: acc.pubKey),
            title: Text(
              acc.name ?? '',
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  .copyWith(color: Colors.white),
            ),
            subtitle: Text(
              network,
              style: Theme.of(context)
                  .textTheme
                  .subtitle2
                  .copyWith(color: Colors.white),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 34,
                  child: IconButton(
                    icon: Image.asset(
                      'assets/images/assets/Assets_nav_code.png',
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if (acc.address != '') {
                        Navigator.pushNamed(context, ReceivePage.route);
                      }
                    },
                  ),
                ),
                SizedBox(
                  width: 7,
                ),
                Text(
                  Fmt.address(store.account.currentAddress),
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
                      .copyWith(color: Colors.white),
                ),
                Spacer(),
                IconButton(
                  icon: Image.asset(
                    'assets/images/assets/Menu_scan.png',
                    color: Colors.white,
                  ),
                  onPressed: () {
                    if (acc.address != '') {
                      Navigator.pushNamed(context, ReceivePage.route);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    // if network connected failed, reconnect
    if (!store.settings.loading && store.settings.networkName == null) {
      store.settings.setNetworkLoading(true);
      webApi.connectNodeAll();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!store.settings.loading) {
        globalBalanceRefreshKey.currentState?.show();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        String symbol = store.settings.networkState.tokenSymbol;
        int decimals = store.settings.networkState.tokenDecimals;
        String networkName = store.settings.networkName ?? '';

        bool isAcala =
            store.settings.endpoint.info == networkEndpointAcala.info;

        List<String> currencyIds = [];
        if (isAcala && networkName != null) {
          if (store.settings.networkConst['currencyIds'] != null) {
            currencyIds.addAll(
                List<String>.from(store.settings.networkConst['currencyIds']));
          }
          currencyIds.retainWhere((i) => i != symbol);
        }

        BalancesInfo balancesInfo = store.assets.balances[symbol];

        return RefreshIndicator(
          key: globalBalanceRefreshKey,
          onRefresh: _fetchBalance,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 10).copyWith(bottom: 20),
            children: <Widget>[
              SizedBox(height: 24),
              _buildTopCard(context),
              SizedBox(height: 20),
              AssetCard(
                image: AssetImage('assets/images/assets/DHX.png'),
                label: 'DHX',
                subtitle: 'DataHighway Testnet',
                balance: store.assets.balances.values
                    .map((e) => e.freeBalance)
                    .fold<BigInt>(BigInt.from(0), (a, b) => a + b)
                    .toDouble(),
                usdBalance: 404,
                claim: false,
                lock: false,
                signal: false,
              ),
              SizedBox(height: 20),
              AssetCard(
                image: AssetImage('assets/images/assets/MXC.png'),
                label: AssetsConfigs.mxc,
                subtitle: 'ERC-20',
                balance: 123,
                usdBalance: 10,
                expandedContent: AssetsCardContent(
                  store: store,
                  tableSource: MxcTableSource(),
                ),
              ),
              SizedBox(height: 20),
              AssetCard(
                image: AssetImage('assets/images/assets/currencies/IOTA.png'),
                label: AssetsConfigs.iota,
                subtitle: 'ERC-20',
                balance: 123,
                usdBalance: 10,
                expandedContent: AssetsCardContent(
                  store: store,
                  tableSource: IotaTableSource(),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              AssetCard(
                image: AssetImage('assets/images/assets/currencies/ETH.png'),
                label: 'ETH',
                subtitle: 'GAS',
                balance: store.assets.balances.values
                    .map((e) => e.freeBalance)
                    .fold<BigInt>(BigInt.from(0), (a, b) => a + b)
                    .toDouble(),
                usdBalance: 404,
                claim: false,
                lock: false,
                signal: false,
              ),
              SizedBox(
                height: 20,
              ),
              AssetCard(
                image: AssetImage('assets/images/assets/currencies/DOT.png'),
                label: 'DOT',
                subtitle: 'DataHighway Testnet',
                balance: 123,
                usdBalance: 10,
                lock: false,
                expandedContent: AssetsCardContent(
                  store: store,
                  tableSource: MxcTableSource(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

Widget operate(BuildContext context, {name = '', expandSet, expandTap}) {
  return Container(
      child: Row(children: <Widget>[
    GestureDetector(
      child: Icon(
        expandSet.contains(name) ? Icons.expand_less : Icons.expand_more,
      ),
      onTap: expandTap,
    ),
    GestureDetector(
      child: Icon(
        Icons.fullscreen,
      ),
      onTap: () => Navigator.pushNamed(context, AssetPage.route),
    )
  ]));
}
