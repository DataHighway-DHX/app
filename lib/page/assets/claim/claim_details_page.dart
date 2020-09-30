import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:polka_wallet/store/app.dart';
import 'package:polka_wallet/utils/i18n/index.dart';

class ClaimDetailsPage extends StatelessWidget {
  static final String route = '/assets/claim/details';

  ClaimDetailsPage(AppStore store);

  Widget tableRow(BuildContext context, String title, String content,
      {bool copyable = false}) {
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
              tableRow(context, dic['from'], '0x84294...w3ergtf',
                  copyable: true),
              tableRow(context, dic['to'], '0x84294...w3ergtf', copyable: true),
              tableRow(context, dic['amount'], '21.768 MXC'),
              tableRow(context, dic['transaction.fee'], '\$ 25'),
              tableRow(context, dic['expected.msb'], '1.00125'),
              tableRow(context, dic['duration'], '3 months'),
              tableRow(context, dic['timestamp'], '29 days ago'),
              tableRow(context, dic['blockchain'], 'Ethereum Testnet (Görli)'),
              tableRow(context, dic['transaction.hash'],
                  '6146ccf6a66d994f7c363db 875e31ca35581450a4bf6d3 be6cc9ac79233a69d0'),
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
