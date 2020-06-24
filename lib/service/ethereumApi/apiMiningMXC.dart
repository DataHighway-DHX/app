import 'dart:async' show Future;

import 'package:flutter/services.dart' show rootBundle;
import 'package:polka_wallet/constants.dart';
import 'package:web3dart/web3dart.dart';

import 'api.dart';
import 'apiAccount.dart';

import '../../constants.dart';

class EthereumApiMiningMXC {
  EthereumApiMiningMXC();

  Map claimDataSignaled;
  Map claimDataLocked;

  // Get data about MXC tokens that have been signaled
  Future<Map> getAccountSignaledClaimsDataFromDataHighwayMXCMiningContract(
      String rpcUrl, String wsUrl, EthereumAddress contractAddr,
      [String privateKey]) async {
    // TODO - move this into singleton
    EthereumApi ethereumApi = EthereumApi(rpcUrl: rpcUrl, wsUrl: wsUrl);
    Web3Client client = await ethereumApi.connectToWeb3EthereumClient();
    EthereumApiAccount ethereumApiAccount = EthereumApiAccount();
    EthereumAddress ownAddress = await ethereumApiAccount.getOwnAddress();
    print('Ethereum account address ${ownAddress.hex}');

    // Read the contract ABI and to inform web3dart of its deployed contractAddr
    final abiCode = await rootBundle
        .loadString('assets/data/${kAbiCodeFileDataHighwayLockdropTestnet}');
    final contract = DeployedContract(
        ContractAbi.fromJson(abiCode, 'DataHighwayLockdrop'),
        contractAddr);

    final claimStatusUpdatedEvent = contract.event('ClaimStatusUpdated');
    final signalWalletStructsFunction = contract.function('signalWalletStructs');

    List signalWalletStructsList = await client.call(
        contract: contract, function: signalWalletStructsFunction, params: [ownAddress, kContractAddrMXCTestnet]);

    // TODO - refactor into utils since this is repeat code
    // Convert List to Map so we have named keys
    var signalWalletStructs = new Map(); 
    signalWalletStructs['claimStatus'] = signalWalletStructsList[0]; 
    signalWalletStructs['approvedTokenERC20Amount'] = signalWalletStructsList[1];
    signalWalletStructs['term'] = signalWalletStructsList[2];
    signalWalletStructs['tokenERC20Amount'] = signalWalletStructsList[3];
    signalWalletStructs['dataHighwayPublicKey'] = signalWalletStructsList[4];
    signalWalletStructs['contractAddr'] = signalWalletStructsList[5];
    signalWalletStructs['nonce'] = signalWalletStructsList[6];
    signalWalletStructs['createdAt'] = signalWalletStructsList[7];

    claimDataSignaled = signalWalletStructs;
    print('Your signaled claim data is: ${signalWalletStructs}');

    // FIXME - this isn't working yet
    // // Listen for the Signaled event when emitted by the contract above
    // final subscription = client
    //     .events(FilterOptions.events(contract: contract, event: claimStatusUpdatedEvent))
    //     .take(1)
    //     .listen((event) async {
    //   final decoded = claimStatusUpdatedEvent.decodeResults(event.topics, event.data);

    //   final user = decoded[0] as EthereumAddress;
    //   final claimType = decoded[1] as int;
    //   final tokenContractAddress = decoded[2] as EthereumAddress;
    //   final claimStatus = decoded[3] as int;
    //   final approvedTokenERC20Amount = decoded[4] as BigInt;
    //   final time = decoded[5] as int;

    //   if (user == ownAddress && tokenContractAddress == kContractAddrMXCTestnet) {
    //     print('Updated signaled claim data ($claimType) of $user using token $tokenContractAddress to status $claimStatus');
    //     signalWalletStructsList = await client.call(
    //         contract: contract, function: signalWalletStructsFunction, params: [ownAddress, kContractAddrMXCTestnet]);

    //     // TODO - refactor into utils since this is repeat code
    //     // Convert List to Map so we have named keys
    //     var signalWalletStructs = new Map(); 
    //     signalWalletStructs['claimStatus'] = signalWalletStructsList[0]; 
    //     signalWalletStructs['approvedTokenERC20Amount'] = signalWalletStructsList[1];
    //     signalWalletStructs['term'] = signalWalletStructsList[2];
    //     signalWalletStructs['tokenERC20Amount'] = signalWalletStructsList[3];
    //     signalWalletStructs['dataHighwayPublicKey'] = signalWalletStructsList[4];
    //     signalWalletStructs['contractAddr'] = signalWalletStructsList[5];
    //     signalWalletStructs['nonce'] = signalWalletStructsList[6];
    //     signalWalletStructs['createdAt'] = signalWalletStructsList[7];

    //     claimDataSignaled = signalWalletStructs;
    //     print('Your latest signaled claim data is: ${signalWalletStructs}');
    //   }
    // });

    // await subscription.asFuture();
    // await subscription.cancel();

    // await client.dispose();

    return claimDataSignaled;
  }

