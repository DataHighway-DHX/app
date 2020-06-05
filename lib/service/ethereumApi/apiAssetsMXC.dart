import 'dart:async' show Future;

import 'package:flutter/services.dart' show rootBundle;
import 'package:polka_wallet/constants.dart';
import 'package:web3dart/web3dart.dart';

import 'api.dart';
import 'apiAccount.dart';

class EthereumApiAssetsMXC {
  EthereumApiAssetsMXC();

  BigInt balance;

  // Get an account balance of MXC tokens on the Ethereum network
  Future<BigInt> getAccountBalanceFromMXCContract( EthereumAddress contractAddr,
      [String privateKey]) async {
    // TODO - move this into singleton
    EthereumApi ethereumApi = EthereumApi(rpcUrl: kRpcUrlInfuraMainnet, wsUrl: kWsUrlInfuraMainnet);
    Web3Client client = await ethereumApi.connectToWeb3EthereumClient();
    EthereumApiAccount ethereumApiAccount = EthereumApiAccount();
    EthereumAddress ownAddress = await ethereumApiAccount.getOwnAddress();
    print('Ethereum account address ${ownAddress.hex}');

    // Read the contract ABI and to inform web3dart of its deployed contractAddr
    final abiCode =
        await rootBundle.loadString('assets/data/abi_mxc_mainnet.json');
    final contract = DeployedContract(
        ContractAbi.fromJson(abiCode, 'MXCToken'), contractAddr);

    // Extracting some functions and events for later use
    final transferEvent = contract.event('Transfer');
    final balanceFunction = contract.function('balanceOf');
    final transferFunction = contract.function('transfer');

    // Check balance of MXCToken by calling the appropriate function
    List balanceList = await client.call(
        contract: contract, function: balanceFunction, params: [ownAddress]);
    balance = balanceList.first;
    print('You have ${balance} MXCToken');

    try{
       _subscription(client,contract,transferEvent,ownAddress,balanceList,balanceFunction);
    }catch(err){
      print('_subscriptionListener exception: $err');
    }

    return balance;
  }

  Future<void> _subscription(client,contract,transferEvent,ownAddress,balanceList,balanceFunction) async{
     // Listen for the Transfer event when emitted by the contract above
    final subscription = client
        .events(FilterOptions.events(contract: contract, event: transferEvent))
        .take(1)
        .listen((event) async {
      final decoded = transferEvent.decodeResults(event.topics, event.data);

      final from = decoded[0] as EthereumAddress;
      final to = decoded[1] as EthereumAddress;
      final value = decoded[2] as BigInt;

      if (from == ownAddress || to == ownAddress) {
        print('$from sent $value MXCTokens to $to');
        balanceList = await client.call(
            contract: contract,
            function: balanceFunction,
            params: [ownAddress]);
        balance = balanceList.first;
        print('You have ${balance} MXCToken');
      }
    });

    await subscription.asFuture();
    await subscription.cancel();

    await client.dispose();
  }
}
