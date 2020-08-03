import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polka_wallet/common/widgets/roundedButton.dart';
import 'package:polka_wallet/utils/format.dart';
import 'package:polka_wallet/utils/i18n/index.dart';

class CreateAccountForm extends StatelessWidget {
  CreateAccountForm({
    this.setNewAccount,
    this.onSubmit,
    this.last = false,
  });

  final Function setNewAccount;
  final Function onSubmit;
  final bool last;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameCtrl = new TextEditingController();
  final TextEditingController _passCtrl = new TextEditingController();
  final TextEditingController _pass2Ctrl = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Map<String, String> dic = I18n.of(context).account;

    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
              children: <Widget>[
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.person_outline),
                    hintText: dic['create.name'],
                    labelText: dic['create.name'],
                  ),
                  controller: _nameCtrl,
                  validator: (v) {
                    return v.trim().length > 0
                        ? null
                        : dic['create.name.error'];
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.lock_outline),
                    hintText: dic['create.password'],
                    labelText: dic['create.password'],
                  ),
                  controller: _passCtrl,
                  validator: (v) {
                    return Fmt.checkPassword(v.trim())
                        ? null
                        : dic['create.password.error'];
                  },
                  obscureText: true,
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.lock_outline),
                    hintText: dic['create.password2'],
                    labelText: dic['create.password2'],
                  ),
                  controller: _pass2Ctrl,
                  obscureText: true,
                  validator: (v) {
                    return _passCtrl.text != v
                        ? dic['create.password2.error']
                        : null;
                  },
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: RoundedButton(
              text: last
                  ? I18n.of(context).home['confirm']
                  : I18n.of(context).home['next'],
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  setNewAccount(_nameCtrl.text, _passCtrl.text);
                  onSubmit();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
