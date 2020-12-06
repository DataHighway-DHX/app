import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:polka_wallet/common/widgets/roundedButton.dart';
import 'package:polka_wallet/page/assets/claim/claim_page.dart';
import 'package:polka_wallet/page/assets/signal/signal_page.dart';
import 'package:polka_wallet/service/ethereum_api/api.dart';
import 'package:polka_wallet/store/app.dart';
import 'package:polka_wallet/store/assets/types/currency.dart';
import 'package:polka_wallet/utils/i18n/index.dart';

import 'asset/assetPage.dart';
import 'lock/lock_page.dart';
import 'table_source.dart';

class AssetCard extends StatefulWidget {
  final ImageProvider image;
  final String label;
  final String subtitle;
  final double balance;
  final double usdBalance;
  final TokenCurrency currency;
  final double msb;

  final bool lock;
  final bool signal;
  final bool claim;
  final Widget expandedContent;

  const AssetCard({
    Key key,
    this.image,
    this.label,
    this.balance,
    this.subtitle,
    this.usdBalance,
    this.lock = true,
    this.signal = true,
    this.claim = true,
    this.expandedContent,
    this.msb,
    this.currency,
  }) : super(key: key);

  @override
  _AssetCardState createState() => _AssetCardState();
}

class _AssetCardState extends State<AssetCard>
    with SingleTickerProviderStateMixin {
  bool expanded = false;
  Animation<double> expandAnimation;
  AnimationController expandAnimationController;

  void initState() {
    super.initState();
    expandAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    expandAnimation =
        Tween(begin: 0.0, end: 1.0).animate(expandAnimationController);
  }

  Widget itemButton(BuildContext context, String text, String routeName,
      [Object arguments]) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: RoundedButton.dense(
          text: text,
          onPressed: () => Navigator.pushNamed(
            context,
            routeName,
            arguments: arguments,
          ),
        ),
      ),
    );
  }

  Widget itemButtonsRow(BuildContext context) {
    var dic = I18n.of(context).assets;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: EdgeInsets.only(
        top: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          if (widget.lock)
            itemButton(context, dic['lock'], LockPage.route, {
              'msb': widget.msb,
              'currency': widget.currency,
            }),
          if (widget.signal)
            itemButton(context, dic['signal'], SignalPage.route, {
              'msb': widget.msb,
              'currency': widget.currency,
            }),
          if (widget.claim) itemButton(context, dic['claim'], ClaimPage.route),
        ],
      ),
    );
  }

  void expand() {
    setState(() => expanded = true);
    expandAnimationController.forward();
  }

  void shrink() {
    setState(() => expanded = false);
    expandAnimationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, AssetPage.route,
            arguments: widget.label),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                SizedBox(
                  width: 16,
                ),
                SizedBox(
                  width: 0,
                ),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey),
                  ),
                  height: 40,
                  width: 40,
                  child: Image(
                    image: widget.image,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  widget.label,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(decoration: TextDecoration.underline),
                ),
                Spacer(),
                Text(
                  widget.balance?.toStringAsFixed(3) ?? '...',
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                        color: Color(0xFF939393),
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(
                  width: 16,
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 16,
                ),
                Text(
                  widget.subtitle,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Spacer(),
                Text(
                  '(~${widget.usdBalance.toStringAsFixed(0)} USD)',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                SizedBox(
                  width: 16,
                ),
              ],
            ),
            if (widget.signal || widget.claim || widget.lock)
              SizedBox(height: 10),
            itemButtonsRow(context),
            if (widget.expandedContent == null)
              SizedBox(
                height: 5,
              )
            else ...[
              SizedBox(
                height: 5,
              ),
              SizeTransition(
                axisAlignment: -1,
                sizeFactor: expandAnimation,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  child: widget.expandedContent,
                ),
              ),
              SizedBox(
                height: 35,
                width: double.infinity,
                child: InkWell(
                  onTap: () {
                    if (expanded)
                      shrink();
                    else
                      expand();
                  },
                  child: Container(
                    padding: EdgeInsets.only(bottom: 0),
                    child: Icon(
                      expanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 36,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

class AssetsCardContent extends StatefulWidget {
  final AppStore store;
  final TableSource tableSource;

  const AssetsCardContent({
    Key key,
    this.store,
    this.tableSource,
  }) : super(key: key);

  @override
  _AssetsCardContentState createState() => _AssetsCardContentState();
}

class _AssetsCardContentState extends State<AssetsCardContent>
    with SingleTickerProviderStateMixin {
  String selectedTab = 'claim';
  TabController tabController;
  int tabIndex = 0;

  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final dic = I18n.of(context).assets;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CupertinoSlidingSegmentedControl(
          children: {
            'claim': Text(widget.tableSource.claimTableName(context)),
            'rewards': Text(widget.tableSource.claimTableName(context)),
          },
          groupValue: selectedTab,
          onValueChanged: (key) {
            setState(() => selectedTab = key);
            setState(() => tabIndex = key == 'claim' ? 0 : 1);
            if (key == 'claim')
              tabController.animateTo(0);
            else
              tabController.animateTo(1);
          },
        ),
        SizedBox(height: 15),
        tabIndex == 0
            ? widget.tableSource.claimTable(context, widget.store)
            : widget.tableSource.rewardsTable(context, widget.store),
      ],
    );
  }
}
