import 'package:flutter/material.dart';
import 'package:polka_wallet/common/components/general_instruction_page.dart';

import 'instruction_page_first.dart';
import 'instruction_page_second.dart';
import 'instruction_page_third.dart';

class SignalInstructionPage extends StatelessWidget {
  static final String route = '/assets/signal/instruction';
  @override
  Widget build(BuildContext context) {
    return GeneralInstructionPage(children: [
      InstructionPageFirst(),
      InstructionPageSecond(),
      InstructionPageThird(),
    ]);
  }
}
