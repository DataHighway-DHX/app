import 'package:flutter/material.dart';
import 'package:polka_wallet/common/components/addressIcon.dart';
import 'package:polka_wallet/common/consts/settings.dart';
import 'package:polka_wallet/page/account/createAccountEntryPage.dart';
import 'package:polka_wallet/service/substrateApi/api.dart';
import 'package:polka_wallet/store/account/types/accountData.dart';
import 'package:polka_wallet/store/app.dart';
import 'package:polka_wallet/store/settings.dart';
import 'package:polka_wallet/utils/UI.dart';
import 'package:polka_wallet/utils/format.dart';
import 'package:polka_wallet/utils/i18n/index.dart';

class MenuPage extends StatefulWidget {
  static const String route = '/menu';
  final AppStore store;

  MenuPage(this.store);

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  EndpointData _selectedNetwork;
  AppStore get store => widget.store;

  void _loadAccountCache() {
    // refresh balance
    store.assets.clearTxs();
    store.assets.loadAccountCache();
    store.staking.clearState();
    store.staking.loadAccountCache();
  }

  Future<void> _reloadNetwork() async {
    store.settings.setEndpoint(_selectedNetwork);

    store.settings.loadNetworkStateCache();
    store.settings.setNetworkLoading(true);

    store.gov.setReferendums([]);
    store.assets.clearTxs();
    store.assets.loadCache();
    store.staking.clearState();
    store.staking.loadCache();

    webApi.launchWebview();
  }

  Future<void> _onSelect(AccountData i) async {
    String address =
        store.account.pubKeyAddressMap[_selectedNetwork.ss58][i.pubKey];
    bool isCurrentNetwork =
        _selectedNetwork.info == store.settings.endpoint.info;
    if (address == store.account.currentAddress && isCurrentNetwork) return;

    /// set current account
    store.account.setCurrentAccount(i.pubKey);

    if (isCurrentNetwork) {
      _loadAccountCache();

      /// reload account info
      webApi.assets.fetchBalance();
    } else {
      /// set new network and reload web view
      await _reloadNetwork();
    }
    await webApi.staking.fetchAccountStaking();
    Navigator.pop(context);
  }

  Future<void> _onCreateAccount() async {
    bool isCurrentNetwork =
        _selectedNetwork.info == store.settings.endpoint.info;
    if (!isCurrentNetwork) {
      await _reloadNetwork();
    }
    Navigator.of(context).pushNamed(CreateAccountEntryPage.route);
  }

  @override
  void initState() {
    super.initState();
    _selectedNetwork = store.settings.endpoint;
  }

  void setSelectedWallet(int walletNum) {
    setState(() {
      _selectedNetwork = networks[walletNum];
    });
  }

  final List<EndpointData> networks = [
    networkEndpointDatahighway,
    networkEndpointPolkadot,
    networkEndpointKusama,
  ];

  @override
  Widget build(BuildContext context) {
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
                  onTap: () => setSelectedWallet(0),
                  selected: _selectedNetwork == networkEndpointDatahighway,
                ),
                // MenuButton(
                //   image: AssetImage(
                //       'assets/images/public/wallet_types/polkadot.png'),
                //   selectedImage: AssetImage(
                //       'assets/images/public/wallet_types/polkadot_sel.png'),
                //   onTap: () => setSelectedWallet(1),
                //   selected: _selectedNetwork == networkEndpointPolkadot,
                // ),
                // MenuButton(
                //   image: AssetImage(
                //       'assets/images/public/wallet_types/kusama.png'),
                //   selectedImage: AssetImage(
                //       'assets/images/public/wallet_types/kusama_sel.png'),
                //   onTap: () => setSelectedWallet(2),
                //   selected: _selectedNetwork == networkEndpointKusama,
                // ),
              ],
            ),
          ),
          Expanded(
            child: GenericMenuContent(
              name: _selectedNetwork.info.toUpperCase(),
              store: widget.store,
              onSelect: _onSelect,
              onCreateAccount: _onCreateAccount,
              selectedNetwork: _selectedNetwork,
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
  final VoidCallback onCreateAccount;
  final EndpointData selectedNetwork;
  final void Function(AccountData) onSelect;

  GenericMenuContent({
    this.name,
    this.store,
    @required this.onCreateAccount,
    @required this.selectedNetwork,
    @required this.onSelect,
  });

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
                  onCreateAccount();
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
                address: store.account.pubKeyAddressMap[selectedNetwork.ss58]
                    [i.pubKey],
                onTap: () async {
                  onSelect(i);
                },
              );
            },
          ),
        )
      ],
    );
  }
}

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
  final String address;
  final VoidCallback onTap;
  AccountCard(this.i, {this.onTap, @required this.address});

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
                      Fmt.address(address),
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