  // Get data about MXC tokens that have been locked
  Future<Map> getAccountLockedClaimsDataFromDataHighwayMXCMiningContract(
      String rpcUrl, String wsUrl, EthereumAddress contractAddr,
      [String privateKey]) async {
    // TODO - move this into singleton
    EthereumApi ethereumApi = EthereumApi(rpcUrl: rpcUrl, wsUrl: wsUrl);
    Web3Client client = await ethereumApi.connectToWeb3EthereumClient();
    EthereumApiAccount ethereumApiAccount = EthereumApiAccount();
    EthereumAddress ownAddress = await ethereumApiAccount.getOwnAddress();
    print('Ethereum account address ${ownAddress.hex}');

    // Read the contract ABI and to inform web3dart of its deployed contractAddr
    final abiCode = await rootBundle
        .loadString('assets/data/${kAbiCodeFileDataHighwayLockdropTestnet}');
    final contract = DeployedContract(
        ContractAbi.fromJson(abiCode, 'DataHighwayLockdrop'),
        contractAddr);

    final claimStatusUpdatedEvent = contract.event('ClaimStatusUpdated');
    final lockWalletStructsFunction = contract.function('lockWalletStructs');

    List lockWalletStructsList = await client.call(
        contract: contract, function: lockWalletStructsFunction, params: [ownAddress, kContractAddrMXCTestnet]);
    
    // Convert List to Map so we have named keys
    var lockWalletStructs = new Map(); 
    lockWalletStructs['claimStatus'] = lockWalletStructsList[0]; 
    lockWalletStructs['approvedTokenERC20Amount'] = lockWalletStructsList[1];
    lockWalletStructs['term'] = lockWalletStructsList[2];
    lockWalletStructs['tokenERC20Amount'] = lockWalletStructsList[3];
    lockWalletStructs['dataHighwayPublicKey'] = lockWalletStructsList[4];
    lockWalletStructs['lockAddr'] = lockWalletStructsList[5];
    lockWalletStructs['isValidator'] = lockWalletStructsList[6];
    lockWalletStructs['createdAt'] = lockWalletStructsList[7];

    claimDataLocked = lockWalletStructs;
    print('Your locked claim data is: ${lockWalletStructs}');

    // FIXME - this isn't working yet
    // // Listen for the ClaimStatusUpdated event when emitted by the contract above
    // final subscription = client
    //     .events(FilterOptions.events(contract: contract, event: claimStatusUpdatedEvent))
    //     .take(1)
    //     .listen((event) async {
    //   final decoded = claimStatusUpdatedEvent.decodeResults(event.topics, event.data);

    //   final user = decoded[0] as EthereumAddress;
    //   final claimType = decoded[1] as int;
    //   final tokenContractAddress = decoded[2] as EthereumAddress;
    //   final claimStatus = decoded[3] as int;
    //   final approvedTokenERC20Amount = decoded[4] as BigInt;
    //   final time = decoded[5] as int;

    //   if (user == ownAddress && tokenContractAddress == kContractAddrMXCTestnet && claimType == 0) {
    //     print('Updated locked claim data ($claimType) of $user using token $tokenContractAddress to status $claimStatus');
    //     lockWalletStructsList = await client.call(
    //         contract: contract, function: lockWalletStructsFunction, params: [ownAddress, kContractAddrMXCTestnet]);
    //     claimDataLocked = lockWalletStructsList.first;
    //     print('Your latest locked claim data is: ${claimDataLocked}');
    //   }
    // });

    // await subscription.asFuture();
    // await subscription.cancel();

    // await client.dispose();

    return claimDataLocked;
  }
}
