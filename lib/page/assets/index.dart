import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:polka_wallet/common/configs/sys.dart';
import 'package:polka_wallet/page/assets/asset/assetPage.dart';
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
      webApi.staking.fetchAccountStaking(store.account.currentAccount.pubKey),
      ethereum.getBalanceFormMXC()
    ]);
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
            kContractAddrMXCMainnet,
            kSamplePrivateKey);
    return claimsPending;
  }

  Future<BigInt> _fetchMXCLockedClaimsApproved() async {
    print('Getting amount of approved reward claims for locking MXC');
    EthereumApiMiningMXC ethApiMiningMXC = await EthereumApiMiningMXC();
    BigInt claimsApproved = await ethApiMiningMXC
        .getAccountLockedClaimsApprovedOfMXCAmountFromDataHighwayMXCMiningContract(
            kContractAddrMXCMainnet,
            kSamplePrivateKey);
    return claimsApproved;
  }

  Future<BigInt> _fetchMXCLockedClaimsRejected() async {
    print('Getting amount of rejected reward claims for locking MXC');
    EthereumApiMiningMXC ethApiMiningMXC = await EthereumApiMiningMXC();
    BigInt claimsRejected = await ethApiMiningMXC
        .getAccountLockedClaimsRejectedOfMXCAmountFromDataHighwayMXCMiningContract(
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
            kContractAddrMXCMainnet,
            kSamplePrivateKey);
    return claimsPending;
  }

  Future<BigInt> _fetchMXCSignalledClaimsApproved() async {
    print('Getting amount of approved reward claims for signalling MXC');
    EthereumApiMiningMXC ethApiMiningMXC = await EthereumApiMiningMXC();
    BigInt claimsApproved = await ethApiMiningMXC
        .getAccountSignalledClaimsApprovedOfMXCAmountFromDataHighwayMXCMiningContract(
            kContractAddrMXCMainnet,
            kSamplePrivateKey);
    return claimsApproved;
  }

  Future<BigInt> _fetchMXCSignalledClaimsRejected() async {
    print('Getting amount of rejected reward claims for signalling MXC');
    EthereumApiMiningMXC ethApiMiningMXC = await EthereumApiMiningMXC();
    BigInt claimsRejected = await ethApiMiningMXC
        .getAccountSignalledClaimsRejectedOfMXCAmountFromDataHighwayMXCMiningContract(
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
            kContractAddrMXCMainnet,
            kSamplePrivateKey);
    return claimsSignalledPending;
  }

  Future<BigInt> _fetchIOTAPeggedSignalledClaimsApproved() async {
    print(
        'Getting amount of approved reward claims for signalling IOTA (pegged)');
    EthereumApiMiningIOTAPegged ethApiMiningIOTAPegged =
        await EthereumApiMiningIOTAPegged();
    BigInt getClaimsSignalledApproved = await ethApiMiningIOTAPegged
        .getAccountSignalledClaimsApprovedOfIOTAPeggedAmountFromDataHighwayIOTAPeggedMiningContract(
            kContractAddrMXCMainnet,
            kSamplePrivateKey);
    return getClaimsSignalledApproved;
  }

  Future<BigInt> _fetchIOTAPeggedSignalledClaimsRejected() async {
    print(
        'Getting amount of rejected reward claims for signalling IOTA (pegged)');
    EthereumApiMiningIOTAPegged ethApiMiningIOTAPegged =
        await EthereumApiMiningIOTAPegged();
    BigInt claimsSignalledRejected = await ethApiMiningIOTAPegged
        .getAccountSignalledClaimsRejectedOfIOTAPeggedAmountFromDataHighwayIOTAPeggedMiningContract(
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
      webApi.connectNode();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        String symbol = store.settings.networkState.tokenSymbol;
        String networkName = store.settings.networkName ?? '';
        List expandSet = store.assets.isExpand;

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
              item(
                context,
                store: store,
                symbol: symbol,
                name: networkName,
                balance: Fmt.balance(store.assets.balance),
                expandSet: expandSet,
                expandTap: () => store.assets.setIsExpand(symbol),
              ),
              item(
                context,
                store: store,
                symbol: AssetsConfigs.mxc,
                name: AssetsConfigs.ethereum,
                balance: '${store.ethereum.balanceMXC}',
                expandSet: expandSet,
                expandTap: () => store.assets.setIsExpand(AssetsConfigs.mxc),
              //   methods: {
              //     'fetchMXCLocked': _fetchMXCLocked,
              //     'fetchMXCLockedClaimsPending': _fetchMXCLockedClaimsPending,
              //     'fetchMXCLockedClaimsApproved':
              //         _fetchMXCLockedClaimsApproved,
              //     'fetchMXCLockedClaimsRejected':
              //         _fetchMXCLockedClaimsRejected,
              //     'calculateMXCLockedClaimEligibilityProportions':
              //         _calculateMXCLockedClaimEligibilityProportions,
              //     'fetchMXCSignalled': _fetchMXCSignalled,
              //     'fetchMXCSignalledClaimsPending':
              //         _fetchMXCSignalledClaimsPending,
              //     'fetchMXCSignalledClaimsApproved':
              //         _fetchMXCSignalledClaimsApproved,
              //     'fetchMXCSignalledClaimsRejected':
              //         _fetchMXCSignalledClaimsRejected,
              //     'calculateMXCSignalledClaimEligibilityProportions':
              //         _calculateMXCSignalledClaimEligibilityProportions,
              //     'fetchIOTAPeggedSignalled': _fetchIOTAPeggedSignalled,
              //     'fetchIOTAPeggedSignalledClaimsPending':
              //         _fetchIOTAPeggedSignalledClaimsPending,
              //     'fetchIOTAPeggedSignalledClaimsApproved':
              //         _fetchIOTAPeggedSignalledClaimsApproved,
              //     'fetchIOTAPeggedSignalledClaimsRejected':
              //         _fetchIOTAPeggedSignalledClaimsRejected,
              //     'calculateIOTAPeggedSignalledClaimEligibilityProportions':
              //         _calculateIOTAPeggedSignalledClaimEligibilityProportions
              //   }
              ),
              item(
                context,
                store: store,
                symbol: AssetsConfigs.iota,
                name: AssetsConfigs.pegged,
                balance: '${store.ethereum.balanceIOTAPegged}',
                expandSet: expandSet,
                expandTap: () => store.assets.setIsExpand(AssetsConfigs.iota),
              )
            ],
          ),
        );
      },
    );
  }
}

