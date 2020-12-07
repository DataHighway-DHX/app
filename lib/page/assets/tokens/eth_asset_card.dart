import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:polka_wallet/constants.dart';
import 'package:polka_wallet/page/assets/asset_card.dart';
import 'package:polka_wallet/service/ethereum_api/api.dart';
import 'package:polka_wallet/store/app.dart';
import 'package:web3dart/web3dart.dart';

class EthAssetCard extends StatefulWidget {
  final AppStore store;

  const EthAssetCard({Key key, this.store}) : super(key: key);

  @override
  _EthAssetCardState createState() => _EthAssetCardState();
}

class _EthAssetCardState extends State<EthAssetCard> {
  void initState() {
    super.initState();
    _getBalanceFuture = getBalance();
  }

  Future<Decimal> _getBalanceFuture;
  Future<Decimal> getBalance() async {
    final unparsed = await ethereum.getBalance(
      EthereumAddress.fromHex(
          widget.store.account.currentAccount.ethereumAddress),
    );
    return unparsed.toDecimal();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Decimal>(
      future: _getBalanceFuture,
      builder: (_, snap) => Column(
        children: [
          AssetCard(
            native: false,
            loading: !snap.hasData,
            image: AssetImage('assets/images/assets/currencies/ETH.png'),
            label: 'ETH',
            subtitle: 'GAS',
            balance: snap.data?.toDouble(),
            usdBalance: 0,
            claim: false,
            lock: false,
            signal: false,
          ),
          if (snap.hasError && kDebugMode)
            Container(
              padding: EdgeInsets.all(10),
              color: Colors.red,
              child: Text(
                snap.error.toString(),
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(color: Colors.white),
              ),
            )
        ],
      ),
    );
  }
}
