import 'package:decimal/decimal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polka_wallet/common/components/snackbars.dart';
import 'package:polka_wallet/common/widgets/picker_card.dart';
import 'package:polka_wallet/common/widgets/roundedButton.dart';
import 'package:polka_wallet/page/assets/lock/lock_params.dart';
import 'package:polka_wallet/page/assets/lock/lock_result_page.dart';
import 'package:polka_wallet/common/components/transaction_message.dart';
import 'package:polka_wallet/service/ethereum_api/api.dart';
import 'package:polka_wallet/service/ethereum_api/model.dart';
import 'package:polka_wallet/store/app.dart';
import 'package:polka_wallet/utils/i18n/index.dart';
import 'package:polka_wallet/store/assets/types/currency.dart';
import 'package:web3dart/web3dart.dart';

class LockDetailPage extends StatefulWidget {
  LockDetailPage(this.store, this.params);

  static final String route = '/assets/lock/detail';
  final AppStore store;
  final LockParams params;

  @override
  _DetailPageState createState() => _DetailPageState(store);
}

class _DetailPageState extends State<LockDetailPage> {
  _DetailPageState(this.store);

  final AppStore store;

  TextEditingController _amountCtl = TextEditingController(text: '0');

  LockParams get params => widget.params;

  Decimal mxcBalance;
  Decimal iotaBalance;
  bool isLoading = false;
  bool txPending = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    initStateAsync();
  }

  Future<void> initStateAsync() async {
    final mxcBalance = await ethereum.mxcToken.balanceOf(params.currentAddress);
    final iotaBalance =
        await ethereum.iotaToken.balanceOf(params.currentAddress);
    if (mounted) {
      setState(() {
        this.mxcBalance = mxcBalance.toDecimal();
        this.iotaBalance = iotaBalance.toDecimal();
      });
    }
  }

  void _turnLoading(bool value) {
    if (mounted) setState(() => isLoading = value);
  }

  Future<void> next() async {
    _turnLoading(true);
    try {
      final hash = await ethereum.deployer.lock(
        amount: params.parsedAmount,
        sender: EthereumAddress.fromHex(ethereum.lockdrop.host.ethereumAddress),
        useValidator: params.isValidator,
        term: params.term,
        dhxPublicKey: store.account.currentAccountPubKey,
        token: params.currency,
      );

      if (!mounted) return;
      setState(() => txPending = true);
      final result = await ethereum.lockdrop.waitForTransaction(hash);
      if (result == TransactionStatus.succeed) {
        setState(() => txPending = false);
        Navigator.pushNamed(
          context,
          LockResultPage.route,
          arguments: params,
        );
      } else {
        scaffoldKey.currentState
            ?.showSnackBar(SnackBars.error('Transaction Failed'));
        if (mounted) setState(() => txPending = false);
      }
    } catch (e) {
      scaffoldKey.currentState?.showSnackBar(SnackBars.error(e.toString()));
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
                      label: dic['lock.duration'],
                      values: [3, 6, 9, 12, 24, 36],
                      stringifier: (i) => '$i ${dic['lock.months']}',
                      onValueSelected: (s, v) =>
                          setState(() => params.term = LockdropTerm.values[v]),
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      usePickerDialog: true,
                    ),
                    PickerCard<bool>(
                      label: dic['genesis.validator'],
                      values: [false, true],
                      stringifier: (i) =>
                          i ? dic['genesis.true'] : dic['genesis.false'],
                      onValueSelected: (s, v) =>
                          setState(() => params.isValidator = s),
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
                        errorText:
                            !params.amountValid ? dic['amount.error'] : null,
                        labelText: dic['amount.balance'].replaceAll(
                          '{0}',
                          () {
                            if (params.currency == TokenCurrency.iota)
                              return '${iotaBalance ?? '...'} IOTA';
                            if (params.currency == TokenCurrency.mxc)
                              return '${mxcBalance ?? '...'} MXC';
                            throw Exception(
                                'Unknown currency ${params.currency}');
                          }(),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Text(
                        'MSB: ${params.msb}',
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
                  text: txPending
                      ? dic['transaction.pending']
                      : I18n.of(context).home['next'],
                  onPressed:
                      params.amountValid && !isLoading ? () => next() : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
