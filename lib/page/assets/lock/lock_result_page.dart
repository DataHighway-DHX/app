import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:polka_wallet/common/components/gasInput.dart';
import 'package:polka_wallet/common/components/snackbars.dart';
import 'package:polka_wallet/common/widgets/roundedButton.dart';
import 'package:polka_wallet/service/ethereumApi/api.dart';
import 'package:polka_wallet/service/ethereumApi/model.dart';
import 'package:polka_wallet/store/app.dart';
import 'package:polka_wallet/utils/i18n/index.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../constants.dart';
import '../../../common/components/transaction_message.dart';
import 'lock_params.dart';
import 'dart:convert' show utf8;

class LockResultPage extends StatefulWidget {
  LockResultPage(this.store, this.lockParams);

  static final String route = '/assets/lock/result';
  final AppStore store;
  final LockParams lockParams;

  @override
  _ResultPageState createState() => _ResultPageState(store);
}

class _ResultPageState extends State<LockResultPage> {
  _ResultPageState(this.store);

  final AppStore store;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  bool _showMessageInQr = false;
  bool _continueBox = false;

  bool _isLoading = false;

  int gasLimit = int.parse(kGasLimitRecommended);
  int gasPrice = int.parse(kGasPriceRecommended);

  void _turnLoading(bool value) {
    if (mounted) setState(() => _isLoading = value);
  }

  Future<void> _lock() async {
    _turnLoading(true);
    try {
      final hash = await ethereum.lockdrop.lock(
        amount: widget.lockParams.parsedAmount,
        contractOwnerAddress: contractOwnerLockdrop,
        isValidator: widget.lockParams.isValidator,
        term: widget.lockParams.term,
        dhxPublicKey: utf8.encode(dataHighwayPublicKey),
        tokenContractAddress: widget.lockParams.currency.address,
        privateKey: ethPrivateKey,
        gasPrice: gasPrice,
        maxGas: gasLimit,
      );

      final result = await ethereum.lockdrop.waitForTransaction(hash);
      print('$_lock ($hash): $result');
      if (result == TransactionStatus.succeed) {
        Navigator.of(context).push(null);
      } else {
        scaffoldKey.currentState
            .showSnackBar(SnackBars.error('transaction failed'));
      }
    } catch (e) {
      scaffoldKey.currentState.showSnackBar(SnackBars.error(e.toString()));
    } finally {
      _turnLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    var dic = I18n.of(context).assets;

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(dic['lock.tokens']),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 15),
                  Text(
                    dic['lock.address'],
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  SizedBox(height: 15),
                  Text(
                    dic['send.token'],
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
                                        ? widget.lockParams.transactionMessage
                                        : widget.lockParams.contractAddress
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
                                  widget.lockParams.contractAddress.toString(),
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
                                      text: widget.lockParams.contractAddress
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
                    message: widget.lockParams.transactionMessage,
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
                  SizedBox(height: 20),
                  GasInput(
                    title: dic['gas.limit'],
                    defaultValue: kGasLimitRecommended,
                    subtitle: dic['units'],
                    onValue: (s) => gasLimit = s,
                  ),
                  SizedBox(height: 10),
                  GasInput(
                    title: dic['gas.price'],
                    defaultValue: kGasPriceRecommended,
                    subtitle: dic['gwei'],
                    onValue: (s) => gasPrice = s,
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: Theme.of(context).bottomAppBarColor,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 10, right: 10, bottom: 30, top: 5),
              child: Container(
                child: RoundedButton(
                  text: I18n.of(context).assets['lock'],
                  onPressed: _continueBox &&
                          gasPrice != null &&
                          gasLimit != null &&
                          !_isLoading
                      ? () => _lock()
                      : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
