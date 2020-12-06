import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polka_wallet/common/widgets/picker_card.dart';
import 'package:polka_wallet/common/widgets/roundedButton.dart';
import 'package:polka_wallet/common/components/transaction_message.dart';
import 'package:polka_wallet/service/ethereum_api/model.dart';
import 'package:polka_wallet/store/app.dart';
import 'package:polka_wallet/store/assets/types/currency.dart';
import 'package:polka_wallet/utils/i18n/index.dart';
import 'signal_result_page.dart';

import 'signal_params.dart';

class SignalDetailPage extends StatefulWidget {
  SignalDetailPage(this.store);

  static final String route = '/assets/signal/detail';
  final AppStore store;

  @override
  _DetailPageState createState() => _DetailPageState(store);
}

class _DetailPageState extends State<SignalDetailPage> {
  _DetailPageState(this.store);

  final AppStore store;

  TextEditingController _amountCtl = TextEditingController(text: '0');
  SignalParams params = SignalParams();

  @override
  Widget build(BuildContext context) {
    var dic = I18n.of(context).assets;

    return Scaffold(
      appBar: AppBar(
        title: Text(dic['signal.tokens']),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Scrollbar(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        dic['transaction.instruction'],
                      ),
                    ),
                    PickerCard<TokenCurrency>(
                      label: dic['token.currency'],
                      values: TokenCurrency.values,
                      onValueSelected: (s, v) =>
                          setState(() => params.currency = s),
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      usePickerDialog: true,
                    ),
                    PickerCard<int>(
                      label: dic['signal.duration'],
                      values: [3, 6, 9, 12, 24, 36],
                      stringifier: (i) => '$i ${dic['lock.months']}',
                      onValueSelected: (s, v) =>
                          setState(() => params.term = LockdropTerm.values[v]),
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      usePickerDialog: true,
                    ),
                    SizedBox(height: 15),
                    TextField(
                      controller: _amountCtl,
                      onChanged: (s) => setState(() => params.amount = s),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(top: 0),
                        hintText: dic['amount'],
                        errorText: params.parsedAmount == null
                            ? dic['amount.error']
                            : null,
                        labelText: dic['amount.balance'].replaceAll(
                          '{0}',
                          (store.assets.balances['DHX']?.transferable ??
                                  BigInt.zero)
                              .toString(),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Text(
                        'MSB: ?',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 25),
                    Text(
                      dic['your.transaction'],
                      style: Theme.of(context).textTheme.headline1,
                    ),
                    SizedBox(height: 10),
                    TransactionMessage(
                      message: params.transactionMessage,
                    ),
                    SizedBox(height: 20),
                    Text(
                      dic['transaction.double_check'],
                      style: Theme.of(context).textTheme.bodyText1,
                    )
                  ],
                ),
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
                  text: I18n.of(context).home['next'],
                  onPressed: params.parsedAmount != null
                      ? () => Navigator.pushNamed(
                          context, SignalResultPage.route,
                          arguments: params)
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
