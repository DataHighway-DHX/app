import 'package:flutter/material.dart';
import 'package:polka_wallet/common/components/snackbars.dart';
import 'package:polka_wallet/common/widgets/picker_dialog.dart';
import 'package:polka_wallet/common/widgets/roundedButton.dart';
import 'package:polka_wallet/service/ethereum_api/api.dart';
import 'package:polka_wallet/store/app.dart';
import 'package:polka_wallet/utils/UI.dart';
import 'package:polka_wallet/utils/format.dart';
import 'package:polka_wallet/utils/i18n/index.dart';

class ClaimCreateInfo extends StatefulWidget {
  ClaimCreateInfo({Key key, this.claimed}) : super(key: key);

  final VoidCallback claimed;
  @override
  _ClaimCreateInfoState createState() => _ClaimCreateInfoState();
}

class _ClaimCreateInfoState extends State<ClaimCreateInfo>
    with SingleTickerProviderStateMixin {
  TextEditingController _hashCtl = TextEditingController();

  bool expanded = false;
  bool isLoading = false;
  bool txPending = false;
  Claim claim;

  void _turnLoading(bool value) {
    if (mounted) setState(() => isLoading = value);
  }

  Future<void> doClaim() async {
    _turnLoading(true);
    final txHash = _hashCtl.text.trim();
    try {
      final hash = await ethereum.deployer.claim(transactionHash: txHash);

      if (!mounted) return;
      setState(() => txPending = true);
      final result = await ethereum.lockdrop.waitForTransaction(hash);
      if (result == TransactionStatus.succeed) {
        await Future.delayed(Duration(milliseconds: 500));
        claim = await ethereum.deployer.getClaim(transactionHash: txHash);

        setState(() => txPending = false);
        setState(() => expanded = true);
        if (widget.claimed != null) widget.claimed();
      } else {
        Scaffold.of(context)
            ?.showSnackBar(SnackBars.error('Transaction Failed'));
      }
    } catch (e) {
      if (e is DeployerException && e.name == 'ClaimStatusFinalizedTxLock') {
        try {
          claim = await ethereum.deployer.getClaim(transactionHash: txHash);
          setState(() => expanded = true);
          return;
        } catch (_) {}
      } else {
        UI.handleError(Scaffold.of(context), e);
      }
    } finally {
      if (mounted) setState(() => txPending = false);
      _turnLoading(false);
    }
  }

  Widget tableRow(String title, String content, {bool copyable = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Text(title),
          ),
          Expanded(
            child: Text(
              content,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          SizedBox(
            width: 35,
            child: copyable
                ? GestureDetector(
                    child: Icon(
                      Icons.content_copy,
                      size: 20,
                      color: Theme.of(context).primaryColor,
                    ),
                  )
                : null,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dic = I18n.of(context).assets;
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Center(
              child: Image.asset('assets/images/assets/claim_icon.png'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _hashCtl,
              decoration: InputDecoration(
                labelText: dic['transaction.hash'],
                hintText:
                    '0x005c6e788f3f44bcf94d3cd556770a40f4b3529218f78ab2ec31a70afd633ac1',
                floatingLabelBehavior: FloatingLabelBehavior.always,
                contentPadding: EdgeInsets.only(
                  bottom: 5,
                ),
              ),
              style: Theme.of(context).textTheme.bodyText2,
            ),
            SizedBox(height: 20),
            AnimatedSize(
              duration: Duration(milliseconds: 250),
              vsync: this,
              curve: Curves.easeInOutCubic,
              child: !expanded
                  ? Container()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        tableRow(
                            dic['from'], Fmt.address(claim.ethereumAccount),
                            copyable: true),
                        tableRow(dic['to'], Fmt.address(claim.tokenAddress),
                            copyable: true),
                        tableRow(dic['amount'],
                            '${Fmt.balance(claim.amount, 18)} ${claim.tokenName.toUpperCase()}'),
                        tableRow(dic['transaction.fee'], 'TBD'),
                        tableRow(dic['expected.msb'], 'TBD'),
                        SizedBox(height: 25),
                        Text(
                          'Your Claim',
                          style: Theme.of(context).textTheme.headline1,
                        ),
                        SizedBox(height: 10),
                        Text(dic['transaction.success'])
                      ],
                    ),
            ),
            if (!expanded)
              RoundedButton.dense(
                text: txPending ? dic['transaction.pending'] : dic['claim'],
                onPressed: isLoading ? null : () => doClaim(),
                width: 150,
                height: 28,
              )
            else
              GestureDetector(
                onTap: () => setState(() => expanded = false),
                child: SizedBox(
                  height: 24,
                  width: 40,
                  child: Icon(
                    Icons.keyboard_arrow_up,
                    size: 36,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
