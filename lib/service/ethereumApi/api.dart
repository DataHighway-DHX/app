import 'dart:async' show Future;

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:polka_wallet/constants.dart';
import 'package:polka_wallet/service/ethereumApi/apiAssetsIOTAPegged.dart';
import 'package:polka_wallet/service/ethereumApi/apiAssetsMXC.dart';
import 'package:polka_wallet/service/ethereumApi/lockdrop.dart';
import 'package:polka_wallet/service/ethereumApi/apiMiningMXC.dart';
import 'package:polka_wallet/service/ethereumApi/mxc_token.dart';
import 'package:polka_wallet/store/app.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'package:web_socket_channel/io.dart';

import '../../utils/httpLogger.dart';
import '../../constants.dart';
import 'contract.dart';

export 'extensions.dart';

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

Ethereum ethereum;

class Ethereum {
  factory Ethereum.fromAssets() {
    final ethereumApi = EthereumApi(
      rpcUrl: kRpcUrlInfuraTestnetRopsten,
      wsUrl: kWsUrlInfuraTestnetRopsten,
    );

    final lockdrop = LockdropApi(
      ContractAbiProvider.fromAsset(
        'DataHighwayLockdrop',
        'assets/data/$kAbiCodeFileDataHighwayLockdropTestnet',
      ),
      kContractAddrDataHighwayLockdropTestnet,
      ethereumApi,
    );

    final mxcToken = MxcTokenApi(
      ContractAbiProvider.fromAsset(
        'MXCToken',
        'assets/data/$kAbiCodeFileMXC',
      ),
      kContractAddrMXCTestnet,
      ethereumApi,
    );

    return Ethereum(lockdrop, mxcToken);
  }

  Ethereum(this.lockdrop, this.mxcToken);

  final store = globalAppStore;

  EthereumApiAssetsMXC assetsMXC;
  EthereumApiAssetsIOTAPegged assetsIOTAPegged;
  EthereumApiMiningMXC ethApiMiningMXC;
  final LockdropApi lockdrop;
  final MxcTokenApi mxcToken;

  Future<void> init() async {
    await fetchMXCLockedClaimsData();
    await fetchMXCSignaledClaimsData();
    // TODO - temporarily disabled IOTA Pegged
    // await getBalanceIOTAPegged();
    // Note: Do not support locking IOTA Pegged tokens
    // await fetchIOTAPeggedSignaledClaimsData();
  }

  //MXC balance
  Future<BigInt> getBalanceMXC() async {
    assetsMXC = EthereumApiAssetsMXC();

    // print('Getting MXC account balance');
    BigInt balance = await assetsMXC.getAccountBalanceFromMXCContract(
        kContractAddrMXCTestnet, kMnemonicSeed);

    store.ethereum.setBalanceMXC(balance);
    return balance;
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
            kMnemonicSeed);

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
            kMnemonicSeed);

    store.ethereum.setClaimsDataMXCSignaled(claimsData);
  }

  //IOTA Pegged balance
  Future<BigInt> getBalanceIOTAPegged() async {
    print('Getting balance of IOTA Pegged');
    assetsIOTAPegged = EthereumApiAssetsIOTAPegged();
    EthereumApiAssetsIOTAPegged ethApiAssetsIOTAPegged =
        EthereumApiAssetsIOTAPegged();
    BigInt balance =
        await assetsIOTAPegged.getAccountBalanceFromIOTAPeggedContract(
            kContractAddrIOTAPeggedTestnet, kMnemonicSeed);

    store.ethereum.setBalanceIOTAPegged(balance);
    return balance;
  }

  // Note: Do not support locking IOTA Pegged tokens

  //IOTA Pegged signaled claim data
  Future<void> fetchIOTAPeggedSignaledClaimsData() async {
    print('Getting data of reward claims for signaling IOTAPegged');

    Map claimsData = await lockdrop.getSignaledClaimsIota(
      kRpcUrlInfuraTestnetRopsten,
      kWsUrlInfuraTestnetRopsten,
      kContractAddrDataHighwayLockdropTestnet,
      kMnemonicSeed,
    );

    store.ethereum.setClaimsDataIOTAPeggedSignaled(claimsData);
  }
}
