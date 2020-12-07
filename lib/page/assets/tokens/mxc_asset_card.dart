import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:polka_wallet/common/configs/sys.dart';
import 'package:polka_wallet/constants.dart';
import 'package:polka_wallet/page/assets/asset_card.dart';
import 'package:polka_wallet/service/ethereum_api/api.dart';
import 'package:polka_wallet/service/substrateApi/api.dart';
import 'package:polka_wallet/store/app.dart';
import 'package:polka_wallet/store/assets/types/currency.dart';
import 'package:web3dart/web3dart.dart';

import 'tables/mxc_table_source.dart';

class _MxcAssetModel {
  final LockWalletStructsResponse lock;
  final SignalWalletStructsResponse signal;
  final Decimal balance;
  final double mxcMsb;

  _MxcAssetModel(this.lock, this.signal, this.balance, this.mxcMsb);
}

class MxcAssetCard extends StatefulWidget {
  final AppStore store;

  const MxcAssetCard({Key key, this.store}) : super(key: key);

  @override
  _MxcAssetCardState createState() => _MxcAssetCardState();
}

class _MxcAssetCardState extends State<MxcAssetCard> {
  void initState() {
    super.initState();
    _initFuture = getModel();
  }

  Future<_MxcAssetModel> _initFuture;
  Future<_MxcAssetModel> getModel() async {
    final ethAddress = EthereumAddress.fromHex(
        widget.store.account.currentAccount.ethereumAddress);
    final unparsed = await ethereum.mxcToken.balanceOf(ethAddress);
    final balance = unparsed.toDecimal();

    final lock = await ethereum.lockdrop
        .lockWalletStructs(ethAddress, ethereum.mxcToken.contractAddress);
    final signal = await ethereum.lockdrop
        .signalWalletStructs(ethAddress, ethereum.mxcToken.contractAddress);

    final msbRates = await webApi.datahighway.getMSBRates();

    return _MxcAssetModel(lock, signal, balance, msbRates.mxc);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_MxcAssetModel>(
      future: _initFuture,
      builder: (_, snap) => Column(
        children: [
          AssetCard(
            native: false,
            loading: !snap.hasData,
            image: AssetImage('assets/images/assets/MXC.png'),
            label: AssetsConfigs.mxc,
            subtitle: 'ERC-20',
            balance: snap.data?.balance?.toDouble(),
            usdBalance: 0,
            msb: snap.data?.mxcMsb,
            currency: TokenCurrency.mxc,
            expandedContent: AssetsCardContent(
              store: widget.store,
              tableSource: MxcTableSource(
                  snap.data?.lock, snap.data?.signal, snap.data?.mxcMsb),
            ),
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
