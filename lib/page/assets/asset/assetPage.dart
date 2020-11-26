import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:polka_wallet/common/components/BorderedTitle.dart';
import 'package:polka_wallet/common/components/TapTooltip.dart';
import 'package:polka_wallet/common/components/listTail.dart';
import 'package:polka_wallet/common/components/roundedCard.dart';
import 'package:polka_wallet/common/consts/settings.dart';
import 'package:polka_wallet/common/widgets/roundedButton.dart';
import 'package:polka_wallet/page/assets/receive/receivePage.dart';
import 'package:polka_wallet/page/assets/transfer/detailPage.dart';
import 'package:polka_wallet/page/assets/transfer/transferPage.dart';
import 'package:polka_wallet/service/subscan.dart';
import 'package:polka_wallet/service/substrateApi/api.dart';
import 'package:polka_wallet/store/app.dart';
import 'package:polka_wallet/store/assets/types/balancesInfo.dart';
import 'package:polka_wallet/store/assets/types/transferData.dart';
import 'package:polka_wallet/utils/UI.dart';
import 'package:polka_wallet/utils/format.dart';
import 'package:polka_wallet/utils/i18n/index.dart';
import 'package:polka_wallet/utils/localStorage.dart';

class AssetPage extends StatefulWidget {
  AssetPage(this.store);

  static final String route = '/assets/detail';

  final AppStore store;

  @override
  _AssetPageState createState() => _AssetPageState(store);
}

