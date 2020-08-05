import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:polka_wallet/common/configs/sys.dart';
import 'package:polka_wallet/page/assets/asset/assetPage.dart';
import 'package:polka_wallet/page/assets/asset_card.dart';
import 'package:polka_wallet/page/assets/claim/claimPage.dart';
import 'package:polka_wallet/page/assets/lock/lockPage.dart';
import 'package:polka_wallet/page/assets/receive/receivePage.dart';
import 'package:polka_wallet/page/assets/signal/signalPage.dart';
import 'package:polka_wallet/service/ethereumApi/api.dart';
import 'package:polka_wallet/service/substrateApi/api.dart';
import 'package:polka_wallet/common/components/BorderedTitle.dart';
import 'package:polka_wallet/common/components/addressIcon.dart';
import 'package:polka_wallet/common/components/roundedCard.dart';
import 'package:polka_wallet/store/app.dart';
import 'package:polka_wallet/utils/UI.dart';
import 'package:polka_wallet/utils/format.dart';

import 'package:polka_wallet/store/account.dart';
import 'package:polka_wallet/utils/i18n/index.dart';

import '../../service/ethereumApi/apiAssetsMXC.dart';
import '../../service/ethereumApi/apiMiningMXC.dart';
import '../../service/ethereumApi/apiMiningIOTAPegged.dart';
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

  Future<void> _fetchBalance() async {
    await Future.wait([
      webApi.assets.fetchBalance(store.account.currentAccount.pubKey),
      webApi.staking.fetchAccountStaking(store.account.currentAccount.pubKey)
    ]);
  }

  Widget _buildTopCard(BuildContext context) {
    var dic = I18n.of(context).assets;
    String network = store.settings.loading
        ? dic['node.connecting']
        : store.settings.networkName ?? dic['node.failed'];

    AccountData acc = store.account.currentAccount;

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
      webApi.connectNode();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        String symbol = store.settings.networkState.tokenSymbol;
        int decimals = store.settings.networkState.tokenDecimals;
        String networkName = store.settings.networkName ?? '';
        List expandSet = store.assets.isExpand;

        return RefreshIndicator(
          key: globalBalanceRefreshKey,
          onRefresh: _fetchBalance,
          child: ListView(
            padding: EdgeInsets.only(left: 16, right: 16),
            children: <Widget>[
              SizedBox(height: 24),
              _buildTopCard(context),
              Padding(
                padding: EdgeInsets.only(top: 32),
                child: BorderedTitle(
                  title: I18n.of(context).home['assets'],
                ),
              ),
              SizedBox(height: 20),
              AssetCard(
                image: AssetImage('assets/images/assets/DHX.png'),
                label: 'DHX',
                subtitle: 'DataHighway Testnet',
                balance: double.parse(store.assets.balance),
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
                balance: double.parse(store.assets.balance),
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
