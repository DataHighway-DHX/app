import 'package:flutter/material.dart';
import 'package:polka_wallet/utils/i18n/index.dart';

class LinearData {
  final int a;
  final double b;

  LinearData(this.a, this.b);
}

class InstructionPageFirst extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bodyText = TextStyle(
      color: Colors.white,
      fontSize: 14,
    );
    var dic = I18n.of(context).instructions;
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          SizedBox(height: 20),
          Text(
            dic['signal.description'],
            style: bodyText.copyWith(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 16),
          Text(
            dic['signal.tokens'],
            style: bodyText,
          ),
          SizedBox(height: 16),
          Text(
            dic['signal.wallets'],
            style: bodyText,
          ),
          SizedBox(height: 40),
          Image.asset('assets/images/assets/signal_instr.png'),
          SizedBox(height: 16),
          Text(
            dic['signal.iota_warning'],
            style: bodyText,
          ),
        ],
      ),
    );
  }
}
