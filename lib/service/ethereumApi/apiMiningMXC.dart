import 'dart:async' show Future;

import 'package:flutter/services.dart' show rootBundle;
import 'package:web3dart/web3dart.dart';

import 'api.dart';
import 'apiAccount.dart';

class EthereumApiMiningMXC {
  EthereumApiMiningMXC();

  BigInt signalled;
  BigInt claimsSignalledPending;
  BigInt claimsSignalledApproved;
  BigInt claimsSignalledRejected;

  BigInt locked;
  BigInt claimsLockedPending;
  BigInt claimsLockedApproved;
  BigInt claimsLockedRejected;

  // Get amount of MXC tokens that have been signalled
  Future<BigInt> getAccountSignalledMXCAmountFromDataHighwayMXCMiningContract(
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
        .loadString('assets/data/abi_datahighway_mxc_mining_mainnet.json');
    final contract = DeployedContract(
        ContractAbi.fromJson(abiCode, 'DataHighwayMXCMiningToken'),
        contractAddr);

    // Extracting some functions and events for later use
    final signalledEvent = contract.event('Signalled');
    final signalFunction = contract.function('signal');

    // Check signalled amount of DataHighwayMXCMiningToken by calling the appropriate function
    List signalledList = await client.call(
        contract: contract, function: signalFunction, params: [ownAddress]);
    signalled = signalledList.first;
    print('You have ${signalled} DataHighwayMXCMiningToken');

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
        print('$from signalled $value DataHighwayMXCMiningTokens to $to');
        signalledList = await client.call(
            contract: contract, function: signalFunction, params: [ownAddress]);
        signalled = signalledList.first;
        print('You have ${signalled} DataHighwayMXCMiningTokens');
      }
    });

    await subscription.asFuture();
    await subscription.cancel();

    await client.dispose();

    return signalled;
  }

  // Get amount of MXC tokens that have been signalled
  // whose rewards have been claimed and pending approval 
  Future<BigInt>
      getAccountSignalledClaimsPendingOfMXCAmountFromDataHighwayMXCMiningContract(
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
        .loadString('assets/data/abi_datahighway_mxc_mining_mainnet.json');
    final contract = DeployedContract(
        ContractAbi.fromJson(abiCode, 'DataHighwayMXCMiningToken'),
        contractAddr);

    // Extracting some functions and events for later use
    final claimSignalledPendingEvent = contract.event('ClaimSignalledPending');
    final claimsSignalledPendingFunction = contract.function('claimsSignalledPending');

    // Check claims Signalled pending amount of DataHighwayMXCMiningToken by calling the appropriate function
    List claimsSignalledPendingList = await client.call(
        contract: contract,
        function: claimsSignalledPendingFunction,
        params: [ownAddress]);
    claimsSignalledPending = claimsSignalledPendingList.first;
    print(
        'You have ${claimsSignalledPending} of pending claims of DataHighwayMXCMiningToken after Signalled');

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
            '$from claimed $value DataHighwayMXCMiningTokens to $to is pending after Signalled');
        claimsSignalledPendingList = await client.call(
            contract: contract,
            function: claimsSignalledPendingFunction,
            params: [ownAddress]);
        claimsSignalledPending = claimsSignalledPendingList.first;
        print(
            'You have ${claimsSignalledPending} of pending claims of DataHighwayMXCMiningTokens after Signalled');
      }
    });

    await subscription.asFuture();
    await subscription.cancel();

    await client.dispose();

    return claimsSignalledPending;
  }

  // Get amount of MXC tokens that have been signalled whose rewards have had their claim approved
  Future<BigInt>
      getAccountSignalledClaimsApprovedOfMXCAmountFromDataHighwayMXCMiningContract(
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
        .loadString('assets/data/abi_datahighway_mxc_mining_mainnet.json');
    final contract = DeployedContract(
        ContractAbi.fromJson(abiCode, 'DataHighwayMXCMiningToken'),
        contractAddr);

    // Extracting some functions and events for later use
    final claimSignalledApprovedEvent = contract.event('ClaimSignalledApproved');
    final claimsSignalledApprovedFunction = contract.function('claimsSignalledApproved');

    // Check claims Signalled approved amount of DataHighwayMXCMiningToken by calling the appropriate function
    List claimsSignalledApprovedList = await client.call(
        contract: contract,
        function: claimsSignalledApprovedFunction,
        params: [ownAddress]);
    claimsSignalledApproved = claimsSignalledApprovedList.first;
    print(
        'You have ${claimsSignalledApproved} of approved claims of DataHighwayMXCMiningToken after Signalled');

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
            '$from claimed $value DataHighwayMXCMiningTokens to $to was approved after Signalled');
        claimsSignalledApprovedList = await client.call(
            contract: contract,
            function: claimsSignalledApprovedFunction,
            params: [ownAddress]);
        claimsSignalledApproved = claimsSignalledApprovedList.first;
        print(
            'You have ${claimsSignalledApproved} of approved claims of DataHighwayMXCMiningTokens after Signalled');
      }
    });

    await subscription.asFuture();
    await subscription.cancel();

    await client.dispose();

    return claimsSignalledApproved;
  }

  // Get amount of MXC tokens that have been signalled whose rewards have had their claim rejected
  Future<BigInt>
      getAccountSignalledClaimsRejectedOfMXCAmountFromDataHighwayMXCMiningContract(
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
        .loadString('assets/data/abi_datahighway_mxc_mining_mainnet.json');
    final contract = DeployedContract(
        ContractAbi.fromJson(abiCode, 'DataHighwayMXCMiningToken'),
        contractAddr);

    // Extracting some functions and events for later use
    final claimSignalledRejectedEvent = contract.event('ClaimSignalledRejected');
    final claimsSignalledRejectedFunction = contract.function('claimsSignalledRejected');

    // Check claims Signalled rejected amount of DataHighwayMXCMiningToken by calling the appropriate function
    List claimsSignalledRejectedList = await client.call(
        contract: contract,
        function: claimsSignalledRejectedFunction,
        params: [ownAddress]);
    claimsSignalledRejected = claimsSignalledRejectedList.first;
    print(
        'You have ${claimsSignalledRejected} of rejected claims of DataHighwayMXCMiningToken after Signalled');

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
            '$from claimed $value DataHighwayMXCMiningTokens to $to was rejected after Signalled');
        claimsSignalledRejectedList = await client.call(
            contract: contract,
            function: claimsSignalledRejectedFunction,
            params: [ownAddress]);
        claimsSignalledRejected = claimsSignalledRejectedList.first;
        print(
            'You have ${claimsSignalledRejected} of rejected claims of DataHighwayMXCMiningTokens after Signalled');
      }
    });

    await subscription.asFuture();
    await subscription.cancel();

    await client.dispose();

    return claimsSignalledRejected;
  }

  // Get amount of MXC tokens that have been locked
  Future<BigInt> getAccountLockedMXCAmountFromDataHighwayMXCMiningContract(
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
        .loadString('assets/data/abi_datahighway_mxc_mining_mainnet.json');
    final contract = DeployedContract(
        ContractAbi.fromJson(abiCode, 'DataHighwayMXCMiningToken'),
        contractAddr);

    // Extracting some functions and events for later use
    final lockedEvent = contract.event('Locked');
    final lockFunction = contract.function('lock');

    // Check locked amount of DataHighwayMXCMiningToken by calling the appropriate function
    List lockedList = await client
        .call(contract: contract, function: lockFunction, params: [ownAddress]);
    locked = lockedList.first;
    print('You have ${locked} DataHighwayMXCMiningToken');

    // Listen for the Locked event when emitted by the contract above
    final subscription = client
        .events(FilterOptions.events(contract: contract, event: lockedEvent))
        .take(1)
        .listen((event) async {
      final decoded = lockedEvent.decodeResults(event.topics, event.data);

      final from = decoded[0] as EthereumAddress;
      final to = decoded[1] as EthereumAddress;
      final value = decoded[2] as BigInt;

      if (from == ownAddress || to == ownAddress) {
        print('$from locked $value DataHighwayMXCMiningTokens to $to');
        lockedList = await client.call(
            contract: contract, function: lockFunction, params: [ownAddress]);
        locked = lockedList.first;
        print('You have ${locked} DataHighwayMXCMiningTokens');
      }
    });

    await subscription.asFuture();
    await subscription.cancel();

    await client.dispose();

    return locked;
  }

  // Get amount of MXC tokens that have been locked
  // whose rewards have been claimed and pending approval 
  Future<BigInt>
      getAccountLockedClaimsPendingOfMXCAmountFromDataHighwayMXCMiningContract(
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
        .loadString('assets/data/abi_datahighway_mxc_mining_mainnet.json');
    final contract = DeployedContract(
        ContractAbi.fromJson(abiCode, 'DataHighwayMXCMiningToken'),
        contractAddr);

    // Extracting some functions and events for later use
    final claimLockedPendingEvent = contract.event('ClaimLockedPending');
    final claimsLockedPendingFunction = contract.function('claimsLockedPending');

    // Check claims Locked pending amount of DataHighwayMXCMiningToken by calling the appropriate function
    List claimsLockedPendingList = await client.call(
        contract: contract,
        function: claimsLockedPendingFunction,
        params: [ownAddress]);
    claimsLockedPending = claimsLockedPendingList.first;
    print(
        'You have ${claimsLockedPending} of pending claims of DataHighwayMXCMiningToken after Locked');

    // Listen for the ClaimLockedPending event when emitted by the contract above
    final subscription = client
        .events(
            FilterOptions.events(contract: contract, event: claimLockedPendingEvent))
        .take(1)
        .listen((event) async {
      final decoded =
          claimLockedPendingEvent.decodeResults(event.topics, event.data);

      final from = decoded[0] as EthereumAddress;
      final to = decoded[1] as EthereumAddress;
      final value = decoded[2] as BigInt;

      if (from == ownAddress || to == ownAddress) {
        print(
            '$from claimed $value DataHighwayMXCMiningTokens to $to is pending after Locked');
        claimsLockedPendingList = await client.call(
            contract: contract,
            function: claimsLockedPendingFunction,
            params: [ownAddress]);
        claimsLockedPending = claimsLockedPendingList.first;
        print(
            'You have ${claimsLockedPending} of pending claims of DataHighwayMXCMiningTokens after Locked');
      }
    });

    await subscription.asFuture();
    await subscription.cancel();

    await client.dispose();

    return claimsLockedPending;
  }

  // Get amount of MXC tokens that have been locked whose rewards have had their claim approved
  Future<BigInt>
      getAccountLockedClaimsApprovedOfMXCAmountFromDataHighwayMXCMiningContract(
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
        .loadString('assets/data/abi_datahighway_mxc_mining_mainnet.json');
    final contract = DeployedContract(
        ContractAbi.fromJson(abiCode, 'DataHighwayMXCMiningToken'),
        contractAddr);

    // Extracting some functions and events for later use
    final claimLockedApprovedEvent = contract.event('ClaimLockedApproved');
    final claimsLockedApprovedFunction = contract.function('claimsLockedApproved');

    // Check claims Locked approved amount of DataHighwayMXCMiningToken by calling the appropriate function
    List claimsLockedApprovedList = await client.call(
        contract: contract,
        function: claimsLockedApprovedFunction,
        params: [ownAddress]);
    claimsLockedApproved = claimsLockedApprovedList.first;
    print(
        'You have ${claimsLockedApproved} of approved claims of DataHighwayMXCMiningToken after Locked');

    // Listen for the ClaimLockedApproved event when emitted by the contract above
    final subscription = client
        .events(
            FilterOptions.events(contract: contract, event: claimLockedApprovedEvent))
        .take(1)
        .listen((event) async {
      final decoded =
          claimLockedApprovedEvent.decodeResults(event.topics, event.data);

      final from = decoded[0] as EthereumAddress;
      final to = decoded[1] as EthereumAddress;
      final value = decoded[2] as BigInt;

      if (from == ownAddress || to == ownAddress) {
        print(
            '$from claimed $value DataHighwayMXCMiningTokens to $to was approved after Locked');
        claimsLockedApprovedList = await client.call(
            contract: contract,
            function: claimsLockedApprovedFunction,
            params: [ownAddress]);
        claimsLockedApproved = claimsLockedApprovedList.first;
        print(
            'You have ${claimsLockedApproved} of approved claims of DataHighwayMXCMiningTokens after Locked');
      }
    });

    await subscription.asFuture();
    await subscription.cancel();

    await client.dispose();

    return claimsLockedApproved;
  }

  // Get amount of MXC tokens that have been locked whose rewards have had their claim rejected
  Future<BigInt>
      getAccountLockedClaimsRejectedOfMXCAmountFromDataHighwayMXCMiningContract(
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
        .loadString('assets/data/abi_datahighway_mxc_mining_mainnet.json');
    final contract = DeployedContract(
        ContractAbi.fromJson(abiCode, 'DataHighwayMXCMiningToken'),
        contractAddr);

    // Extracting some functions and events for later use
    final claimLockedRejectedEvent = contract.event('ClaimLockedRejected');
    final claimsLockedRejectedFunction = contract.function('claimsLockedRejected');

    // Check claims Locked rejected amount of DataHighwayMXCMiningToken by calling the appropriate function
    List claimsLockedRejectedList = await client.call(
        contract: contract,
        function: claimsLockedRejectedFunction,
        params: [ownAddress]);
    claimsLockedRejected = claimsLockedRejectedList.first;
    print(
        'You have ${claimsLockedRejected} of rejected claims of DataHighwayMXCMiningToken after Locked');

    // Listen for the ClaimLockedRejected event when emitted by the contract above
    final subscription = client
        .events(
            FilterOptions.events(contract: contract, event: claimLockedRejectedEvent))
        .take(1)
        .listen((event) async {
      final decoded =
          claimLockedRejectedEvent.decodeResults(event.topics, event.data);

      final from = decoded[0] as EthereumAddress;
      final to = decoded[1] as EthereumAddress;
      final value = decoded[2] as BigInt;

      if (from == ownAddress || to == ownAddress) {
        print(
            '$from claimed $value DataHighwayMXCMiningTokens to $to was rejected after Locked');
        claimsLockedRejectedList = await client.call(
            contract: contract,
            function: claimsLockedRejectedFunction,
            params: [ownAddress]);
        claimsLockedRejected = claimsLockedRejectedList.first;
        print(
            'You have ${claimsLockedRejected} of rejected claims of DataHighwayMXCMiningTokens after Locked');
      }
    });

    await subscription.asFuture();
    await subscription.cancel();

    await client.dispose();

    return claimsLockedRejected;
  }
}