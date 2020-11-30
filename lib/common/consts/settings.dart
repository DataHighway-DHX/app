import 'package:polka_wallet/store/settings.dart';

const String network_name_kusama = 'kusama';
const String network_name_polkadot = 'polkadot';
const String network_name_acala_mandala = 'acala-mandala';
const String network_name_laminar_turbulence = 'laminar-turbulence';

EndpointData networkEndpointPolkadot = EndpointData.fromJson(const {
  'info': 'polkadot',
  'ss58': 0,
  'text': 'Polkadot (Live, hosted by Parity)',
  'value': 'wss://rpc.polkadot.io',
});

EndpointData networkEndpointKusama = EndpointData.fromJson(const {
  'info': 'kusama',
  'ss58': 2,
  'text': 'Kusama (Polkadot Canary, hosted by Polkawallet)',
  'value': 'wss://kusama-1.polkawallet.io:9944/',
});

EndpointData networkEndpointAcala = EndpointData.fromJson(const {
  'info': 'acala-mandala',
  'ss58': 42,
  'text': 'Acala Mandala (Hosted by Acala Network)',
  'value': 'wss://acala-testnet-1.polkawallet.io:9904',
});

EndpointData networkEndpointDatahighway = EndpointData.fromJson(const {
  'info': 'datahighway',
  'ss58': 42,
  'text':
      'DataHighway (DataHighway Harbour Testnet, hosted by MXC Foundation gGmbH)',
  'value': 'wss://testnet-harbour.datahighway.com',
});

List<EndpointData> networkEndpoints = [
  networkEndpointPolkadot,
  EndpointData.fromJson(const {
    'color': 'pink',
    'info': network_name_polkadot,
    'ss58': 0,
    'text': 'Polkadot (Live, hosted by Web3 Foundation)',
    'value': 'wss://cc1-1.polkadot.network',
  }),
  EndpointData.fromJson(const {
    'color': 'pink',
    'info': network_name_polkadot,
    'ss58': 0,
    'text': 'Polkadot (Live, hosted by Polkawallet CN)',
    'value': 'wss://polkadot-1.polkawallet.io:9944',
  }),
  EndpointData.fromJson(const {
    'color': 'pink',
    'info': network_name_polkadot,
    'ss58': 0,
    'text': 'Polkadot (Live, hosted by Polkawallet EU)',
    'value': 'wss://polkadot-2.polkawallet.io',
  }),
  networkEndpointKusama,
  EndpointData.fromJson(const {
    'color': 'black',
    'info': network_name_kusama,
    'ss58': 2,
    'text': 'Kusama (Polkadot Canary, hosted by Polkawallet Asia)',
    'value': 'wss://kusama-2.polkawallet.io/',
  }),
  EndpointData.fromJson(const {
    'color': 'black',
    'info': network_name_kusama,
    'ss58': 2,
    'text': 'Kusama (Polkadot Canary, hosted by Parity)',
    'value': 'wss://kusama-rpc.polkadot.io/',
  }),
  EndpointData.fromJson(const {
    'color': 'black',
    'info': network_name_kusama,
    'ss58': 2,
    'text': 'Kusama (Polkadot Canary, hosted by Web3 Foundation)',
    'value': 'wss://cc3-5.kusama.network/',
  }),
  EndpointData.fromJson(const {
    'color': 'black',
    'info': network_name_kusama,
    'ss58': 2,
    'text': 'Kusama (Polkadot Canary, user-run public nodes)',
    'value': 'wss://kusama.polkadot.cloud.ava.do/',
  }),
  networkEndpointAcala,
  EndpointData.fromJson(const {
    'color': 'indigo',
    'info': network_name_acala_mandala,
    'ss58': 42,
    'text': 'Mandala TC5 Node 1 (Hosted by OnFinality)',
    'value': 'wss://node-6714447553777491968.jm.onfinality.io/ws'
  }),
  EndpointData.fromJson(const {
    'color': 'indigo',
    'info': network_name_acala_mandala,
    'ss58': 42,
    'text': 'Mandala TC5 Node 2 (Hosted by OnFinality)',
    'value': 'wss://node-6714447553211260928.rz.onfinality.io/ws',
  }),
  networkEndpointDatahighway,
];

const network_ss58_map = {
  'acala': 42,
  'kusama': 2,
  'substrate': 42,
  'polkadot': 0,
};

const int kusama_token_decimals = 12;
const int acala_token_decimals = 18;

const int SECONDS_OF_DAY = 24 * 60 * 60; // seconds of one day
const int SECONDS_OF_YEAR = 365 * 24 * 60 * 60; // seconds of one year

const String acala_stable_coin = 'AUSD';
const String acala_stable_coin_view = 'aUSD';

/// test app versions
const String app_beta_version = '0.8.3-beta.3';
