import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:polka_wallet/page/assets/asset/assetPage.dart';
import 'package:polka_wallet/page/assets/claim/claimPage.dart';
import 'package:polka_wallet/page/assets/lock/lockPage.dart';
import 'package:polka_wallet/page/assets/receive/receivePage.dart';
import 'package:polka_wallet/page/assets/signal/signalPage.dart';
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

class Assets extends StatefulWidget {
  Assets(this.store);

  final AppStore store;

  @override
  _AssetsState createState() => _AssetsState(store);
}

class _AssetsState extends State<Assets> {
  _AssetsState(this.store);

  final AppStore store;
  Set expandSet = new Set();

  Future<void> _fetchBalance() async {
    await Future.wait([
      webApi.assets.fetchBalance(store.account.currentAccount.pubKey),
      webApi.staking.fetchAccountStaking(store.account.currentAccount.pubKey),
    ]);
  }

  Future<BigInt> _fetchMXCBalance() async {
    print('Getting MXC account balance');
    EthereumApiAssetsMXC ethApiAssetsMXC = await EthereumApiAssetsMXC();
    BigInt balance = await ethApiAssetsMXC.getAccountBalanceFromMXCContract(
        kRpcUrlInfuraMainnet,
        kWsUrlInfuraMainnet,
        kContractAddrMXCMainnet,
        kSamplePrivateKey);
    return balance;
  }

  Future<BigInt> _fetchMXCLocked() async {
    print('Getting MXC locked');
    EthereumApiMiningMXC ethApiMiningMXC = await EthereumApiMiningMXC();
    BigInt locked = await ethApiMiningMXC
        .getAccountLockedMXCAmountFromDataHighwayMXCMiningContract(
            kRpcUrlInfuraMainnet,
            kWsUrlInfuraMainnet,
            kContractAddrMXCMainnet,
            kSamplePrivateKey);
    return locked;
  }

  Future<BigInt> _fetchMXCLockedClaimsPending() async {
    print('Getting amount of pending reward claims for locking MXC');
    EthereumApiMiningMXC ethApiMiningMXC = await EthereumApiMiningMXC();
    BigInt claimsPending = await ethApiMiningMXC
        .getAccountLockedClaimsPendingOfMXCAmountFromDataHighwayMXCMiningContract(
            kRpcUrlInfuraMainnet,
            kWsUrlInfuraMainnet,
            kContractAddrMXCMainnet,
            kSamplePrivateKey);
    return claimsPending;
  }

  Future<BigInt> _fetchMXCLockedClaimsApproved() async {
    print('Getting amount of approved reward claims for locking MXC');
    EthereumApiMiningMXC ethApiMiningMXC = await EthereumApiMiningMXC();
    BigInt claimsApproved = await ethApiMiningMXC
        .getAccountLockedClaimsApprovedOfMXCAmountFromDataHighwayMXCMiningContract(
            kRpcUrlInfuraMainnet,
            kWsUrlInfuraMainnet,
            kContractAddrMXCMainnet,
            kSamplePrivateKey);
    return claimsApproved;
  }

  Future<BigInt> _fetchMXCLockedClaimsRejected() async {
    print('Getting amount of rejected reward claims for locking MXC');
    EthereumApiMiningMXC ethApiMiningMXC = await EthereumApiMiningMXC();
    BigInt claimsRejected = await ethApiMiningMXC
        .getAccountLockedClaimsRejectedOfMXCAmountFromDataHighwayMXCMiningContract(
            kRpcUrlInfuraMainnet,
            kWsUrlInfuraMainnet,
            kContractAddrMXCMainnet,
            kSamplePrivateKey);
    return claimsRejected;
  }

  Future<BigInt> _countMXCLockedTotalClaimed() async {
    BigInt count = await _fetchMXCLockedClaimsPending() +
        await _fetchMXCLockedClaimsApproved() +
        await _fetchMXCLockedClaimsRejected();
    return count;
  }

  Future<Map<String, double>>
      _calculateMXCLockedClaimEligibilityProportions() async {
    Map<String, double> claimEligibilityProportionsMXCLocked = {
      'pending': await _fetchMXCLockedClaimsPending() /
          await _countMXCLockedTotalClaimed(),
      'approved': await _fetchMXCLockedClaimsApproved() /
          await _countMXCLockedTotalClaimed(),
      'rejected': await _fetchMXCLockedClaimsRejected() /
          await _countMXCLockedTotalClaimed()
    };
    return claimEligibilityProportionsMXCLocked;
  }