Widget item(BuildContext context,{AppStore store, String symbol = '', String name = '', String balance = '0',List expandSet, Function expandTap, Map methods}) {
  return RoundedCard(
    margin: EdgeInsets.only(top: 16),
    child: Column(
      children: <Widget>[
        itemHeader(
          context, 
          balance: balance, 
          symbol: symbol, 
          name: name
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            itemButtons(context),
            operate(
              context,
              name: symbol, 
              expandSet: expandSet, 
              expandTap: expandTap
            ),
          ]
        ),
        Visibility(
          visible: expandSet.contains(symbol),
          child: expandTab(context, store, symbol)
        )
      ]
    )
  );
}

Widget itemHeader(BuildContext context, {String balance = '0', String symbol, String name = ''}) {

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
          balance,
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
              ' (0 USD)',
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

Widget operate(BuildContext context, {name = '', expandSet, expandTap}) {
  return Container(
    child: Row(
      children: <Widget>[
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
      ]
    )
  );
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


final itemList = {
  'menus': ['claim.eligibility','rewards'],
  'menus_DHX': ['rewards']
};


Widget expandTab(BuildContext context, AppStore store, String symbol) {
  var dic = I18n.of(context).assets;
  String menus = symbol == 'DHX' ? 'menus_DHX' : 'menus';

  return DefaultTabController(
    length: itemList[menus].length,
    child: Column(children: <Widget>[
      TabBar(
        onTap: (index) {},
        isScrollable: true,
        // indicator: const BoxDecoration(),
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: Colors.black87,
        unselectedLabelColor: Colors.black38,
        tabs: itemList[menus].map((itemTab) {
          if (itemTab == 'claim.eligibility') {
            return Tab(
              text: '${dic['claim.eligibility']} ($symbol)',
            );
          } else {
            return Tab(
              text: '${dic[itemTab]}($symbol)',
            );
          }
        }).toList(),
      ),
      Container(
        height: 110,
        child: TabBarView(
            children: itemList[menus].map((itemTab) {
              switch(symbol){
                case AssetsConfigs.mxc:
                  if (itemTab == 'claim.eligibility') {
                    return tabClaimEligibilityMXC(context, store, symbol);
                  } else {
                    return tabRewards(context, '0', '0');
                  }
                break;
                case AssetsConfigs.iota:
                  if (itemTab == 'claim.eligibility') {
                    return tabClaimEligibilityIOTA(context, store, symbol);
                  } else {
                    return tabRewards(context, '0', '0');
                  }
                break;
                default:
                  int staking = store.staking.staked ?? 0;
                  int total = store.staking.accountRewardTotal ?? 0;
                  return tabRewards(context, '$staking', '$total');
              }
        }).toList()))
      ]
    )
  );
}

Widget tabClaimEligibilityMXC(BuildContext context, AppStore store, String symbol) {
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
        Row(
          children: <Widget>[
            content(dic['locked']),
            content('${store.ethereum.claimsApprovedMXCLocked}(${store.ethereum.claimsApprovedProportionsMXCLocked}%)',color: Colors.green),
            content('${store.ethereum.claimsPendingMXCLocked}(${store.ethereum.claimsPendingProportionsMXCLocked}%)',color: Colors.orange),
            content('${store.ethereum.claimsRejectedMXCLocked}(${store.ethereum.claimsRejectedProportionsMXCLocked}%)',color: Colors.red)
          ]
        ),
        Row(
          children: <Widget>[
            content(dic['signaled']),
            content('${store.ethereum.claimsApprovedMXCSignaled}(${store.ethereum.claimsApprovedProportionsMXCSignaled}%)',color: Colors.green),
            content('${store.ethereum.claimsPendingMXCSignaled}(${store.ethereum.claimsPendingProportionsMXCSignaled}%)',color: Colors.orange),
            content('${store.ethereum.claimsRejectedMXCSignaled}(${store.ethereum.claimsRejectedProportionsMXCSignaled}%)',color: Colors.red)
          ]
        )
        // Row(children: <Widget>[
        //   content(dic['locked']),
        //   content(
        //       '${methods['fetchMXCLockedClaimsApproved']()} ${methods['calculateMXCLockedClaimEligibilityProportions']()['approved']}%',
        //       color: Colors.green), // Approved
        //   content(
        //       '${methods['fetchMXCLockedClaimsPending']()} ${methods['calculateMXCLockedClaimEligibilityProportions']()['pending']}%',
        //       color: Colors.orange), // Pending
        //   content(
        //       '${methods['fetchMXCLockedClaimsRejected']()} ${methods['calculateMXCLockedClaimEligibilityProportions']()['rejected']}%',
        //       color: Colors.red), // Rejected
        // ]),
        // Row(children: <Widget>[
        //   content(dic['signaled']),
        //   content(
        //       '${methods['fetchMXCSignalledClaimsApproved']()} ${methods['calculateMXCSignalledClaimEligibilityProportions']()['approved']}%',
        //       color: methods['fetchMXCSignalledClaimsApproved']() > 0
        //           ? Colors.green
        //           : Colors.grey), // Approved
        //   content(
        //       '${methods['fetchMXCSignalledClaimsPending']()} ${methods['calculateMXCSignalledClaimEligibilityProportions']()['pending']}%',
        //       color: methods['fetchMXCSignalledClaimsPending']() > 0
        //           ? Colors.orange
        //           : Colors.grey), // Pending
        //   content(
        //       '${methods['fetchMXCSignalledClaimsRejected']()} ${methods['calculateMXCSignalledClaimEligibilityProportions']()['rejected']}%',
        //       color: methods['fetchMXCSignalledClaimsRejected']()
        //           ? Colors.red
        //           : Colors.grey), // Rejected
        // ]),
      ]),
    )
  );
}

