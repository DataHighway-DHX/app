import 'dart:async' show Future;
import 'dart:convert';
import 'package:polka_wallet/constants.dart';
import 'package:polka_wallet/store/app.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'package:web_socket_channel/io.dart';

import '../../utils/httpLogger.dart';
import '../../constants.dart';
import 'contract.dart';
import 'deployer.dart';
import 'lockdrop.dart';
import 'model.dart';
import 'tokens/mxc_token.dart';
import 'tokens/iota_token.dart';

export 'extensions.dart';
export 'model.dart';

import 'package:http/http.dart' as http;

class EthereumApi {
  EthereumApi({this.rpcUrl, this.wsUrl});

  final String rpcUrl;
  final String wsUrl;
  Web3Client client;

  // Establish connection to the Ethereum RPC node using socketConnector
  // for event streams over websockets instead of http-polls.
  // Note that the socketConnector property is experimental.
  Future<Web3Client> connectToWeb3EthereumClient() async {
    return client = Web3Client(this.rpcUrl,
        (kEnvironment == 'testnet' ? LoggingClient(Client()) : Client()),
        socketConnector: () {
      return IOWebSocketChannel.connect(this.wsUrl, headers: {
        'Connection': 'upgrade',
        'Upgrade': 'websocket',
        'sec-websocket-version': '13'
      }).cast<String>();
    });
  }
}

Ethereum ethereum = Ethereum.fromAssets();

class Ethereum {
  factory Ethereum.fromAssets() {
    final ethereumApi = EthereumApi(
      rpcUrl: kRpcUrlInfuraTestnetRopsten,
      wsUrl: kWsUrlInfuraTestnetRopsten,
    );

    final mxcToken = MxcTokenApi(
      ContractAbiProvider.fromAsset(
        'MXCToken',
        'assets/data/$kAbiCodeFileMXC',
      ),
      kContractAddrMXCTestnet,
      ethereumApi,
    );

    final iotaPeggedToken = IotaTokenApi(
      ContractAbiProvider.fromAsset(
        'IOTAPeggedToken',
        'assets/data/$kAbiCodeFileDataHighwayIOTAPeggedTestnet',
      ),
      kContractAddrIOTAPeggedTestnet,
      ethereumApi,
    );

    return Ethereum(mxcToken, iotaPeggedToken, ethereumApi);
  }

  Ethereum(this.mxcToken, this.iotaToken, this._api);

  final store = globalAppStore;

  LockdropApi lockdrop;
  DeployerApi deployer;
  final MxcTokenApi mxcToken;
  final IotaTokenApi iotaToken;

  final EthereumApi _api;

  Future<BigInt> getBalance(EthereumAddress ethereumAddress) async {
    final amount = await _api.client.getBalance(ethereumAddress);
    return amount.getInWei;
  }

  Future<List<DeployerHostInfo>> getDeployersList() async {
    final res = await http.get(deployersListUrl);
    final List decodedList = jsonDecode(res.body);
    final typedList = decodedList
        .map((f) => DeployerHostInfo.fromMap(Map<String, dynamic>.from(f)))
        .toList();
    return typedList;
  }

  Future<void> connectDeployer([DeployerHostInfo info]) async {
    if (info == null) {
      final list = await getDeployersList();
      info = list.first;
    }
    final httpRes = await http.get('${info.url}/lockdrop/get');
    final jsonRes = jsonDecode(httpRes.body);
    final contractAddress = jsonRes['lockdropAddress'];
    lockdrop = LockdropApi(
      info,
      ContractAbiProvider.fromAsset(
        'DataHighwayLockdrop',
        'assets/data/$kAbiCodeFileDataHighwayLockdropTestnet',
      ),
      EthereumAddress.fromHex(contractAddress),
      _api,
    );
    deployer = DeployerApi(info);
  }
}