  Future<BigInt> _fetchMXCSignalled() async {
    print('Getting MXC signalled');
    EthereumApiMiningMXC ethApiMiningMXC = await EthereumApiMiningMXC();
    BigInt signalled = await ethApiMiningMXC
        .getAccountSignalledMXCAmountFromDataHighwayMXCMiningContract(
            kRpcUrlInfuraMainnet,
            kWsUrlInfuraMainnet,
            kContractAddrMXCMainnet,
            kSamplePrivateKey);
    return signalled;
  }

  Future<BigInt> _fetchMXCSignalledClaimsPending() async {
    print('Getting amount of pending reward claims for signalling MXC');
    EthereumApiMiningMXC ethApiMiningMXC = await EthereumApiMiningMXC();
    BigInt claimsPending = await ethApiMiningMXC
        .getAccountSignalledClaimsPendingOfMXCAmountFromDataHighwayMXCMiningContract(
            kRpcUrlInfuraMainnet,
            kWsUrlInfuraMainnet,
            kContractAddrMXCMainnet,
            kSamplePrivateKey);
    return claimsPending;
  }

  Future<BigInt> _fetchMXCSignalledClaimsApproved() async {
    print('Getting amount of approved reward claims for signalling MXC');
    EthereumApiMiningMXC ethApiMiningMXC = await EthereumApiMiningMXC();
    BigInt claimsApproved = await ethApiMiningMXC
        .getAccountSignalledClaimsApprovedOfMXCAmountFromDataHighwayMXCMiningContract(
            kRpcUrlInfuraMainnet,
            kWsUrlInfuraMainnet,
            kContractAddrMXCMainnet,
            kSamplePrivateKey);
    return claimsApproved;
  }

  Future<BigInt> _fetchMXCSignalledClaimsRejected() async {
    print('Getting amount of rejected reward claims for signalling MXC');
    EthereumApiMiningMXC ethApiMiningMXC = await EthereumApiMiningMXC();
    BigInt claimsRejected = await ethApiMiningMXC
        .getAccountSignalledClaimsRejectedOfMXCAmountFromDataHighwayMXCMiningContract(
            kRpcUrlInfuraMainnet,
            kWsUrlInfuraMainnet,
            kContractAddrMXCMainnet,
            kSamplePrivateKey);
    return claimsRejected;
  }

  Future<BigInt> _countMXCSignalledTotalClaimed() async {
    BigInt count = await _fetchMXCSignalledClaimsPending() +
        await _fetchMXCSignalledClaimsApproved() +
        await _fetchMXCSignalledClaimsRejected();
    return count;
  }

  Future<Map<String, double>>
      _calculateMXCSignalledClaimEligibilityProportions() async {
    Map<String, double> claimEligibilityProportionsMXCSignalled = {
      'pending': await _fetchMXCSignalledClaimsPending() /
          await _countMXCSignalledTotalClaimed(),
      'approved': await _fetchMXCSignalledClaimsApproved() /
          await _countMXCSignalledTotalClaimed(),
      'rejected': await _fetchMXCSignalledClaimsRejected() /
          await _countMXCSignalledTotalClaimed()
    };
    return claimEligibilityProportionsMXCSignalled;
  }

  Future<BigInt> _fetchIOTAPeggedSignalled() async {
    print('Getting IOTA (pegged) signalled');
    EthereumApiMiningIOTAPegged ethApiMiningIOTAPegged =
        await EthereumApiMiningIOTAPegged();
    BigInt signalled = await ethApiMiningIOTAPegged
        .getAccountSignalledIOTAPeggedAmountFromDataHighwayIOTAPeggedMiningContract(
            kRpcUrlInfuraMainnet,
            kWsUrlInfuraMainnet,
            kContractAddrMXCMainnet,
            kSamplePrivateKey);
    return signalled;
  }

