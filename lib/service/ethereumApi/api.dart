import 'dart:async' show Future;

import 'package:polka_wallet/constants.dart';
import 'package:polka_wallet/service/ethereumApi/apiAssetsMXC.dart';
import 'package:polka_wallet/service/ethereumApi/apiMiningMXC.dart';
import 'package:polka_wallet/store/app.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'package:web_socket_channel/io.dart';

class EthereumApi {
  EthereumApi({this.rpcUrl, this.wsUrl});

  final String rpcUrl;
  final String wsUrl;
  Web3Client client;

  // Establish connection to the Ethereum RPC node using socketConnector
  // for event streams over websockets instead of http-polls.
  // Note that the socketConnector property is experimental.
  Future<Web3Client> connectToWeb3EthereumClient() async {
    return client = Web3Client(this.rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(this.wsUrl,headers: {'Connection': 'upgrade', 'Upgrade': 'websocket','sec-websocket-version': '13'}).cast<String>();
    });
  }
}

Ethereum ethereum;

class Ethereum{
  Ethereum();
  
  final store = globalAppStore;

  EthereumApiAssetsMXC assetsMXC;
  EthereumApiMiningMXC ethApiMiningMXC;

  void init() async{
    await getBalanceFormMXC(); 
    await fetchMXCLockedClaimsApproved();
    // await fetchMXCLockedClaimsPending();
  }

  Future<void> getBalanceFormMXC() async{
    assetsMXC = EthereumApiAssetsMXC();

    // print('Getting MXC account balance');
    BigInt balance = await assetsMXC.getAccountBalanceFromMXCContract(kContractAddrMXCMainnet, kSamplePrivateKey);

    store.ethereum.setBalanceMXC(balance);   
  }

  Future<void> fetchMXCLockedClaimsPending() async {
    print('Getting amount of pending reward claims for locking MXC');
    ethApiMiningMXC = await EthereumApiMiningMXC();
    BigInt claimsPending = await ethApiMiningMXC
        .getAccountLockedClaimsPendingOfMXCAmountFromDataHighwayMXCMiningContract(
            kContractAddrMXCMainnet,
            kSamplePrivateKey);

    store.ethereum.setClaimsPendingMXCLocked(claimsPending);
  }

  Future<void> fetchMXCLockedClaimsApproved() async {
    print('Getting amount of approved reward claims for locking MXC');
    EthereumApiMiningMXC ethApiMiningMXC = await EthereumApiMiningMXC();
    BigInt claimsApproved = await ethApiMiningMXC
        .getAccountLockedClaimsApprovedOfMXCAmountFromDataHighwayMXCMiningContract(
            kContractAddrMXCMainnet,
            kSamplePrivateKey);
    
    store.ethereum.setClaimsApprovedMXCLocked(claimsApproved);
  }

}