class _AssetPageState extends State<AssetPage>
    with SingleTickerProviderStateMixin {
  _AssetPageState(this.store);

  final AppStore store;

  bool _loading = false;

  int _txsPage = 0;
  bool _isLastPage = false;
  ScrollController _scrollController;

  @override
  void setState(VoidCallback calback) {
    if (mounted) {
      super.setState(calback);
    } else {
      print('State is not mounted $_AssetPageState');
    }
  }

  Future<void> _updateData() async {
    if (store.settings.loading || _loading) return;
    setState(() {
      _loading = true;
    });

    webApi.assets.fetchBalance();
    Map res = {"transfers": []};

    if (store.settings.endpoint.info != networkEndpointAcala.info) {
      webApi.staking.fetchAccountStaking();
      res = await webApi.assets.updateTxs(_txsPage);
    }
    setState(() {
      _loading = false;
    });

    if (res['transfers'] == null ||
        res['transfers'].length < tx_list_page_size) {
      setState(() {
        _isLastPage = true;
      });
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _txsPage = 0;
      _isLastPage = false;
    });
    await _updateData();
  }

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (LocalStorage.checkCacheTimeout(store.assets.cacheTxsTimestamp)) {
        globalAssetRefreshKey.currentState.show();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  List<Widget> _buildTxList() {
    List<Widget> res = [];
    final String token = ModalRoute.of(context).settings.arguments;
    if (store.settings.endpoint.info == networkEndpointAcala.info) {
      List<TransferData> ls = store.acala.txsTransfer.reversed.toList();
      ls.retainWhere((i) => i.token.toUpperCase() == token.toUpperCase());
      res.addAll(ls.map((i) {
        return TransferListItem(i, token, true, false);
      }));
      res.add(ListTail(
        isEmpty: ls.length == 0,
        isLoading: false,
      ));
    } else {
      res.addAll(store.assets.txsView.map((i) {
        return TransferListItem(
            i, token, i.from == store.account.currentAddress, true);
      }));
      res.add(ListTail(
        isEmpty: store.assets.txsView.length == 0,
        isLoading: store.assets.isTxsLoading,
      ));
    }

    return res;
  }

  Widget columnText(String title, String content) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .bodyText2
              .copyWith(color: Colors.white),
        ),
        SizedBox(height: 8),
        Text(
          content,
          style: Theme.of(context)
              .textTheme
              .subtitle1
              .copyWith(color: Colors.white),
        )
      ],
    );
  }

  Widget topCard() {
    final dic = I18n.of(context).assets;
    final primaryColor = Theme.of(context).primaryColor;
    final titleColor = Theme.of(context).cardColor;
    final String symbol = store.settings.networkState.tokenSymbol;
    final String token = ModalRoute.of(context).settings.arguments;
    final bool isBaseToken = token == symbol;

    int decimals = store.settings.networkState.tokenDecimals;

    BigInt balance = token == null
        ? BigInt.from(0)
        : Fmt.balanceInt(store.assets.tokenBalances[token.toUpperCase()]);

    BalancesInfo balancesInfo = store.assets.balances[symbol];
    String lockedInfo = '\n';
    if (balancesInfo?.lockedBreakdown != null) {
      balancesInfo.lockedBreakdown.forEach((i) {
        if (i.amount > BigInt.zero) {
          lockedInfo +=
              '${Fmt.token(i.amount, decimals: decimals)} $symbol ${dic['lock.${i.use}']}\n';
        }
      });
    }

    return RoundedCard(
      color: primaryColor,
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.only(top: 10, bottom: 16, left: 15, right: 15),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 30, top: 30),
            child: Text(
              Fmt.token(isBaseToken ? balancesInfo.total : balance,
                  decimals: decimals, length: 8),
              style: Theme.of(context)
                  .textTheme
                  .headline2
                  .copyWith(color: Colors.white),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    if (lockedInfo.length > 2)
                      TapTooltip(
                        message: lockedInfo,
                        child: Padding(
                          padding: EdgeInsets.only(right: 6),
                          child: Icon(
                            Icons.info,
                            size: 16,
                            color: titleColor,
                          ),
                        ),
                        waitDuration: Duration(seconds: 0),
                      ),
                    columnText(
                      dic['locked'],
                      Fmt.token(balancesInfo?.lockedBalance,
                          decimals: decimals),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: columnText(
                  dic['available'],
                  Fmt.token(balancesInfo?.transferable, decimals: decimals),
                ),
              ),
              Expanded(
                child: columnText(
                  dic['reserved'],
                  Fmt.token(balancesInfo?.reserved, decimals: decimals),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String token = ModalRoute.of(context).settings.arguments;

    final dic = I18n.of(context).assets;

    final List<Text> _myTabs = <Text>[
      Text(dic['all']),
      Text(dic['in']),
      Text(dic['out']),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(token ?? ''),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: SafeArea(
        child: Observer(
          builder: (_) {
            return Column(
              children: <Widget>[
                SizedBox(height: 10),
                topCard(),
                SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  child: CupertinoSlidingSegmentedControl<int>(
                    children: _myTabs.asMap(),
                    onValueChanged: (i) {
                      store.assets.setTxsFilter(i);
                    },
                    groupValue: store.assets.txsFilter,
                  ),
                ),
                SizedBox(height: 24),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: RefreshIndicator(
                      key: globalAssetRefreshKey,
                      onRefresh: _refreshData,
                      child: ListView(
                        controller: _scrollController,
                        children: _buildTxList(),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    SizedBox(width: 16),
                    Expanded(
                      child: RoundedButton.dense(
                        text: I18n.of(context).assets['transfer'],
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            TransferPage.route,
                            arguments: TransferPageParams(
                              redirect: AssetPage.route,
                              symbol: token,
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: RoundedButton.dense(
                        text: I18n.of(context).assets['receive'],
                        onPressed: () {
                          Navigator.pushNamed(context, ReceivePage.route);
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                  ],
                ),
                SizedBox(height: 30),
              ],
            );
          },
        ),
      ),
    );
  }
}

class TransferListItem extends StatelessWidget {
  TransferListItem(this.data, this.token, this.isOut, this.hasDetail);

  final TransferData data;
  final String token;
  final bool isOut;
  final bool hasDetail;

  @override
  Widget build(BuildContext context) {
    String address = isOut ? data.to : data.from;
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 0.5, color: Colors.black12)),
      ),
      child: ListTile(
        title: Text(Fmt.address(address) ??
            data.extrinsicIndex ??
            Fmt.address(data.hash)),
        subtitle: Text(
            DateTime.fromMillisecondsSinceEpoch(data.blockTimestamp * 1000)
                .toString()),
        trailing: Container(
          width: 110,
          child: Row(
            children: <Widget>[
              Expanded(
                  child: Text(
                '${data.amount} $token',
                style: Theme.of(context).textTheme.headline4,
              )),
              isOut
                  ? Image.asset('assets/images/assets/assets_up.png')
                  : Image.asset('assets/images/assets/assets_down.png')
            ],
          ),
        ),
        onTap: hasDetail
            ? () {
                Navigator.pushNamed(context, TransferDetailPage.route,
                    arguments: data);
              }
            : null,
      ),
    );
  }
}
