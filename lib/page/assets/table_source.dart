import 'package:flutter/material.dart';
import 'package:polka_wallet/store/app.dart';
import 'package:polka_wallet/utils/format.dart';
import 'package:polka_wallet/utils/i18n/index.dart';

abstract class TableSource {
  Widget content(String val, {Color color}) {
    return Container(
      padding: EdgeInsets.all(5),
      child: Text(
        val,
        textAlign: TextAlign.center,
      ),
    );
  }

  String claimTableName(BuildContext context);
  String rewardsTableName(BuildContext context);

  Widget claimTable(BuildContext context, AppStore store);
  Widget rewardsTable(BuildContext context, AppStore store) {
    var dic = I18n.of(context).assets;
    int staking = store.staking.staked ?? 0;
    int total = store.staking.accountRewardTotal ?? 0;
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
              '1.025',
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

class MxcTableSource extends TableSource {
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
                '${dic['locked']} ${store.ethereum.claimsStatusMXCLocked.toString() == '1' ? '(finalized)' : ''}:'),
            content(
                '${Fmt.balanceNoDecimals(store.ethereum.claimsApprovedMXCLocked.toString(), decimals: decimals)} (${store.ethereum.claimsApprovedProportionsMXCLocked}%)',
                color: Colors.green),
            content(
                '${Fmt.balanceNoDecimals(store.ethereum.claimsPendingMXCLocked.toString(), decimals: decimals)} (${store.ethereum.claimsPendingProportionsMXCLocked}%)',
                color: Colors.orange),
            content(
                '${Fmt.balanceNoDecimals(store.ethereum.claimsRejectedMXCLocked.toString(), decimals: decimals)} (${store.ethereum.claimsRejectedProportionsMXCLocked}%)',
                color: Colors.red)
          ],
        ),
        TableRow(
          children: [
            content(
                '${dic['signaled']} ${store.ethereum.claimsStatusMXCSignaled.toString() == '1' ? '(finalized)' : ''}:'),
            content(
                '${Fmt.balanceNoDecimals(store.ethereum.claimsApprovedMXCSignaled.toString(), decimals: decimals)} (${store.ethereum.claimsApprovedProportionsMXCSignaled}%)',
                color: Colors.green),
            content(
                '${Fmt.balanceNoDecimals(store.ethereum.claimsPendingMXCSignaled.toString(), decimals: decimals)} (${store.ethereum.claimsPendingProportionsMXCSignaled}%)',
                color: Colors.orange),
            content(
                '${Fmt.balanceNoDecimals(store.ethereum.claimsRejectedMXCSignaled.toString(), decimals: decimals)} (${store.ethereum.claimsRejectedProportionsMXCSignaled}%)',
                color: Colors.red)
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
              '1.025',
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

class IotaTableSource extends TableSource {
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
                '${dic['signaled']} ${store.ethereum.claimsStatusIOTAPeggedSignaled.toString() == '1' ? '(finalized)' : ''}'),
            content(
                '${Fmt.balanceNoDecimals(store.ethereum.claimsApprovedIOTAPeggedSignaled.toString(), decimals: decimals)}(${store.ethereum.claimsApprovedProportionsIOTAPeggedSignaled}%)',
                color: Colors.green),
            content(
                '${Fmt.balanceNoDecimals(store.ethereum.claimsPendingIOTAPeggedSignaled.toString(), decimals: decimals)}(${store.ethereum.claimsPendingProportionsIOTAPeggedSignaled}%)',
                color: Colors.orange),
            content(
                '${Fmt.balanceNoDecimals(store.ethereum.claimsRejectedIOTAPeggedSignaled.toString(), decimals: decimals)}(${store.ethereum.claimsRejectedProportionsIOTAPeggedSignaled}%)',
                color: Colors.red)
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
              '1.025',
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
