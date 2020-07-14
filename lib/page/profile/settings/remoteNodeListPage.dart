import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polka_wallet/service/substrateApi/api.dart';
import 'package:polka_wallet/store/settings.dart';
import 'package:polka_wallet/utils/i18n/index.dart';

const default_node_zh = {
  'info': 'datahighway-harbour-testnet',
  'text':
      'DataHighway (DataHighway Harbour Testnet, hosted by MXC Foundation gGmbH)',
  'value': 'wss://testnet-harbour.datahighway.com',
};

const default_node = {
  'info': 'datahighway-harbour-testnet',
  'text':
      'DataHighway (DataHighway Harbour Testnet, hosted by MXC Foundation gGmbH)',
  'value': 'wss://testnet-harbour.datahighway.com',
};

const nodeList = [
  default_node_zh,
  default_node,
  {
    'info': 'kusama',
    'text': 'Kusama (Polkadot Canary, hosted by Web3 Foundation)',
    'value': 'wss://cc3-5.kusama.network/',
  },
  {
    'info': 'substrate',
    'text': 'Flaming Fir (Substrate Testnet, hosted by Parity)',
    'value': 'wss://substrate-rpc.parity.io/',
  },
  {
    'info': 'substrate',
    'text': 'Kulupu (Kulupu Mainnet, hosted by Kulupu)',
    'value': 'wss://rpc.kulupu.network/ws',
  },
];

const default_ss58_map = {
  // https://github.com/paritytech/substrate/pull/5465
  'datahighway-mainnet': 49, // DataHighway Mainnet
  'datahighway-harbour-testnet': 42, // DataHighway Harbour Testnet
  'kusama': 2,
  'substrate': 42,
  'westend': 42,
  'polkadot': 0
};

class RemoteNodeListPage extends StatelessWidget {
  RemoteNodeListPage(this.store);

  static final String route = '/profile/endpoint';
  final Api api = webApi;
  final SettingsStore store;

  @override
  Widget build(BuildContext context) {
    var dic = I18n.of(context).profile;
    List<Widget> list = nodeList
        .map((i) => ListTile(
              leading: Container(
                width: 36,
                child: Image.asset('assets/images/public/${i['info']}.png'),
              ),
              title: Text(i['info']),
              subtitle: Text(i['text']),
              trailing: Icon(Icons.arrow_forward_ios, size: 18),
              onTap: () {
                if (store.endpoint.value == i['value']) {
                  Navigator.of(context).pop();
                  return;
                }
                store.setEndpoint(i);
                api.changeNode(i['value']);
                Navigator.of(context).pop();
              },
            ))
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(dic['setting.node.list']),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(padding: EdgeInsets.only(top: 8), children: list),
      ),
    );
  }
}
