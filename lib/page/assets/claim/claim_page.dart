import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polka_wallet/common/components/BorderedTitle.dart';
import 'package:polka_wallet/common/widgets/picker_dialog.dart';
import 'package:polka_wallet/common/widgets/roundedButton.dart';
import 'package:polka_wallet/service/ethereum_api/api.dart';
import 'package:polka_wallet/store/app.dart';
import 'package:polka_wallet/store/assets/types/currency.dart';
import 'package:polka_wallet/utils/UI.dart';
import 'package:polka_wallet/utils/i18n/index.dart';

import 'claim_create_info.dart';
import 'claim_tile.dart';

class ClaimPage extends StatefulWidget {
  ClaimPage(
    this.store, {
    this.showHistory = true,
    this.initialClaimType,
    this.initialClaimCurrency,
  });

  static final String route = '/assets/claim';
  final AppStore store;
  final bool showHistory;
  final ClaimType initialClaimType;
  final TokenCurrency initialClaimCurrency;

  @override
  _ClaimPageState createState() => _ClaimPageState(store);
}

class _ClaimPageState extends State<ClaimPage> {
  _ClaimPageState(this.store);

  final AppStore store;

  int selectedFilter = 0;
  List<String> filters = ['Lock', 'Signal'];
  List<Claim> claims = [];
  bool isLoading = false;
  String txMessageFilter = '';

  @override
  void initState() {
    super.initState();
    loadClaims();
  }

  void _turnLoading(bool value) {
    if (mounted) setState(() => isLoading = value);
  }

  Future<void> loadClaims() async {
    if (!widget.showHistory) return;
    try {
      _turnLoading(true);
      claims = await ethereum.deployer.getAllClaims(
          dhxPublicKey: widget.store.account.currentAccountPubKey);
    } catch (e) {
      UI.handleError(Scaffold.of(context), e);
    } finally {
      _turnLoading(false);
    }
  }

  void claimed() {
    loadClaims();
  }

  @override
  Widget build(BuildContext context) {
    var dic = I18n.of(context).assets;
    final claims = this
        .claims
        .where((c) => c.transactionMessage.contains(txMessageFilter))
        .where((c) =>
            c.type == (selectedFilter == 0 ? ClaimType.lock : ClaimType.signal))
        .toList();

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
                ClaimCreateInfo(
                  claimed: claimed,
                  initialClaimType: widget.initialClaimType,
                  initialClaimCurrency: widget.initialClaimCurrency,
                ),
                SizedBox(height: 25),
                if (widget.showHistory) ...[
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
                          filters[selectedFilter],
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
                              selectedValue: filters[selectedFilter],
                            ),
                          );
                          if (val != null)
                            setState(
                                () => selectedFilter = filters.indexOf(val));
                        },
                      )
                    ],
                  ),
                  SizedBox(height: 25),
                  SizedBox(
                    height: 35,
                    child: TextField(
                      onChanged: (v) => setState(
                        () => txMessageFilter = v,
                      ),
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
                  for (var i = 0; i < claims.length; i++)
                    ClaimTile(
                      claim: claims[i],
                    ),
                ]
              ],
            );
          },
        ),
      ),
    );
  }
}
