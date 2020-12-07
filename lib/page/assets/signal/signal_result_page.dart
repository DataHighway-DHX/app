import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:polka_wallet/common/components/transaction_message.dart';
import 'package:polka_wallet/common/widgets/roundedButton.dart';
import 'package:polka_wallet/page/assets/claim/claim_page.dart';
import 'package:polka_wallet/service/ethereum_api/api.dart';
import 'package:polka_wallet/store/app.dart';
import 'package:polka_wallet/utils/i18n/index.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'signal_params.dart';

class SignalResultPage extends StatefulWidget {
  SignalResultPage(this.store, this.signalParams);

  static final String route = '/assets/signal/result';
  final AppStore store;
  final SignalParams signalParams;

  @override
  _ResultPageState createState() => _ResultPageState(store);
}

class _ResultPageState extends State<SignalResultPage> {
  _ResultPageState(this.store);

  final AppStore store;
  bool _showMessageInQr = false;
  bool _continueBox = false;

  @override
  void initState() {
    super.initState();
    widget.signalParams.contractAddress = ethereum.lockdrop.contractAddress;
  }

  Future<void> signal() async {
    Navigator.of(context).pushNamed(ClaimPage.route, arguments: {
      'showHistory': false,
      'initialClaimType': ClaimType.signal,
      'initialClaimCurrency': widget.signalParams.currency,
    });
  }

  @override
  Widget build(BuildContext context) {
    var dic = I18n.of(context).assets;

    return Scaffold(
      appBar: AppBar(
        title: Text(dic['signal.tokens']),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Builder(builder: (BuildContext context) {
          return Scrollbar(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 15),
                  Text(
                    dic['signal.address'],
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  SizedBox(height: 15),
                  Text(
                    dic['signal.instruction2'],
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  SizedBox(height: 10),
                  Card(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Center(
                            child: Container(
                              height: 150,
                              width: 150,
                              child: Stack(
                                children: [
                                  QrImage(
                                    data: _showMessageInQr
                                        ? widget.signalParams.transactionMessage
                                        : widget.signalParams.contractAddress
                                            .toString(),
                                    version: QrVersions.auto,
                                    size: 150.0,
                                    foregroundColor:
                                        Theme.of(context).primaryColor,
                                    errorCorrectionLevel: 3,
                                  ),
                                  Align(
                                    child: Container(
                                      padding: EdgeInsets.only(
                                        left: 8,
                                        top: 8,
                                        bottom: 8,
                                        right: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Image.asset(
                                        'assets/images/assets/DHX.png',
                                        height: 35,
                                        width: 35,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  widget.signalParams.contractAddress
                                      .toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(
                                          fontWeight: FontWeight.w500,
                                          height: 1.5),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.content_copy),
                                color: Theme.of(context).primaryColor,
                                onPressed: () {
                                  Clipboard.setData(
                                    ClipboardData(
                                      text: widget.signalParams.contractAddress
                                          .toString(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  CheckboxListTile(
                    value: _showMessageInQr,
                    onChanged: (v) => setState(() => _showMessageInQr = v),
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(
                      dic['transaction.qr'],
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),
                  SizedBox(height: 40),
                  Text(
                    dic['your.transaction'],
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  SizedBox(height: 10),
                  TransactionMessage(
                    message: widget.signalParams.transactionMessage,
                  ),
                  SizedBox(height: 10),
                  CheckboxListTile(
                    value: _continueBox,
                    onChanged: (v) => setState(() => _continueBox = v),
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(
                      dic['check.message'],
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
      bottomNavigationBar: Container(
        color: Theme.of(context).bottomAppBarColor,
        child: Padding(
          padding:
              const EdgeInsets.only(left: 10, right: 10, bottom: 30, top: 5),
          child: Container(
            child: RoundedButton(
              text: I18n.of(context).assets['signal'],
              onPressed: _continueBox ? () => signal() : null,
            ),
          ),
        ),
      ),
    );
  }
}
