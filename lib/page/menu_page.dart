import 'package:flutter/material.dart';
import 'package:polka_wallet/common/components/addressIcon.dart';
import 'package:polka_wallet/page/account/createAccountEntryPage.dart';
import 'package:polka_wallet/service/substrateApi/api.dart';
import 'package:polka_wallet/store/account/types/accountData.dart';
import 'package:polka_wallet/store/app.dart';
import 'package:polka_wallet/utils/UI.dart';
import 'package:polka_wallet/utils/format.dart';
import 'package:polka_wallet/utils/i18n/index.dart';

class MenuButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool selected;
  final ImageProvider image;
  final ImageProvider selectedImage;

  MenuButton({this.image, this.selectedImage, this.onTap, this.selected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 15,
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(10),
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: Image(
            image: selected && selectedImage != null ? selectedImage : image,
            color: !selected && selectedImage == null ? Colors.grey : null,
          ),
        ),
      ),
    );
  }
}

class AccountCard extends StatelessWidget {
  final AccountData i;
  final VoidCallback onTap;
  AccountCard(this.i, {this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 10,
      ),
      child: Card(
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: <Widget>[
                AddressIcon(i.address, pubKey: i.pubKey, size: 36),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      i.name,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    Spacer(),
                    Text(
                      Fmt.address(i.address),
                      style: Theme.of(context).textTheme.bodyText2,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MenuPage extends StatefulWidget {
  static const String route = '/menu';
  final AppStore store;

  MenuPage(this.store);

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  var selectedWallet = 0;

  @override
  Widget build(BuildContext context) {
    String currentMenuName;
    switch (selectedWallet) {
      case 0:
        currentMenuName = 'DATAHIGHWAY';
        break;
      case 1:
        currentMenuName = 'POLKADOT';
        break;
      case 2:
        currentMenuName = 'KUSAMA';
        break;
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(I18n.of(context).home['wallet.select']),
      ),
      body: Row(
        children: <Widget>[
          Container(
            width: 90,
            color: Theme.of(context).primaryColor,
            child: ListView(
              children: [
                MenuButton(
                  image: AssetImage(
                      'assets/images/public/wallet_types/datahighway.png'),
                  selectedImage: AssetImage(
                      'assets/images/public/wallet_types/datahighway_sel.png'),
                  onTap: () => setState(() => selectedWallet = 0),
                  selected: selectedWallet == 0,
                ),
                MenuButton(
                  image: AssetImage(
                      'assets/images/public/wallet_types/polkadot.png'),
                  selectedImage: AssetImage(
                      'assets/images/public/wallet_types/polkadot_sel.png'),
                  onTap: () => setState(() => selectedWallet = 1),
                  selected: selectedWallet == 1,
                ),
                MenuButton(
                  image: AssetImage(
                      'assets/images/public/wallet_types/kusama.png'),
                  selectedImage: AssetImage(
                      'assets/images/public/wallet_types/kusama_sel.png'),
                  onTap: () => setState(() => selectedWallet = 2),
                  selected: selectedWallet == 2,
                ),
              ],
            ),
          ),
          Expanded(
            child: GenericMenuContent(
              name: currentMenuName,
              store: widget.store,
            ),
          )
        ],
      ),
    );
  }
}

class GenericMenuContent extends StatelessWidget {
  final String name;
  final AppStore store;
  GenericMenuContent({this.name, this.store});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.only(left: 15),
          child: Row(
            children: <Widget>[
              Text(
                name,
                style: Theme.of(context).textTheme.subtitle1,
              ),
              Spacer(),
              IconButton(
                icon: Icon(
                  Icons.add_circle_outline,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, CreateAccountEntryPage.route);
                },
              )
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: store.account.optionalAccounts.length + 1,
            itemBuilder: (ctx, index) {
              AccountData i;
              if (index == 0)
                i = store.account.currentAccount;
              else
                i = store.account.optionalAccounts[index - 1];
              return AccountCard(
                i,
                onTap: () {
                  if (index == 0) return;
                  Navigator.pop(context);
                  store.account.setCurrentAccount(i.pubKey);
                  // refresh balance
                  store.assets.loadAccountCache();
                  globalBalanceRefreshKey.currentState.show();
                  // refresh user's staking info
                  store.staking.loadAccountCache();
                  webApi.staking.fetchAccountStaking();
                },
              );
            },
          ),
        )
      ],
    );
  }
}
