import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:polka_wallet/page/assets/claim/claim_details_page.dart';
import 'package:polka_wallet/utils/i18n/index.dart';

class ClaimTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dic = I18n.of(context).assets;
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(ClaimDetailsPage.route),
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
                  Text('3,Signal,2168,DHXPublicKe…'),
                  Text(
                    '${dic['signal.amount']}: 21,768.284',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Text(
                    '${dic['duration']}: 36 Months',
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
