import 'dart:async' show Future;

import 'package:flutter/services.dart' show rootBundle;
import 'package:polka_wallet/constants.dart';
import 'package:polka_wallet/service/ethereumApi/apiAccount.dart';
import 'package:web3dart/web3dart.dart';

import 'api.dart';
import 'apiAccount.dart';

import '../../constants.dart';

class EthereumApiAssetsIOTAPegged {
  EthereumApiAssetsIOTAPegged();

  BigInt balance;

  // Get an account balance of IOTA Pegged tokens on the Ethereum network
  Future<BigInt>
      getAccountBalanceFromIOTAPeggedContract(
          EthereumAddress contractAddr,
          [String privateKey]) async {
    // TODO - move this into singleton
    EthereumApi ethereumApi = EthereumApi(rpcUrl: kRpcUrlInfuraTestnetRopsten, wsUrl: kWsUrlInfuraTestnetRopsten);
    Web3Client client = await ethereumApi.connectToWeb3EthereumClient();
    EthereumApiAccount ethereumApiAccount = EthereumApiAccount();
    EthereumAddress ownAddress = await ethereumApiAccount.getOwnAddress();
    print('Ethereum account address ${ownAddress.hex}');

    // Read the contract ABI and to inform web3dart of its deployed contractAddr
    final abiCode = await rootBundle.loadString(
        'assets/data/${kAbiCodeFileDataHighwayIOTAPeggedTestnet}');
    final contract = DeployedContract(
        ContractAbi.fromJson(abiCode, 'IOTAPeggedToken'),
        contractAddr);

    // Extracting some functions and events for later use
    final peggedEvent = contract.event('Pegged');
    final balanceFunction = contract.function('balanceOf');
    final pegFunction = contract.function('peg');

    // Check balance of IOTAPeggedMiningToken by calling the appropriate function
    List balanceList = await client.call(
        contract: contract, function: balanceFunction, params: [ownAddress]);
    balance = balanceList.first;
    print('You have ${balance} IOTAPeggedToken');

    // FIXME - this isn't working yet
    // // Listen for the Pegged event when emitted by the contract above
    // final subscription = client
    //     .events(FilterOptions.events(contract: contract, event: peggedEvent))
    //     .take(1)
    //     .listen((event) async {
    //   final decoded = peggedEvent.decodeResults(event.topics, event.data);

    //   final from = decoded[0] as EthereumAddress;
    //   final to = decoded[1] as EthereumAddress;
    //   final value = decoded[2] as BigInt;

    //   if (from == ownAddress || to == ownAddress) {
    //     print('$from pegged $value IOTAPeggedToken to $to');
    //     balanceList = await client.call(
    //         contract: contract,
    //         function: balanceFunction,
    //         params: [ownAddress]);
    //     balance = balanceList.first;
    //     print('You have ${balance} IOTAPeggedToken');
    //   }
    // });

    // await subscription.asFuture();
    // await subscription.cancel();

    // await client.dispose();

    return balance;
  }
}
