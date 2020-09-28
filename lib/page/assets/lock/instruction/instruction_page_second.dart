import 'package:flutter/material.dart';
import 'package:polka_wallet/common/widgets/roundedButton.dart';
import 'package:polka_wallet/page/assets/lock/instruction/instruction_title.dart';
import 'package:polka_wallet/utils/i18n/index.dart';

class InstructionPageSecond extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bodyText = TextStyle(
      color: Colors.white,
      fontSize: 14,
    );
    final tileText = TextStyle(
      fontWeight: FontWeight.w500,
    );
    final subtileText = TextStyle(
      color: Colors.white,
      fontSize: 12,
    );
    var dic = I18n.of(context).instructions;
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                InstructionTitle(3, dic['lock.transaction_message']),
                SizedBox(height: 5),
                Text(
                  dic['lock.duration'],
                  style: bodyText,
                ),
                SizedBox(height: 15),
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 10,
                        right: 10,
                        top: 8,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  '12',
                                  style: tileText,
                                ),
                                SizedBox(height: 15),
                                Text(
                                  dic['lock.duration_months'],
                                  textAlign: TextAlign.center,
                                  style: subtileText,
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 16,
                            color: Colors.grey.shade400,
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                dic['lock.lock'],
                                style: tileText,
                              ),
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 16,
                            color: Colors.grey.shade400,
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  '5000',
                                  style: tileText,
                                ),
                                SizedBox(height: 15),
                                Text(
                                  dic['lock.token_amount'],
                                  textAlign: TextAlign.center,
                                  style: subtileText,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 16,
                            color: Colors.grey.shade400,
                          ),
                          Expanded(
                            flex: 0,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'DHXPublicKey',
                                    style: tileText,
                                  ),
                                  SizedBox(height: 15),
                                  Text(
                                    dic['lock.auto_generated'],
                                    textAlign: TextAlign.center,
                                    style: subtileText,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                InstructionTitle(4, dic['lock.send']),
                SizedBox(height: 5),
                Text(
                  dic['lock.send_detailed'],
                  style: bodyText,
                ),
                SizedBox(height: 40),
                InstructionTitle(5, dic['lock.claim_transaction']),
                SizedBox(height: 5),
                Text(
                  dic['lock.claim_transaction_detailed'],
                  style: bodyText,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20).copyWith(bottom: 20),
          child: RoundedButton(
            text: dic['lock.understand'],
            onPressed: () => Navigator.of(context).pop(),
            color: Colors.white,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
