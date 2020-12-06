import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:polka_wallet/page/assets/claim/claim_details_page.dart';
import 'package:polka_wallet/service/ethereum_api/api.dart';
import 'package:polka_wallet/utils/format.dart';
import 'package:polka_wallet/utils/i18n/index.dart';

class ClaimTile extends StatelessWidget {
  final Claim claim;

  const ClaimTile({Key key, this.claim}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dic = I18n.of(context).assets;
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(
        ClaimDetailsPage.route,
        arguments: claim,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              child: RotatedBox(
                quarterTurns: 1,
                child: FaIcon(
                  FontAwesomeIcons.wifi,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color(0xFF4665EA),
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(claim.transactionMessage.substring(0, 20)),
                  Text(
                    '${dic['signal.amount']}: ${Fmt.balance(claim.amount, 18)}',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Text(
                    '${dic['duration']}: ${claim.term.months} Months',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
