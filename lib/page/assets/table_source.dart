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