  Future<BigInt> _fetchIOTAPeggedSignalledClaimsPending() async {
    print(
        'Getting amount of pending reward claims for signalling IOTA (pegged)');
    EthereumApiMiningIOTAPegged ethApiMiningIOTAPegged =
        await EthereumApiMiningIOTAPegged();
    BigInt claimsSignalledPending = await ethApiMiningIOTAPegged
        .getAccountSignalledClaimsPendingOfIOTAPeggedAmountFromDataHighwayIOTAPeggedMiningContract(
            kRpcUrlInfuraMainnet,
            kWsUrlInfuraMainnet,
            kContractAddrMXCMainnet,
            kSamplePrivateKey);
    return claimsSignalledPending;
  }

  Future<BigInt> _fetchIOTAPeggedSignalledClaimsApproved() async {
    print(
        'Getting amount of approved reward claims for signalling IOTA (pegged)');
    EthereumApiMiningIOTAPegged ethApiMiningIOTAPegged =
        await EthereumApiMiningIOTAPegged();
    BigInt claimsSignalledApproved = await ethApiMiningIOTAPegged
        .getAccountSignalledClaimsApprovedOfIOTAPeggedAmountFromDataHighwayIOTAPeggedMiningContract(
            kRpcUrlInfuraMainnet,
            kWsUrlInfuraMainnet,
            kContractAddrMXCMainnet,
            kSamplePrivateKey);
    return claimsSignalledApproved;
  }

  Future<BigInt> _fetchIOTAPeggedSignalledClaimsRejected() async {
    print(
        'Getting amount of rejected reward claims for signalling IOTA (pegged)');
    EthereumApiMiningIOTAPegged ethApiMiningIOTAPegged =
        await EthereumApiMiningIOTAPegged();
    BigInt claimsSignalledRejected = await ethApiMiningIOTAPegged
        .getAccountSignalledClaimsRejectedOfIOTAPeggedAmountFromDataHighwayIOTAPeggedMiningContract(
            kRpcUrlInfuraMainnet,
            kWsUrlInfuraMainnet,
            kContractAddrMXCMainnet,
            kSamplePrivateKey);
    return claimsSignalledRejected;
  }

  Future<BigInt> _countIOTAPeggedSignalledTotalClaimed() async {
    BigInt count = await _fetchIOTAPeggedSignalledClaimsPending() +
        await _fetchIOTAPeggedSignalledClaimsApproved() +
        await _fetchIOTAPeggedSignalledClaimsRejected();
    return count;
  }

  Future<Map<String, double>>
      _calculateIOTAPeggedSignalledClaimEligibilityProportions() async {
    Map<String, double> claimEligibilityProportionsIOTAPeggedSignalled = {
      'pending': await _fetchIOTAPeggedSignalledClaimsPending() /
          await _countIOTAPeggedSignalledTotalClaimed(),
      'approved': await _fetchIOTAPeggedSignalledClaimsApproved() /
          await _countIOTAPeggedSignalledTotalClaimed(),
      'rejected': await _fetchIOTAPeggedSignalledClaimsRejected() /
          await _countIOTAPeggedSignalledTotalClaimed()
    };
    return claimEligibilityProportionsIOTAPeggedSignalled;
  }

