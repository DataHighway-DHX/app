import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polka_wallet/common/components/BorderedTitle.dart';
import 'package:polka_wallet/common/widgets/picker_dialog.dart';
import 'package:polka_wallet/common/widgets/roundedButton.dart';
import 'package:polka_wallet/store/app.dart';
import 'package:polka_wallet/utils/i18n/index.dart';

import 'claim_create_info.dart';
import 'claim_tile.dart';

class ClaimPage extends StatefulWidget {
  ClaimPage(this.store);

  static final String route = '/assets/claim';
  final AppStore store;

  @override
  _ClaimPageState createState() => _ClaimPageState(store);
}

class _ClaimPageState extends State<ClaimPage> {
  _ClaimPageState(this.store);

  final AppStore store;

  String selectedFilter;
  List<String> filters = ['Signal', 'Lock'];

  @override
  void initState() {
    selectedFilter = filters[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var dic = I18n.of(context).assets;
    bool isEnglish = store.settings.localeCode.contains('en');

    return Scaffold(
      appBar: AppBar(
        title: Text(dic['claim.transaction']),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Builder(
          builder: (BuildContext context) {
            return ListView(
              padding: const EdgeInsets.all(20),
              children: <Widget>[
                ClaimCreateInfo(),
                SizedBox(height: 25),
                Row(
                  children: [
                    BorderedTitle(
                      title: dic['claim.history'],
                    ),
                    Spacer(),
                    Text(
                      dic['sort.by'],
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    SizedBox(width: 10),
                    RoundedButton.custom(
                      child: Text(
                        selectedFilter,
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      ),
                      padding: EdgeInsets.zero,
                      height: 22,
                      width: 80,
                      color: Color(0xFFDAE0FB),
                      onPressed: () async {
                        final val = await PickerDialog.show(
                          context,
                          PickerDialog<String>(
                            values: filters,
                            selectedValue: selectedFilter,
                          ),
                        );
                        if (val != null) setState(() => selectedFilter = val);
                      },
                    )
                  ],
                ),
                SizedBox(height: 25),
                SizedBox(
                  height: 35,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: dic['transaction.filter'],
                      hintStyle: TextStyle(fontSize: 13),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFF1F2F2),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFF1F2F2),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                SizedBox(height: 16),
                for (var i = 0; i < 10; i++) ClaimTile(),
              ],
            );
          },
        ),
      ),
    );
  }
}
