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
  EthereumApiAssetsIOTAPegged assetsIOTAPegged;

  void init() async{
    await getBalanceFormMXC(); 
    await fetchMXCLockedClaimsApproved();
    await fetchMXCLockedClaimsPending();
    await fetchMXCLockedClaimsRejected();
    await fetchMXCSignalledClaimsApproved();
    await fetchMXCSignalledClaimsPending();
    await fetchMXCSignalledClaimsRejected();

    await fetchBalanceIOTAPegged();
    await fetchIOTAPeggedSignalledClaimsApproved();
    await fetchIOTAPeggedSignalledClaimsPending();
    await fetchIOTAPeggedSignalledClaimsRejected();
  }

  //MXC balance
  Future<void> getBalanceFormMXC() async{
    assetsMXC = EthereumApiAssetsMXC();

    // print('Getting MXC account balance');
    BigInt balance = await assetsMXC.getAccountBalanceFromMXCContract(kContractAddrMXCMainnet, kSamplePrivateKey);

    store.ethereum.setBalanceMXC(balance);   
  }

  //Locked Approved
  Future<void> fetchMXCLockedClaimsApproved() async {
    print('Getting amount of approved reward claims for locking MXC');
    EthereumApiMiningMXC ethApiMiningMXC = await EthereumApiMiningMXC();
    BigInt claimsApproved = await ethApiMiningMXC
        .getAccountLockedClaimsApprovedOfMXCAmountFromDataHighwayMXCMiningContract(
            kContractAddrMXCMainnet,
            kSamplePrivateKey);
    
    store.ethereum.setClaimsApprovedMXCLocked(claimsApproved);
  }

  //Locked Pending
  Future<void> fetchMXCLockedClaimsPending() async {
    print('Getting amount of pending reward claims for locking MXC');
    ethApiMiningMXC = await EthereumApiMiningMXC();
    BigInt claimsPending = await ethApiMiningMXC
        .getAccountLockedClaimsPendingOfMXCAmountFromDataHighwayMXCMiningContract(
            kContractAddrMXCMainnet,
            kSamplePrivateKey);

    store.ethereum.setClaimsPendingMXCLocked(claimsPending);
  }

  //Locked Rejected
  Future<void> fetchMXCLockedClaimsRejected() async {
    print('Getting amount of rejected reward claims for locking MXC');
    EthereumApiMiningMXC ethApiMiningMXC = await EthereumApiMiningMXC();
    BigInt claimsRejected = await ethApiMiningMXC
        .getAccountLockedClaimsRejectedOfMXCAmountFromDataHighwayMXCMiningContract(
            kContractAddrMXCMainnet,
            kSamplePrivateKey);
    
    store.ethereum.setClaimsRejectedMXCLocked(claimsRejected);

    //count claims total
    store.ethereum.setClaimsTotalMXCLocked();
    store.ethereum.countClaimsProportionsMXCLocked();
  }

  //Signled Approved
  Future<BigInt> fetchMXCSignalledClaimsApproved() async {
    print('Getting amount of approved reward claims for signalling MXC');
    EthereumApiMiningMXC ethApiMiningMXC = await EthereumApiMiningMXC();
    BigInt claimsApproved = await ethApiMiningMXC
        .getAccountSignalledClaimsApprovedOfMXCAmountFromDataHighwayMXCMiningContract(
            kContractAddrMXCMainnet,
            kSamplePrivateKey);

    store.ethereum.setClaimsApprovedMXCSignaled(claimsApproved);
  }

  Future<BigInt> fetchMXCSignalledClaimsPending() async {
    print('Getting amount of pending reward claims for signalling MXC');
    EthereumApiMiningMXC ethApiMiningMXC = await EthereumApiMiningMXC();
    BigInt claimsPending = await ethApiMiningMXC
        .getAccountSignalledClaimsPendingOfMXCAmountFromDataHighwayMXCMiningContract(
            kContractAddrMXCMainnet,
            kSamplePrivateKey);

    store.ethereum.setClaimsPendingMXCSignaled(claimsPending);
  }

  //Signaled reject
  Future<BigInt> fetchMXCSignalledClaimsRejected() async {
    print('Getting amount of rejected reward claims for signalling MXC');
    EthereumApiMiningMXC ethApiMiningMXC = await EthereumApiMiningMXC();
    BigInt claimsRejected = await ethApiMiningMXC
        .getAccountSignalledClaimsRejectedOfMXCAmountFromDataHighwayMXCMiningContract(
            kContractAddrMXCMainnet,
            kSamplePrivateKey);

    store.ethereum.setClaimsRejectedMXCSignaled(claimsRejected);

    //count claims total
    store.ethereum.setClaimsTotalMXCSignaled();
    store.ethereum.countClaimsProportionsMXCSignaled();
  }

  //IOTA balance
  Future<void> fetchBalanceIOTAPegged() async {
    print(
        'Getting amount of approved reward claims for signalling IOTA (pegged)');
    EthereumApiAssetsIOTAPegged ethApiAssetsIOTAPegged =
        EthereumApiAssetsIOTAPegged();
    BigInt balance = await ethApiAssetsIOTAPegged
        .getAccountBalanceIOTAPeggedFromDataHighwayMiningIOTAPeggedContract(
            kContractAddrMXCMainnet,
            kSamplePrivateKey);

    store.ethereum.setBalanceIOTAPegged(balance);
  }

  //IOTA Signaled Approved
  Future<void> fetchIOTAPeggedSignalledClaimsApproved() async {
    print(
        'Getting amount of approved reward claims for signalling IOTA (pegged)');
    EthereumApiMiningIOTAPegged ethApiMiningIOTAPegged =
        await EthereumApiMiningIOTAPegged();
    BigInt getClaimsSignalledApproved = await ethApiMiningIOTAPegged
        .getAccountSignalledClaimsApprovedOfIOTAPeggedAmountFromDataHighwayIOTAPeggedMiningContract(
            kContractAddrMXCMainnet,
            kSamplePrivateKey);

    store.ethereum.setClaimsApprovedIOTAPeggedSignaled(getClaimsSignalledApproved);
  }

  //IOTA Signaled Pending
  Future<void> fetchIOTAPeggedSignalledClaimsPending() async {
    print(
        'Getting amount of pending reward claims for signalling IOTA (pegged)');
    EthereumApiMiningIOTAPegged ethApiMiningIOTAPegged =
        await EthereumApiMiningIOTAPegged();
    BigInt claimsSignalledPending = await ethApiMiningIOTAPegged
        .getAccountSignalledClaimsPendingOfIOTAPeggedAmountFromDataHighwayIOTAPeggedMiningContract(
            kContractAddrMXCMainnet,
            kSamplePrivateKey);

    store.ethereum.setClaimsPendingIOTAPeggedSignaled(claimsSignalledPending);
  }

  //IOTA Signaled Rejected
  Future<void> fetchIOTAPeggedSignalledClaimsRejected() async {
    print(
        'Getting amount of rejected reward claims for signalling IOTA (pegged)');
    EthereumApiMiningIOTAPegged ethApiMiningIOTAPegged =
        await EthereumApiMiningIOTAPegged();
    BigInt claimsSignalledRejected = await ethApiMiningIOTAPegged
        .getAccountSignalledClaimsRejectedOfIOTAPeggedAmountFromDataHighwayIOTAPeggedMiningContract(
            kContractAddrMXCMainnet,
            kSamplePrivateKey);

    store.ethereum.setClaimsRejectedIOTAPeggedSignaled(claimsSignalledRejected);

    store.ethereum.setClaimsTotalIOTAPeggedSignaled();
    store.ethereum.countClaimsProportionsIOTAPeggedSignaled();
  }

}