  Widget _buildTopCard(BuildContext context) {
    var dic = I18n.of(context).assets;
    String network = store.settings.loading
        ? dic['node.connecting']
        : store.settings.networkName ?? dic['node.failed'];

    AccountData acc = store.account.currentAccount;

    return RoundedCard(
      padding: EdgeInsets.all(8),
      child: Column(
        children: <Widget>[
          ListTile(
            leading: AddressIcon('', pubKey: acc.pubKey),
            title: Text(acc.name ?? ''),
            subtitle: Text(network),
          ),
          ListTile(
            title: Text(Fmt.address(store.account.currentAddress)),
            trailing: IconButton(
              icon: Image.asset(
                'assets/images/assets/Assets_nav_code.png',
                color: Colors.deepPurple,
              ),
              onPressed: () {
                if (acc.address != '') {
                  Navigator.pushNamed(context, ReceivePage.route);
                }
              },
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
      // TODO - find out how to add Custom Types (see https://github.com/polkawallet-io/polkawallet-flutter/issues/19)
      webApi.connectNode();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        String symbol = store.settings.networkState.tokenSymbol;
        String networkName = store.settings.networkName;
        return RefreshIndicator(
          key: globalBalanceRefreshKey,
          onRefresh: _fetchBalance,
          child: ListView(
            padding: EdgeInsets.only(left: 16, right: 16),
            children: <Widget>[
              _buildTopCard(context),
              Padding(
                padding: EdgeInsets.only(top: 32),
                child: BorderedTitle(
                  title: I18n.of(context).home['assets'],
                ),
              ),
              item(context,
                  store: store,
                  symbol: 'DHX',
                  name: 'DataHighway',
                  expandSet: expandSet,
                  expandTap: () => _onTapExpand(expandSet, 'DataHighway'),
                  methods: {
                    'fetchMXCBalance': _fetchMXCBalance,
                    'fetchMXCLocked': _fetchMXCLocked,
                    'fetchMXCLockedClaimsPending': _fetchMXCLockedClaimsPending,
                    'fetchMXCLockedClaimsApproved':
                        _fetchMXCLockedClaimsApproved,
                    'fetchMXCLockedClaimsRejected':
                        _fetchMXCLockedClaimsRejected,
                    'calculateMXCLockedClaimEligibilityProportions':
                        _calculateMXCLockedClaimEligibilityProportions,
                    'fetchMXCSignalled': _fetchMXCSignalled,
                    'fetchMXCSignalledClaimsPending':
                        _fetchMXCSignalledClaimsPending,
                    'fetchMXCSignalledClaimsApproved':
                        _fetchMXCSignalledClaimsApproved,
                    'fetchMXCSignalledClaimsRejected':
                        _fetchMXCSignalledClaimsRejected,
                    'calculateMXCSignalledClaimEligibilityProportions':
                        _calculateMXCSignalledClaimEligibilityProportions,
                    'fetchIOTAPeggedSignalled': _fetchIOTAPeggedSignalled,
                    'fetchIOTAPeggedSignalledClaimsPending':
                        _fetchIOTAPeggedSignalledClaimsPending,
                    'fetchIOTAPeggedSignalledClaimsApproved':
                        _fetchIOTAPeggedSignalledClaimsApproved,
                    'fetchIOTAPeggedSignalledClaimsRejected':
                        _fetchIOTAPeggedSignalledClaimsRejected,
                    'calculateIOTAPeggedSignalledClaimEligibilityProportions':
                        _calculateIOTAPeggedSignalledClaimEligibilityProportions
                  }),
              item(context,
                  store: store,
                  symbol: symbol,
                  name: networkName,
                  expandSet: expandSet,
                  expandTap: () => _onTapExpand(expandSet, networkName))
            ],
          ),
        );
      },
    );
  }

  void _onTapExpand(expandSet, name) {
    if (expandSet.contains(name)) {
      expandSet.remove(name);
    } else {
      expandSet.add(name);
    }

    setState(() {});
  }
}

Widget item(context,
    {store, symbol = '', name = '', Set expandSet, expandTap, methods}) {
  return RoundedCard(
      margin: EdgeInsets.only(top: 16),
      child: Column(children: <Widget>[
        itemHeader(context, store: store, symbol: symbol, name: name),
        Row(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(),
              ),
              itemButtons(context),
              operate(context,
                  name: name, expandSet: expandSet, expandTap: expandTap),
              Expanded(
                child: Container(),
              ),
            ]),
        expandSet != null && expandSet.contains(name)
            ? expandTab(context, {methods})
            : Container(),
        // itemExpand()
      ]));
}

Widget itemHeader(context, {store, symbol, name = ''}) {
  return ListTile(
    // contentPadding: EdgeInsets.symmetric(vertical:0),
    leading: Container(
      width: 40,
      height: 40,
      child: symbol == 'DataHightway'
          ? Image.asset('assets/images/assets/DHX.png')
          : Image.asset(
              'assets/images/assets/${symbol.isNotEmpty ? symbol : 'DOT'}.png'),
    ),
    title: Text(symbol ?? ''),
    subtitle: Text(name.isNotEmpty ? name : '~'),
    trailing: Container(
      width: 120,
      // padding: const EdgeInsets.only(bottom:10),
      child: ListTile(
        isThreeLine: true,
        dense: true,
        contentPadding: EdgeInsets.zero,
        title: Text(
          Fmt.balance(store.assets.balance),
          textAlign: TextAlign.left,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black54),
        ),
        subtitle: Row(
          // padding: EdgeInsets.zero,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(I18n.of(context).assets['balance'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                )),
            // TODO - show DataHighway account balance
            const Text(
              ' (~3000 USD)',
              style: TextStyle(color: Colors.grey, fontSize: 10),
            )
          ],
        ),
      ),
    ),
    // onTap: () {
    // Navigator.pushNamed(context, AssetPage.route);
    // },
  );
}

