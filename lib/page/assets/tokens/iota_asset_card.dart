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

import 'tables/iota_table_source.dart';

class _IotaAssetModel {
  final SignalWalletStructsResponse signal;
  final Decimal balance;
  final double iotaMsb;

  _IotaAssetModel(this.signal, this.balance, this.iotaMsb);
}

class IotaAssetCard extends StatefulWidget {
  final AppStore store;

  const IotaAssetCard({Key key, this.store}) : super(key: key);

  @override
  _IotaAssetCardState createState() => _IotaAssetCardState();
}

class _IotaAssetCardState extends State<IotaAssetCard> {
  void initState() {
    super.initState();
    _initFuture = getModel();
  }

  Future<_IotaAssetModel> _initFuture;
  Future<_IotaAssetModel> getModel() async {
    final unparsed = await ethereum.iotaToken.balanceOf(kAccountAddrTestnet);
    final balance = unparsed.toDecimal();

    final signal = await ethereum.lockdrop
        .signalWalletStructs(kAccountAddrTestnet, kContractAddrMXCTestnet);

    final msbRates = await webApi.datahighway.getMSBRates();

    return _IotaAssetModel(signal, balance, msbRates.iota);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_IotaAssetModel>(
      future: _initFuture,
      builder: (_, snap) => Column(
        children: [
          AssetCard(
            image: AssetImage('assets/images/assets/currencies/IOTA.png'),
            label: AssetsConfigs.iota,
            subtitle: 'ERC-20',
            balance: snap.data?.balance?.toDouble(),
            usdBalance: 0,
            currency: TokenCurrency.iota,
            expandedContent: AssetsCardContent(
              store: widget.store,
              tableSource:
                  IotaTableSource(snap.data?.signal, snap.data?.iotaMsb),
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