Widget tabClaimEligibilityIOTA(BuildContext context, AppStore store, String symbol) {
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
        content('${store.ethereum.claimsApprovedIOTAPeggedSignaled}(${store.ethereum.claimsApprovedProportionsIOTAPeggedSignaled}%)',color: Colors.green),
        content('${store.ethereum.claimsPendingIOTAPeggedSignaled}(${store.ethereum.claimsPendingProportionsIOTAPeggedSignaled}%)',color: Colors.orange),
        content('${store.ethereum.claimsRejectedIOTAPeggedSignaled}(${store.ethereum.claimsRejectedProportionsIOTAPeggedSignaled}%)',color: Colors.red)
        // content(
        //     '${methods['fetchIOTAPeggedSignalledClaimsApproved']()} ${methods['calculateIOTAPeggedSignalledClaimEligibilityProportions']()['approved']}%',
        //     color: methods['fetchIOTAPeggedSignalledClaimsApproved']() > 0
        //         ? Colors.green
        //         : Colors.grey), // Approved
        // content(
        //     '${methods['fetchIOTAPeggedSignalledClaimsPending']()} ${methods['calculateIOTAPeggedSignalledClaimEligibilityProportions']()['pending']}%',
        //     color: methods['fetchIOTAPeggedSignalledClaimsPending']() > 0
        //         ? Colors.orange
        //         : Colors.grey), // Pending
        // content(
        //     '${methods['fetchIOTAPeggedSignalledClaimsRejected']()} ${methods['calculateIOTAPeggedSignalledClaimEligibilityProportions']()['rejected']}%',
        //     color: methods['fetchIOTAPeggedSignalledClaimsRejected']() > 0
        //         ? Colors.red
        //         : Colors.grey), // Rejected
      ]),
    ]),
  ));
}

Widget tabRewards(BuildContext context, String staking, String total) {
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
            staking,
          ),
          content(
            '1.025',
          ),
          content(
            total, 
            color: double.parse(total) >= 0 ? Colors.green : Colors.red
          ),
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
        style: TextStyle(
          color: text.contains('0(') ? Colors.grey : color, 
          fontSize: 14, 
          fontWeight: fontWeight
        ),
      ),
    ),
  );
}