Widget operate(context, {name = '', expandSet, expandTap}) {
  return Container(
      // padding: EdgeInsets.only(right:20),
      child: Row(children: <Widget>[
    // Expanded(
    //   flex: 1,
    //   child: Container(),
    // ),
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

final List<String> itemButtonsList = [
  // 'topup',
  // 'withdraw',
  'lock',
  'signal',
  'claim',
];

Widget itemButtons(context) {
  var dic = I18n.of(context).assets;

  return DefaultTabController(
      length: itemButtonsList.length,
      child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: TabBar(
              isScrollable: true,
              labelPadding: EdgeInsets.zero,
              indicatorPadding: EdgeInsets.zero,
              indicator: const BoxDecoration(),
              // indicator: BoxDecoration(
              //   border: Border.all(
              //     style: BorderStyle.solid
              //   )
              // ),
              labelColor: Colors.black87,
              unselectedLabelColor: Colors.black38,
              tabs: itemButtonsList.map((btnName) {
                return Tab(
                  // text: itemTab,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 0.5),
                      // borderRadius: BorderRadius.circular(6.0),
                    ),
                    child: Text(dic[btnName]),
                  ),
                );
              }).toList(),
              onTap: (index) => _tapBtns(context, index))));
}

void _tapBtns(context, index) {
  String name = itemButtonsList[index];
  switch (name) {
    case 'topup':
      break;
    case 'withdraw':
      break;
    case 'signal':
      Navigator.pushNamed(context, SignalPage.route);
      break;
    case 'lock':
      Navigator.pushNamed(context, LockPage.route);
      break;
    case 'claim':
      Navigator.pushNamed(context, ClaimPage.route);
      break;
    default:
      break;
  }
}

final List<String> itemTabList = [
  'claim.eligibility.MXC',
  'claim.eligibility.IOTA',
  'rewards'
];

Widget expandTab(context, methods) {
  var dic = I18n.of(context).assets;

  return DefaultTabController(
      length: itemTabList.length,
      child: Column(children: <Widget>[
        TabBar(
          onTap: (index) {},
          isScrollable: true,
          // indicator: const BoxDecoration(),
          indicatorSize: TabBarIndicatorSize.label,
          labelColor: Colors.black87,
          unselectedLabelColor: Colors.black38,
          tabs: itemTabList.map((itemTab) {
            if (itemTab == 'claim.eligibility.MXC') {
              return Tab(
                text: '${dic['claim.eligibility']} (MXC)',
              );
            } else if (itemTab == 'claim.eligibility.IOTA') {
              return Tab(
                text: '${dic['claim.eligibility']} (IOTA)',
              );
            } else {
              return Tab(
                text: dic[itemTab],
              );
            }
          }).toList(),
        ),
        Container(
            height: 110,
            child: TabBarView(
                children: itemTabList.map((itemTab) {
              if (itemTab == 'claim.eligibility.MXC') {
                return tabClaimEligibilityMXC(context, methods);
              } else if (itemTab == 'claim.eligibility.IOTA') {
                return tabClaimEligibilityIOTA(context, methods);
              } else {
                return tabRewards(context, methods);
              }
            }).toList()))
      ]));
}

Widget tabClaimEligibilityMXC(context, methods) {
  var dic = I18n.of(context).assets;
  ;

  return Center(
      child: Container(
    alignment: Alignment.center,
    padding: const EdgeInsets.all(8),
    child: Column(children: <Widget>[
      Row(children: <Widget>[
        content(
          '',
        ),
        content(dic['approved']),
        content(dic['pending']),
        content(dic['rejected']),
      ]),
      Row(children: <Widget>[
        content(dic['locked']),
        content(
            '${methods['fetchMXCLockedClaimsApproved']()} ${methods['calculateMXCLockedClaimEligibilityProportions']()['approved']}%',
            color: Colors.green), // Approved
        content(
            '${methods['fetchMXCLockedClaimsPending']()} ${methods['calculateMXCLockedClaimEligibilityProportions']()['pending']}%',
            color: Colors.orange), // Pending
        content(
            '${methods['fetchMXCLockedClaimsRejected']()} ${methods['calculateMXCLockedClaimEligibilityProportions']()['rejected']}%',
            color: Colors.red), // Rejected
      ]),
      Row(children: <Widget>[
        content(dic['signaled']),
        content(
            '${methods['fetchMXCSignalledClaimsApproved']()} ${methods['calculateMXCSignalledClaimEligibilityProportions']()['approved']}%',
            color: methods['fetchMXCSignalledClaimsApproved']() > 0
                ? Colors.green
                : Colors.grey), // Approved
        content(
            '${methods['fetchMXCSignalledClaimsPending']()} ${methods['calculateMXCSignalledClaimEligibilityProportions']()['pending']}%',
            color: methods['fetchMXCSignalledClaimsPending']() > 0
                ? Colors.orange
                : Colors.grey), // Pending
        content(
            '${methods['fetchMXCSignalledClaimsRejected']()} ${methods['calculateMXCSignalledClaimEligibilityProportions']()['rejected']}%',
            color: methods['fetchMXCSignalledClaimsRejected']()
                ? Colors.red
                : Colors.grey), // Rejected
      ]),
    ]),
  ));
}

Widget tabClaimEligibilityIOTA(context, methods) {
  var dic = I18n.of(context).assets;

  return Center(
      child: Container(
    alignment: Alignment.center,
    padding: const EdgeInsets.all(8),
    child: Column(children: <Widget>[
      Row(children: <Widget>[
        content(
          '',
        ),
        content(dic['approved']),
        content(dic['pending']),
        content(dic['rejected']),
      ]),
      Row(children: <Widget>[
        content(dic['locked']),
        content('N/A', color: Colors.grey),
        content('N/A', color: Colors.grey),
        content('N/A', color: Colors.grey),
      ]),
      Row(children: <Widget>[
        content(dic['signaled']),
        content(
            '${methods['fetchIOTAPeggedSignalledClaimsApproved']()} ${methods['calculateIOTAPeggedSignalledClaimEligibilityProportions']()['approved']}%',
            color: methods['fetchIOTAPeggedSignalledClaimsApproved']() > 0
                ? Colors.green
                : Colors.grey), // Approved
        content(
            '${methods['fetchIOTAPeggedSignalledClaimsPending']()} ${methods['calculateIOTAPeggedSignalledClaimEligibilityProportions']()['pending']}%',
            color: methods['fetchIOTAPeggedSignalledClaimsPending']() > 0
                ? Colors.orange
                : Colors.grey), // Pending
        content(
            '${methods['fetchIOTAPeggedSignalledClaimsRejected']()} ${methods['calculateIOTAPeggedSignalledClaimEligibilityProportions']()['rejected']}%',
            color: methods['fetchIOTAPeggedSignalledClaimsRejected']() > 0
                ? Colors.red
                : Colors.grey), // Rejected
      ]),
    ]),
  ));
}

Widget tabRewards(context, methods) {
  var dic = I18n.of(context).assets;

  return Center(
      child: Container(
    alignment: Alignment.center,
    padding: const EdgeInsets.all(8),
    child: Column(children: <Widget>[
      Row(children: <Widget>[
        content(dic['staking']),
        content(
          'MSB',
        ),
        content(dic['total']),
      ]),
      Row(children: <Widget>[
        content(
          '24000',
        ),
        content(
          '1.025',
        ),
        content('2460', color: Colors.green),
      ]),
      Row(children: <Widget>[
        content(
          '24000',
        ),
        content(
          '1.025',
        ),
        content('2460', color: Colors.green),
      ])
    ]),
  ));
}

Widget content(text, {color = Colors.black, fontWeight = FontWeight.normal}) {
  return Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(color: color, fontSize: 12, fontWeight: fontWeight),
      ),
    ),
  );
}
