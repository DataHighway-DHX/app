import 'dart:async' show Future;

import 'package:flutter/services.dart' show rootBundle;
import 'package:polka_wallet/constants.dart';
import 'package:web3dart/web3dart.dart';

import 'api.dart';
import 'apiAccount.dart';

class EthereumApiMiningIOTAPegged {
  EthereumApiMiningIOTAPegged();

  BigInt signalled;
  BigInt claimsSignalledPending;
  BigInt getClaimsSignalledApproved;
  BigInt claimsSignalledRejected;

  // Get amount of IOTA (pegged) tokens that have been signalled
  Future<BigInt>
      getAccountSignalledIOTAPeggedAmountFromDataHighwayIOTAPeggedMiningContract(
          String rpcUrl, String wsUrl, EthereumAddress contractAddr,
          [String privateKey]) async {
    // TODO - move this into singleton
    EthereumApi ethereumApi = EthereumApi(rpcUrl: rpcUrl, wsUrl: wsUrl);
    Web3Client client = await ethereumApi.connectToWeb3EthereumClient();
    EthereumApiAccount ethereumApiAccount = EthereumApiAccount();
    EthereumAddress ownAddress = await ethereumApiAccount.getOwnAddress();
    print('Ethereum account address ${ownAddress.hex}');

    // Read the contract ABI and to inform web3dart of its deployed contractAddr
    final abiCode = await rootBundle.loadString(
        'assets/data/abi_datahighway_iota_pegged_mining_mainnet.json');
    final contract = DeployedContract(
        ContractAbi.fromJson(abiCode, 'DataHighwayIOTAPeggedMiningToken'),
        contractAddr);

    // Extracting some functions and events for later use
    final signalledEvent = contract.event('Signalled');
    final signalFunction = contract.function('signal');

    // Check signalled amount of DataHighwayIOTAPeggedMiningToken by calling the appropriate function
    List signalledList = await client.call(
        contract: contract, function: signalFunction, params: [ownAddress]);
    signalled = signalledList.first;
    print('You have ${signalled} DataHighwayIOTAPeggedMiningToken');

    // Listen for the Signalled event when emitted by the contract above
    final subscription = client
        .events(FilterOptions.events(contract: contract, event: signalledEvent))
        .take(1)
        .listen((event) async {
      final decoded = signalledEvent.decodeResults(event.topics, event.data);

      final from = decoded[0] as EthereumAddress;
      final to = decoded[1] as EthereumAddress;
      final value = decoded[2] as BigInt;

      if (from == ownAddress || to == ownAddress) {
        print('$from signalled $value DataHighwayIOTAPeggedMiningToken to $to');
        signalledList = await client.call(
            contract: contract, function: signalFunction, params: [ownAddress]);
        signalled = signalledList.first;
        print('You have ${signalled} DataHighwayIOTAPeggedMiningToken');
      }
    });

    await subscription.asFuture();
    await subscription.cancel();

    await client.dispose();

    return signalled;
  }

  // Note: Do not support locking IOTA (pegged) tokens

