import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:polka_wallet/common/consts/settings.dart';
import 'package:polka_wallet/common/logging.dart';
import 'package:polka_wallet/service/ethereum_api/api.dart';
import 'package:polka_wallet/service/subscan.dart';
import 'package:polka_wallet/service/substrateApi/apiAccount.dart';
import 'package:polka_wallet/service/substrateApi/apiAssets.dart';
import 'package:polka_wallet/service/substrateApi/apiGov.dart';
import 'package:polka_wallet/service/substrateApi/apiStaking.dart';
import 'package:polka_wallet/service/substrateApi/js_connector.dart';
import 'package:polka_wallet/service/substrateApi/types/genExternalLinksParams.dart';
import 'package:polka_wallet/service/substrateApi/webview_manager.dart';
import 'package:polka_wallet/store/app.dart';
import 'package:polka_wallet/store/settings.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'api_datahighway.dart';

// global api instance
Api webApi;

class Api {
  Api(this.store);
  final AppStore store;

  ApiAccount account;

  ApiAssets assets;
  ApiStaking staking;
  ApiGovernance gov;
  ApiDatahighway datahighway;

  SubScanApi subScanApi = SubScanApi();

  JsConnector connector;
  Map<int, EvalInfo> get debugCompleters => connector?.debugCompleters;

  WebviewManager _webManager = WebviewManager();

  Future<void> init() async {
    account = ApiAccount(this);

    assets = ApiAssets(this);
    staking = ApiStaking(this);
    gov = ApiGovernance(this);
    gov = ApiGovernance(this);
    datahighway = ApiDatahighway(this);

    await launchWebview();
  }

  void onWebviewLoaded() async {
    String network = 'kusama';
    if (store.settings.endpoint.info.contains('acala')) {
      network = 'acala';
    }
    if (store.settings.endpoint.info.contains('datahighway')) {
      network = 'datahighway';
    }
    print('webview loaded for network $network');

    final data = await rootBundle.load('lib/js_service_$network/dist/main.js');
    final js = utf8.decode(data.buffer.asUint8List());

    print('js file loaded');
    log('substrate-api',
        'base load, starting for ${store.settings.endpoint.info}');
    log('substrate-api', 'base load, eval js');
    await connector.eval(js, direct: true);
    log('substrate-api', 'base load, init accounts');
    await account.initAccounts();
    log('substrate-api', 'base load, connect');
    await connectNodeAll();
    log('substrate-api', 'base load, finish');
  }

  Future<void> launchWebview() async {
    if (_webManager.launched) {
      await _webManager.reload();
    }
    _webManager.onLoaded = onWebviewLoaded;
    await _webManager.launch();
    connector = _webManager.connector;
    connector.defineHandler(
        'txStatusChange', (v) => store.account.setTxStatus(v));
  }

  Future<void> connectNode() async {
    String node = store.settings.endpoint.value;
    // do connect
    String res = await connector.eval('settings.connect("$node")');
    if (res == null) {
      print('connect failed');
      store.settings.setNetworkName(null);
      return;
    }
    if (res.contains('datahighway')) {
      await _setupDatahighway();
    }
    await fetchNetworkProps();
  }

  Future<void> connectNodeAll() async {
    List<String> nodes =
        store.settings.endpointList.map((e) => e.value).toList();
    // do connect
    String res =
        await connector.eval('settings.connectAll(${jsonEncode(nodes)})');
    if (res == null) {
      print('connect failed');
      store.settings.setNetworkName(null);
      return;
    }
    if (res.contains('datahighway')) {
      await _setupDatahighway();
    }
    EndpointData connected =
        store.settings.endpointList.firstWhere((i) => i.value == res);
    store.settings.setEndpoint(connected);
    await fetchNetworkProps();
  }

  Future<void> _setupDatahighway() async {
    await ethereum.connectDeployer(DeployerHostInfo(
      ip: '192.168.43.88',
      hostname: '192.168.43.88:8080',
      scheme: 'http',
      city: 'Home',
      ethereumAddress: '0x0066B0267Bf7003F5Bc20d8b938005d3E0aeae21',
    ));
  }

  Future<void> fetchNetworkProps() async {
    // fetch network info
    List<dynamic> info = await Future.wait([
      connector.eval('settings.getNetworkConst()'),
      connector.eval('api.rpc.system.properties()'),
      connector.eval('api.rpc.system.chain()'),
    ]);
    print('trio done');
    store.settings.setNetworkConst(info[0]);
    store.settings.setNetworkState(info[1]);
    store.settings.setNetworkName(info[2]);

    // fetch account balance
    if (store.account.accountListAll.length > 0) {
      if (store.settings.endpoint.info == networkEndpointAcala.info) {
        await assets.fetchBalance();
        return;
      }

      await Future.wait([
        assets.fetchBalance(),
        staking.fetchAccountStaking(),
        account.fetchAccountsBonded(
            store.account.accountList.map((i) => i.pubKey).toList()),
      ]);
    }

    // fetch staking overview data as initializing
    staking.fetchStakingOverview();
  }

  Future<void> updateBlocks(List txs) async {
    Map<int, bool> blocksNeedUpdate = Map<int, bool>();
    txs.forEach((i) {
      int block = i['attributes']['block_id'];
      if (store.assets.blockMap[block] == null) {
        blocksNeedUpdate[block] = true;
      }
    });
    String blocks = blocksNeedUpdate.keys.join(',');
    var data = await connector.eval('account.getBlockTime([$blocks])');

    store.assets.setBlockMap(data);
  }

  Future<void> subscribeMessage(
    String section,
    String method,
    List params,
    String channel,
    Function callback,
  ) async {
    connector.defineHandler(channel, callback);
    await connector.eval(
        'settings.subscribeMessage("$section", "$method", ${jsonEncode(params)}, "$channel")');
  }

  Future<void> unsubscribeMessage(String channel) async {
    await connector.eval('unsub$channel()', direct: true);
  }

  Future<List> getExternalLinks(GenExternalLinksParams params) async {
    final List res = await connector.eval(
      'settings.genLinks(${jsonEncode(GenExternalLinksParams.toJson(params))})',
      allowRepeat: true,
    );
    return res;
  }
}
