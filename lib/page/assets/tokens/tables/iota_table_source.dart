import 'package:flutter/material.dart';
import 'package:polka_wallet/page/assets/table_source.dart';
import 'package:polka_wallet/service/ethereum_api/api.dart';
import 'package:polka_wallet/store/app.dart';
import 'package:polka_wallet/utils/format.dart';
import 'package:polka_wallet/utils/i18n/index.dart';

class IotaTableSource extends TableSource {
  final SignalWalletStructsResponse signal;
  final double msb;

  IotaTableSource(this.signal, this.msb);

  String claimTableName(BuildContext context) {
    final dic = I18n.of(context).assets;
    return '${dic['claim.eligibility']} (IOTA)';
  }

  String rewardsTableName(BuildContext context) {
    final dic = I18n.of(context).assets;
    return '${dic['rewards']} (IOTA)';
  }

  Widget claimTable(BuildContext context, AppStore store) {
    final dic = I18n.of(context).assets;
    final decimals = store.settings.networkState.tokenDecimals;
    final signal = this.signal ??
        SignalWalletStructsResponse(
          approvedAmount: BigInt.zero,
          rejectedAmount: BigInt.zero,
          pendingAmount: BigInt.zero,
        );

    var totalSignal =
        signal.approvedAmount + signal.rejectedAmount + signal.pendingAmount;

    if (totalSignal == BigInt.zero) totalSignal = BigInt.one;

    final approvedSignalPercent =
        (signal.approvedAmount / totalSignal).toStringAsFixed(0);
    final rejectedSignalPercent =
        (signal.rejectedAmount / totalSignal).toStringAsFixed(0);
    final pendingSignalPercent =
        (signal.pendingAmount / totalSignal).toStringAsFixed(0);

    return Table(
      children: [
        TableRow(
          children: [
            Container(),
            content(dic['approved']),
            content(dic['pending']),
            content(dic['rejected']),
          ],
        ),
        TableRow(
          children: [
            content(dic['locked']),
            content('N/A', color: Colors.grey),
            content('N/A', color: Colors.grey),
            content('N/A', color: Colors.grey),
          ],
        ),
        TableRow(
          children: [
            content(
                '${dic['signaled']} ${signal.claimStatus == ClaimStatus.finalized ? '(finalized)' : ''}:'),
            content(
                '${Fmt.balance(signal.approvedAmount.toString(), decimals)} ($approvedSignalPercent%)',
                color: Colors.green),
            content(
                '${Fmt.balance(signal.pendingAmount.toString(), decimals)} ($pendingSignalPercent%)',
                color: Colors.orange),
            content(
              '${Fmt.balance(signal.rejectedAmount.toString(), decimals)} ($rejectedSignalPercent%)',
              color: Colors.red,
            )
          ],
        ),
      ],
    );
  }

  Widget rewardsTable(BuildContext context, AppStore store) {
    var dic = I18n.of(context).assets;
    int staking = 0;
    int total = 0;
    return Table(
      children: [
        TableRow(
          children: [
            content(dic['staking']),
            content('MSB'),
            content(dic['total']),
          ],
        ),
        TableRow(
          children: [
            content(
              staking.toString(),
            ),
            content(
              msb?.toStringAsFixed(3) ?? '???',
            ),
            content(total.toString(),
                color: double.parse(total.toString()) >= 0
                    ? Colors.green
                    : Colors.red),
          ],
        ),
      ],
    );
  }
}
