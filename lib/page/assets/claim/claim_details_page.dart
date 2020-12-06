import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:polka_wallet/store/app.dart';
import 'package:polka_wallet/utils/format.dart';
import 'package:polka_wallet/utils/i18n/index.dart';
import 'package:polka_wallet/service/ethereum_api/api.dart';

class ClaimDetailsPage extends StatelessWidget {
  static final String route = '/assets/claim/details';
  final Claim claim;

  ClaimDetailsPage(AppStore store, this.claim);

  Widget tableRow(BuildContext context, String title, String content,
      {bool copyable = false}) {
    Claim claim = Claim();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(title),
          ),
          Expanded(
            child: Text(
              content,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          if (copyable)
            GestureDetector(
              child: Icon(
                Icons.content_copy,
                size: 20,
                color: Theme.of(context).primaryColor,
              ),
            )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dic = I18n.of(context).assets;
    return Scaffold(
      appBar: AppBar(
        title: Text(dic['claim.transaction']),
        centerTitle: true,
        elevation: 0,
      ),
      body: Card(
        margin: EdgeInsets.all(16),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
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
              ),
              SizedBox(height: 16),
              tableRow(context, dic['from'], Fmt.address(claim.ethereumAccount),
                  copyable: true),
              tableRow(context, dic['to'], Fmt.address(claim.tokenAddress),
                  copyable: true),
              tableRow(context, dic['amount'],
                  '${Fmt.balance(claim.amount, 18)} ${claim.tokenName.toUpperCase()}'),
              tableRow(context, dic['transaction.fee'], 'TBD'),
              tableRow(context, dic['expected.msb'], 'TBD'),
              tableRow(context, dic['duration'], '${claim.term.months} months'),
              tableRow(context, dic['timestamp'], 'TBD days ago'),
              tableRow(
                  context, dic['transaction.hash'], claim.depositTransaction),
              SizedBox(height: 25),
              Text(
                dic['your.claim'],
                style: Theme.of(context).textTheme.headline1,
              ),
              SizedBox(height: 10),
              Text(dic['transaction.success'])
            ],
          ),
        ),
      ),
    );
  }
}