  // Get amount of IOTA (pegged) tokens that have been signalled
  // whose rewards have been claimed and pending approval 
  Future<BigInt>
      getAccountSignalledClaimsPendingOfIOTAPeggedAmountFromDataHighwayIOTAPeggedMiningContract(
          EthereumAddress contractAddr,
          [String privateKey]) async {
    // TODO - move this into singleton
    EthereumApi ethereumApi = EthereumApi(rpcUrl: kRpcUrlInfuraMainnet, wsUrl: kWsUrlInfuraMainnet);
    Web3Client client = await ethereumApi.connectToWeb3EthereumClient();
    EthereumApiAccount ethereumApiAccount = EthereumApiAccount();
    EthereumAddress ownAddress = await ethereumApiAccount.getOwnAddress();
    print('Ethereum account address ${ownAddress.hex}');

    // Read the contract ABI and to inform web3dart of its deployed contractAddr
    final abiCode = await rootBundle.loadString(
        'assets/data/abi_datahighway_iota_pegged_mining_mainnet.json');
    final contract = DeployedContract(
        ContractAbi.fromJson(abiCode, 'DataHighwayIOTAPeggedMiningToken'),
        contractAddr);

    // Extracting some functions and events for later use
    final claimSignalledPendingEvent = contract.event('ClaimSignalledPending');
    final claimsSignalledPendingFunction = contract.function('claimsSignalledPending');

    // Check claims Signalled pending amount of DataHighwayIOTAPeggedMiningToken by calling the appropriate function
    List claimsSignalledPendingList = await client.call(
        contract: contract,
        function: claimsSignalledPendingFunction,
        params: [ownAddress]);
    claimsSignalledPending = claimsSignalledPendingList.first;
    print(
        'You have ${claimsSignalledPending} of pending claims of DataHighwayIOTAPeggedMiningToken after Signalled');

    // Listen for the ClaimSignalledPending event when emitted by the contract above
    final subscription = client
        .events(
            FilterOptions.events(contract: contract, event: claimSignalledPendingEvent))
        .take(1)
        .listen((event) async {
      final decoded =
          claimSignalledPendingEvent.decodeResults(event.topics, event.data);

      final from = decoded[0] as EthereumAddress;
      final to = decoded[1] as EthereumAddress;
      final value = decoded[2] as BigInt;

      if (from == ownAddress || to == ownAddress) {
        print(
            '$from claimed $value DataHighwayIOTAPeggedMiningToken to $to is pending after Signalled');
        claimsSignalledPendingList = await client.call(
            contract: contract,
            function: claimsSignalledPendingFunction,
            params: [ownAddress]);
        claimsSignalledPending = claimsSignalledPendingList.first;
        print(
            'You have ${claimsSignalledPending} of pending claims of DataHighwayIOTAPeggedMiningToken after Signalled');
      }
    });

    await subscription.asFuture();
    await subscription.cancel();

    await client.dispose();

    return claimsSignalledPending;
  }

  // Get amount of IOTA (pegged) tokens that have been signalled whose rewards have had their claim approved
  Future<BigInt>
      getAccountSignalledClaimsApprovedOfIOTAPeggedAmountFromDataHighwayIOTAPeggedMiningContract(
          EthereumAddress contractAddr,
          [String privateKey]) async {
    // TODO - move this into singleton
    EthereumApi ethereumApi = EthereumApi(rpcUrl: kRpcUrlInfuraMainnet, wsUrl: kWsUrlInfuraMainnet);
    Web3Client client = await ethereumApi.connectToWeb3EthereumClient();
    EthereumApiAccount ethereumApiAccount = EthereumApiAccount();
    EthereumAddress ownAddress = await ethereumApiAccount.getOwnAddress();
    print('Ethereum account address ${ownAddress.hex}');

    // Read the contract ABI and to inform web3dart of its deployed contractAddr
    final abiCode = await rootBundle.loadString(
        'assets/data/abi_datahighway_iota_pegged_mining_mainnet.json');
    final contract = DeployedContract(
        ContractAbi.fromJson(abiCode, 'DataHighwayIOTAPeggedMiningToken'),
        contractAddr);

    // Extracting some functions and events for later use
    final claimSignalledApprovedEvent = contract.event('ClaimSignalledApproved');
    final getClaimsSignalledApprovedFunction = contract.function('getClaimsSignalledApproved');

    // Check claims Signalled approved amount of DataHighwayIOTAPeggedMiningToken by calling the appropriate function
    List getClaimsSignalledApprovedList = await client.call(
        contract: contract,
        function: getClaimsSignalledApprovedFunction,
        params: [ownAddress]);
    getClaimsSignalledApproved = getClaimsSignalledApprovedList.first;
    print(
        'You have ${getClaimsSignalledApproved} of approved claims of DataHighwayIOTAPeggedMiningToken after Signalled');

    // Listen for the ClaimSignalledApproved event when emitted by the contract above
    final subscription = client
        .events(
            FilterOptions.events(contract: contract, event: claimSignalledApprovedEvent))
        .take(1)
        .listen((event) async {
      final decoded =
          claimSignalledApprovedEvent.decodeResults(event.topics, event.data);

      final from = decoded[0] as EthereumAddress;
      final to = decoded[1] as EthereumAddress;
      final value = decoded[2] as BigInt;

      if (from == ownAddress || to == ownAddress) {
        print(
            '$from claimed $value DataHighwayIOTAPeggedMiningToken to $to was approved after Signalled');
        getClaimsSignalledApprovedList = await client.call(
            contract: contract,
            function: getClaimsSignalledApprovedFunction,
            params: [ownAddress]);
        getClaimsSignalledApproved = getClaimsSignalledApprovedList.first;
        print(
            'You have ${getClaimsSignalledApproved} of approved claims of DataHighwayIOTAPeggedMiningToken after Signalled');
      }
    });

    await subscription.asFuture();
    await subscription.cancel();

    await client.dispose();

    return getClaimsSignalledApproved;
  }

