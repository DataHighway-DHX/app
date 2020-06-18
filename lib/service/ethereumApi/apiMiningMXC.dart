import 'dart:async' show Future;

import 'package:flutter/services.dart' show rootBundle;
import 'package:polka_wallet/constants.dart';
import 'package:web3dart/web3dart.dart';

import 'api.dart';
import 'apiAccount.dart';

class EthereumApiMiningMXC {
  EthereumApiMiningMXC();

  BigInt signalled;
  BigInt claimsSignalledPending;
  BigInt getClaimsSignalledApproved;
  BigInt claimsSignalledRejected;

  BigInt locked;
  BigInt getClaimsLockedPending;
  BigInt getClaimsLockedApproved;
  BigInt getClaimsLockedRejected;

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
        .loadString('assets/data/abi_datahighway_mxc_mining_testnet.json');
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
          EthereumAddress contractAddr,
          [String privateKey]) async {
    // TODO - move this into singleton
    EthereumApi ethereumApi = EthereumApi(rpcUrl: kRpcUrlInfuraTestnetRopsten, wsUrl: kWsUrlInfuraTestnetRopsten);
    Web3Client client = await ethereumApi.connectToWeb3EthereumClient();
    EthereumApiAccount ethereumApiAccount = EthereumApiAccount();
    EthereumAddress ownAddress = await ethereumApiAccount.getOwnAddress();
    print('Ethereum account address ${ownAddress.hex}');

    // Read the contract ABI and to inform web3dart of its deployed contractAddr
    final abiCode = await rootBundle
        .loadString('assets/data/abi_datahighway_mxc_mining_testnet.json');
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
          EthereumAddress contractAddr,
          [String privateKey]) async {
    // TODO - move this into singleton
    EthereumApi ethereumApi = EthereumApi(rpcUrl: kRpcUrlInfuraTestnetRopsten, wsUrl: kWsUrlInfuraTestnetRopsten);
    Web3Client client = await ethereumApi.connectToWeb3EthereumClient();
    EthereumApiAccount ethereumApiAccount = EthereumApiAccount();
    EthereumAddress ownAddress = await ethereumApiAccount.getOwnAddress();
    print('Ethereum account address ${ownAddress.hex}');

    // Read the contract ABI and to inform web3dart of its deployed contractAddr
    final abiCode = await rootBundle
        .loadString('assets/data/abi_datahighway_mxc_mining_testnet.json');
    final contract = DeployedContract(
        ContractAbi.fromJson(abiCode, 'DataHighwayMXCMiningToken'),
        contractAddr);

    // Extracting some functions and events for later use
    final claimSignalledApprovedEvent = contract.event('ClaimSignalledApproved');
    final getClaimsSignalledApprovedFunction = contract.function('getClaimsSignalledApproved');

    // Check claims Signalled approved amount of DataHighwayMXCMiningToken by calling the appropriate function
    List getClaimsSignalledApprovedList = await client.call(
        contract: contract,
        function: getClaimsSignalledApprovedFunction,
        params: [ownAddress]);
    getClaimsSignalledApproved = getClaimsSignalledApprovedList.first;
    print(
        'You have ${getClaimsSignalledApproved} of approved claims of DataHighwayMXCMiningToken after Signalled');

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
        getClaimsSignalledApprovedList = await client.call(
            contract: contract,
            function: getClaimsSignalledApprovedFunction,
            params: [ownAddress]);
        getClaimsSignalledApproved = getClaimsSignalledApprovedList.first;
        print(
            'You have ${getClaimsSignalledApproved} of approved claims of DataHighwayMXCMiningTokens after Signalled');
      }
    });

    await subscription.asFuture();
    await subscription.cancel();

    await client.dispose();

    return getClaimsSignalledApproved;
  }

  // Get amount of MXC tokens that have been signalled whose rewards have had their claim rejected
  Future<BigInt>
      getAccountSignalledClaimsRejectedOfMXCAmountFromDataHighwayMXCMiningContract(
          EthereumAddress contractAddr,
          [String privateKey]) async {
    // TODO - move this into singleton
    EthereumApi ethereumApi = EthereumApi(rpcUrl: kRpcUrlInfuraTestnetRopsten, wsUrl: kWsUrlInfuraTestnetRopsten);
    Web3Client client = await ethereumApi.connectToWeb3EthereumClient();
    EthereumApiAccount ethereumApiAccount = EthereumApiAccount();
    EthereumAddress ownAddress = await ethereumApiAccount.getOwnAddress();
    print('Ethereum account address ${ownAddress.hex}');

    // Read the contract ABI and to inform web3dart of its deployed contractAddr
    final abiCode = await rootBundle
        .loadString('assets/data/abi_datahighway_mxc_mining_testnet.json');
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
        .loadString('assets/data/abi_datahighway_mxc_mining_testnet.json');
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
          EthereumAddress contractAddr,
          [String privateKey]) async {
    // TODO - move this into singleton
    EthereumApi ethereumApi = EthereumApi(rpcUrl: kRpcUrlInfuraTestnetRopsten, wsUrl: kWsUrlInfuraTestnetRopsten);
    Web3Client client = await ethereumApi.connectToWeb3EthereumClient();
    EthereumApiAccount ethereumApiAccount = EthereumApiAccount();
    EthereumAddress ownAddress = await ethereumApiAccount.getOwnAddress();
    print('Ethereum account address ${ownAddress.hex}');

    // Read the contract ABI and to inform web3dart of its deployed contractAddr
    final abiCode = await rootBundle
        // FIXME - change this to the lockdrop contract
        .loadString('assets/data/abi_datahighway_mxc_mining_testnet.json');
    final contract = DeployedContract(
        ContractAbi.fromJson(abiCode, 'DataHighwayMXCMiningToken'),
        contractAddr);

    // Extracting some functions and events for later use
    final claimLockedPendingEvent = contract.event('ClaimLockedPending');
    final getClaimsLockedPendingFunction = contract.function('getClaimsLockedPending');

    // Check claims Locked pending amount of DataHighwayMXCMiningToken by calling the appropriate function
    List getClaimsLockedPendingList = await client.call(
        contract: contract,
        function: getClaimsLockedPendingFunction,
        params: [ownAddress]);
    getClaimsLockedPending = getClaimsLockedPendingList.first;
    print(
        'You have ${getClaimsLockedPending} of pending claims of DataHighwayMXCMiningToken after Locked');

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
        getClaimsLockedPendingList = await client.call(
            contract: contract,
            function: getClaimsLockedPendingFunction,
            params: [ownAddress]);
        getClaimsLockedPending = getClaimsLockedPendingList.first;
        print(
            'You have ${getClaimsLockedPending} of pending claims of DataHighwayMXCMiningTokens after Locked');
      }
    });

    await subscription.asFuture();
    await subscription.cancel();

    await client.dispose();

    return getClaimsLockedPending;
  }

  // Get amount of MXC tokens that have been locked whose rewards have had their claim approved
  Future<BigInt>
      getAccountLockedClaimsApprovedOfMXCAmountFromDataHighwayMXCMiningContract(
          EthereumAddress contractAddr,
          [String privateKey]) async {
    // TODO - move this into singleton
    EthereumApi ethereumApi = EthereumApi(rpcUrl: kRpcUrlInfuraTestnetRopsten, wsUrl: kWsUrlInfuraTestnetRopsten);
    Web3Client client = await ethereumApi.connectToWeb3EthereumClient();
    EthereumApiAccount ethereumApiAccount = EthereumApiAccount();
    EthereumAddress ownAddress = await ethereumApiAccount.getOwnAddress();
    print('Ethereum account address ${ownAddress.hex}');

    // Read the contract ABI and to inform web3dart of its deployed contractAddr
    final abiCode = await rootBundle
        .loadString('assets/data/abi_datahighway_mxc_mining_testnet.json');
    final contract = DeployedContract(
        ContractAbi.fromJson(abiCode, 'DataHighwayMXCMiningToken'),
        contractAddr);

    // Extracting some functions and events for later use
    final claimLockedApprovedEvent = contract.event('ClaimLockedApproved');
    final getClaimsLockedApprovedFunction = contract.function('getClaimsLockedApproved');

    // Check claims Locked approved amount of DataHighwayMXCMiningToken by calling the appropriate function
    List getClaimsLockedApprovedList = await client.call(
        contract: contract,
        function: getClaimsLockedApprovedFunction,
        params: [ownAddress]);
    getClaimsLockedApproved = getClaimsLockedApprovedList.first;
    print(
        'You have ${getClaimsLockedApproved} of approved claims of DataHighwayMXCMiningToken after Locked');

    try{
      _getClaimsLockedApprovedSubscription(client,contract,claimLockedApprovedEvent,ownAddress,getClaimsLockedApprovedList,getClaimsLockedApprovedFunction);
    }catch(err){
      print('_getClaimsLockedApprovedSubscription exception: $err');
    }

    return getClaimsLockedApproved;
  }

  Future<void> _getClaimsLockedApprovedSubscription(client,contract,claimLockedApprovedEvent,ownAddress,getClaimsLockedApprovedList,getClaimsLockedApprovedFunction) async{
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
        getClaimsLockedApprovedList = await client.call(
            contract: contract,
            function: getClaimsLockedApprovedFunction,
            params: [ownAddress]);
        getClaimsLockedApproved = getClaimsLockedApprovedList.first;
        print(
            'You have ${getClaimsLockedApproved} of approved claims of DataHighwayMXCMiningTokens after Locked');
      }
    });

    await subscription.asFuture();
    await subscription.cancel();

    await client.dispose();

  }

  // Get amount of MXC tokens that have been locked whose rewards have had their claim rejected
  Future<BigInt>
      getAccountLockedClaimsRejectedOfMXCAmountFromDataHighwayMXCMiningContract(
          EthereumAddress contractAddr,
          [String privateKey]) async {
    // TODO - move this into singleton
    EthereumApi ethereumApi = EthereumApi(rpcUrl: kRpcUrlInfuraTestnetRopsten, wsUrl: kWsUrlInfuraTestnetRopsten);
    Web3Client client = await ethereumApi.connectToWeb3EthereumClient();
    EthereumApiAccount ethereumApiAccount = EthereumApiAccount();
    EthereumAddress ownAddress = await ethereumApiAccount.getOwnAddress();
    print('Ethereum account address ${ownAddress.hex}');

    // Read the contract ABI and to inform web3dart of its deployed contractAddr
    final abiCode = await rootBundle
        .loadString('assets/data/abi_datahighway_mxc_mining_testnet.json');
    final contract = DeployedContract(
        ContractAbi.fromJson(abiCode, 'DataHighwayMXCMiningToken'),
        contractAddr);

    // Extracting some functions and events for later use
    final claimLockedRejectedEvent = contract.event('ClaimLockedRejected');
    final getClaimsLockedRejectedFunction = contract.function('getClaimsLockedRejected');

    // Check claims Locked rejected amount of DataHighwayMXCMiningToken by calling the appropriate function
    List getClaimsLockedRejectedList = await client.call(
        contract: contract,
        function: getClaimsLockedRejectedFunction,
        params: [ownAddress]);
    getClaimsLockedRejected = getClaimsLockedRejectedList.first;
    print(
        'You have ${getClaimsLockedRejected} of rejected claims of DataHighwayMXCMiningToken after Locked');

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
        getClaimsLockedRejectedList = await client.call(
            contract: contract,
            function: getClaimsLockedRejectedFunction,
            params: [ownAddress]);
        getClaimsLockedRejected = getClaimsLockedRejectedList.first;
        print(
            'You have ${getClaimsLockedRejected} of rejected claims of DataHighwayMXCMiningTokens after Locked');
      }
    });

    await subscription.asFuture();
    await subscription.cancel();

    await client.dispose();

    return getClaimsLockedRejected;
  }
}
