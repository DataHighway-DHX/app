import 'package:flutter/material.dart';
import 'package:polka_wallet/page/assets/table_source.dart';
import 'package:polka_wallet/service/ethereum_api/api.dart';
import 'package:polka_wallet/store/app.dart';
import 'package:polka_wallet/utils/format.dart';
import 'package:polka_wallet/utils/i18n/index.dart';

class MxcTableSource extends TableSource {
  final LockWalletStructsResponse lock;
  final SignalWalletStructsResponse signal;
  final double msb;

  MxcTableSource(this.lock, this.signal, this.msb);

  String claimTableName(BuildContext context) {
    final dic = I18n.of(context).assets;
    return '${dic['claim.eligibility']} (MXC)';
  }

  String rewardsTableName(BuildContext context) {
    final dic = I18n.of(context).assets;
    return '${dic['rewards']} (MXC)';
  }

  Widget claimTable(BuildContext context, AppStore store) {
    final dic = I18n.of(context).assets;
    final decimals = store.settings.networkState.tokenDecimals;
    final lock = this.lock ??
        LockWalletStructsResponse(
          approvedAmount: BigInt.zero,
          rejectedAmount: BigInt.zero,
          pendingAmount: BigInt.zero,
        );
    final signal = this.signal ??
        SignalWalletStructsResponse(
          approvedAmount: BigInt.zero,
          rejectedAmount: BigInt.zero,
          pendingAmount: BigInt.zero,
        );

    var totalLock =
        lock.approvedAmount + lock.rejectedAmount + lock.pendingAmount;

    if (totalLock == BigInt.zero) totalLock = BigInt.one;

    final approvedLockPercent =
        (lock.approvedAmount / totalLock * 100).toStringAsFixed(0);
    final rejectedLockPercent =
        (lock.rejectedAmount / totalLock * 100).toStringAsFixed(0);
    final pendingLockPercent =
        (lock.pendingAmount / totalLock * 100).toStringAsFixed(0);

    var totalSignal =
        signal.approvedAmount + signal.rejectedAmount + signal.pendingAmount;

    if (totalSignal == BigInt.zero) totalSignal = BigInt.one;

    final approvedSignalPercent =
        (signal.approvedAmount / totalSignal * 100).toStringAsFixed(0);
    final rejectedSignalPercent =
        (signal.rejectedAmount / totalSignal * 100).toStringAsFixed(0);
    final pendingSignalPercent =
        (signal.pendingAmount / totalSignal * 100).toStringAsFixed(0);

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
            content(
                '${dic['locked']} ${lock.claimStatus == ClaimStatus.finalized ? '(finalized)' : ''}:'),
            content(
                '${Fmt.balance(lock.approvedAmount.toString(), decimals)} ($approvedLockPercent%)',
                color: Colors.green),
            content(
                '${Fmt.balance(lock.pendingAmount.toString(), decimals)} ($pendingLockPercent%)',
                color: Colors.orange),
            content(
                '${Fmt.balance(lock.rejectedAmount.toString(), decimals)} ($rejectedLockPercent%)',
                color: Colors.red)
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