  // Get amount of IOTA (pegged) tokens that have been signalled whose rewards have had their claim rejected
  Future<BigInt>
      getAccountSignalledClaimsRejectedOfIOTAPeggedAmountFromDataHighwayIOTAPeggedMiningContract(
          EthereumAddress contractAddr,
          [String privateKey]) async {
    // TODO - move this into singleton
    EthereumApi ethereumApi = EthereumApi(rpcUrl: kRpcUrlInfuraMainnet, wsUrl: kWsUrlInfuraMainnet);
    Web3Client client = await ethereumApi.connectToWeb3EthereumClient();
    EthereumApiAccount ethereumApiAccount = EthereumApiAccount();
    EthereumAddress ownAddress = await ethereumApiAccount.getOwnAddress();
    print('Ethereum account address ${ownAddress.hex}');

    // Read the contract ABI and to inform web3dart of its deployed contractAddr
    final abiCode = await rootBundle.loadString(
        'assets/data/abi_datahighway_iota_pegged_mining_mainnet.json');
    final contract = DeployedContract(
        ContractAbi.fromJson(abiCode, 'DataHighwayIOTAPeggedMiningToken'),
        contractAddr);

    // Extracting some functions and events for later use
    final claimSignalledRejectedEvent = contract.event('ClaimSignalledRejected');
    final claimsSignalledRejectedFunction = contract.function('claimsSignalledRejected');

    // Check claims Signalled rejected amount of DataHighwayIOTAPeggedMiningToken by calling the appropriate function
    List claimsSignalledRejectedList = await client.call(
        contract: contract,
        function: claimsSignalledRejectedFunction,
        params: [ownAddress]);
    claimsSignalledRejected = claimsSignalledRejectedList.first;
    print(
        'You have ${claimsSignalledRejected} of rejected claims of DataHighwayIOTAPeggedMiningToken after Signalled');

    // Listen for the ClaimSignalledRejected event when emitted by the contract above
    final subscription = client
        .events(
            FilterOptions.events(contract: contract, event: claimSignalledRejectedEvent))
        .take(1)
        .listen((event) async {
      final decoded =
          claimSignalledRejectedEvent.decodeResults(event.topics, event.data);

      final from = decoded[0] as EthereumAddress;
      final to = decoded[1] as EthereumAddress;
      final value = decoded[2] as BigInt;

      if (from == ownAddress || to == ownAddress) {
        print(
            '$from claimed $value DataHighwayIOTAPeggedMiningToken to $to was rejected after Signalled');
        claimsSignalledRejectedList = await client.call(
            contract: contract,
            function: claimsSignalledRejectedFunction,
            params: [ownAddress]);
        claimsSignalledRejected = claimsSignalledRejectedList.first;
        print(
            'You have ${claimsSignalledRejected} of rejected claims of DataHighwayIOTAPeggedMiningToken after Signalled');
      }
    });

    await subscription.asFuture();
    await subscription.cancel();

    await client.dispose();

    return claimsSignalledRejected;
  }
}
