import 'dart:async' show Future;

import 'package:polka_wallet/constants.dart';
import 'package:polka_wallet/service/ethereumApi/apiAssetsIOTAPegged.dart';
import 'package:polka_wallet/service/ethereumApi/apiAssetsMXC.dart';
import 'package:polka_wallet/service/ethereumApi/apiMiningIOTAPegged.dart';
import 'package:polka_wallet/service/ethereumApi/apiMiningMXC.dart';
import 'package:polka_wallet/store/app.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'package:web_socket_channel/io.dart';

import '../../utils/httpLogger.dart';
import '../../constants.dart';

class EthereumApi {
  EthereumApi({this.rpcUrl, this.wsUrl});

  final String rpcUrl;
  final String wsUrl;
  Web3Client client;

  // Establish connection to the Ethereum RPC node using socketConnector
  // for event streams over websockets instead of http-polls.
  // Note that the socketConnector property is experimental.
  Future<Web3Client> connectToWeb3EthereumClient() async {
    return client = Web3Client(this.rpcUrl, (kEnvironment == 'testnet' ? LoggingClient(Client()) : Client()), socketConnector: () {
      return IOWebSocketChannel.connect(this.wsUrl,headers: {'Connection': 'upgrade', 'Upgrade': 'websocket','sec-websocket-version': '13'}).cast<String>();
    });
  }
}

Ethereum ethereum;

class Ethereum{
  Ethereum();
  
  final store = globalAppStore;

  EthereumApiAssetsMXC assetsMXC;
  EthereumApiAssetsIOTAPegged assetsIOTAPegged;
  EthereumApiMiningMXC ethApiMiningMXC;
  EthereumApiMiningIOTAPegged ethApiMiningIOTAPegged;

  void init() async{
    await getBalanceMXC(); 
    await fetchMXCLockedClaimsData();
    await fetchMXCSignaledClaimsData();

    await getBalanceIOTAPegged();
    // Note: Do not support locking IOTA Pegged tokens
    await fetchIOTAPeggedSignaledClaimsData();
  }

  //MXC balance
  Future<void> getBalanceMXC() async{
    assetsMXC = EthereumApiAssetsMXC();

    // print('Getting MXC account balance');
    BigInt balance = await assetsMXC.getAccountBalanceFromMXCContract(kContractAddrMXCTestnet, kMnemonicSeed);

    store.ethereum.setBalanceMXC(balance);   
  }

  //MXC locked claim data
  Future<void> fetchMXCLockedClaimsData() async {
    print('Getting data of reward claims for locking MXC');
    ethApiMiningMXC = EthereumApiMiningMXC();
    Map claimsData = await ethApiMiningMXC
        .getAccountLockedClaimsDataFromDataHighwayMXCMiningContract(
            kRpcUrlInfuraTestnetRopsten,
            kWsUrlInfuraTestnetRopsten,
            kContractAddrDataHighwayLockdropTestnet,
            kMnemonicSeed
        );

    store.ethereum.setClaimsDataMXCLocked(claimsData);
  }

  //MXC signaled claim data
  Future<void> fetchMXCSignaledClaimsData() async {
    print('Getting data of reward claims for signaling MXC');
    ethApiMiningMXC = EthereumApiMiningMXC();
    Map claimsData = await ethApiMiningMXC
        .getAccountSignaledClaimsDataFromDataHighwayMXCMiningContract(
            kRpcUrlInfuraTestnetRopsten,
            kWsUrlInfuraTestnetRopsten,
            kContractAddrDataHighwayLockdropTestnet,
            kMnemonicSeed
        );

    store.ethereum.setClaimsDataMXCSignaled(claimsData);
  }

  //IOTA Pegged balance
  Future<void> getBalanceIOTAPegged() async {
    print('Getting balance of IOTA Pegged');
    assetsIOTAPegged = EthereumApiAssetsIOTAPegged();
    EthereumApiAssetsIOTAPegged ethApiAssetsIOTAPegged =
        EthereumApiAssetsIOTAPegged();
    BigInt balance = await assetsIOTAPegged
        .getAccountBalanceFromIOTAPeggedContract(
            kContractAddrIOTAPeggedTestnet,
            kMnemonicSeed
        );

    store.ethereum.setBalanceIOTAPegged(balance);
  }

  // Note: Do not support locking IOTA Pegged tokens

  //IOTA Pegged signaled claim data
  Future<void> fetchIOTAPeggedSignaledClaimsData() async {
    print('Getting data of reward claims for signaling IOTAPegged');
    ethApiMiningIOTAPegged = EthereumApiMiningIOTAPegged();
    Map claimsData = await ethApiMiningIOTAPegged
        .getAccountSignaledClaimsDataFromDataHighwayIOTAPeggedMiningContract(
            kRpcUrlInfuraTestnetRopsten,
            kWsUrlInfuraTestnetRopsten,
            kContractAddrDataHighwayLockdropTestnet,
            kMnemonicSeed
        );

    store.ethereum.setClaimsDataIOTAPeggedSignaled(claimsData);
  }
}
