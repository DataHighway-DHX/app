import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polka_wallet/common/components/goPageBtn.dart';
import 'package:polka_wallet/common/components/linkTap.dart';
import 'package:polka_wallet/common/widgets/picker_button.dart';
import 'package:polka_wallet/common/widgets/roundedButton.dart';
import 'package:polka_wallet/page/assets/signal/instruction/instruction_page.dart';
import 'package:polka_wallet/store/app.dart';
import 'package:polka_wallet/utils/i18n/index.dart';

import 'signalDetailPage.dart';

class SignalPage extends StatefulWidget {
  SignalPage(this.store);

  static final String route = '/assets/signal';
  final AppStore store;

  @override
  _SignalPageState createState() => _SignalPageState(store);
}

class _SignalPageState extends State<SignalPage> {
  _SignalPageState(this.store);

  bool rulesAccepted = false;
  final AppStore store;

  @override
  Widget build(BuildContext context) {
    var dic = I18n.of(context).assets;

    return Scaffold(
      appBar: AppBar(
        title: Text(dic['signal.tokens']),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          padding:
              const EdgeInsets.only(top: 30, bottom: 20, right: 20, left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 15),
              Text(
                dic['signal.welcome'],
                style: Theme.of(context).textTheme.headline1,
              ),
              SizedBox(height: 10),
              Text(
                dic['signal.instruction'],
                style:
                    Theme.of(context).textTheme.bodyText2.copyWith(height: 1.4),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PickerButton(
                      title: dic['signal.signalling'],
                      subtitle: dic['signal.more'],
                      margin: EdgeInsets.zero,
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 30,
                      ),
                      leading: Container(
                        child: Image.asset('assets/images/assets/lock.png'),
                        margin: EdgeInsets.only(left: 5, right: 15),
                      ),
                      onTap: () => Navigator.pushNamed(
                          context, SignalInstructionPage.route),
                    ),
                    SizedBox(height: 20),
                    CheckboxListTile(
                      value: rulesAccepted,
                      onChanged: (v) => setState(() => rulesAccepted = v),
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(
                        dic['signal.agree'],
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
              RoundedButton(
                text: I18n.of(context).home['next'],
                onPressed: rulesAccepted
                    ? () => Navigator.pushNamed(context, SignalDetailPage.route)
                    : null,
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
