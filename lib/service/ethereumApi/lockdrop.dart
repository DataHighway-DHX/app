import 'dart:async' show Future;
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:polka_wallet/constants.dart';
import 'package:polka_wallet/service/ethereumApi/model.dart';
import 'package:web3dart/web3dart.dart';

import 'api.dart';
import 'apiAccount.dart';

import '../../constants.dart';

abstract class ContractAbiProvider {
  Future<String> getAbiCode();

  factory ContractAbiProvider.fromAsset(String path) {
    return _ContractAbiProviderAsset(path);
  }
}

class _ContractAbiProviderAsset implements ContractAbiProvider {
  final String assetPath;
  String _abi;

  _ContractAbiProviderAsset(this.assetPath);
  Future<String> getAbiCode() async {
    _abi ??= await rootBundle.loadString(assetPath);
    return _abi;
  }
}

class LockdropApi {
  final EthereumAddress dhxContractAddress;
  final ContractAbiProvider abiProvider;

  final EthereumApi _ethereumApi;

  LockdropApi({
    String rpcUrl,
    String wsUrl,
    @required this.dhxContractAddress,
    @required this.abiProvider,
  }) : _ethereumApi = EthereumApi(rpcUrl: rpcUrl, wsUrl: wsUrl);

  Web3Client _cachedClient;

  Future<String> _abiCode() async {
    return await abiProvider.getAbiCode();
  }

  Future<Web3Client> _client() async {
    if (_cachedClient != null) return _cachedClient;
    Web3Client client = await _ethereumApi.connectToWeb3EthereumClient();
    _cachedClient = client;
    return client;
  }

  Future<DeployedContract> _contract() async {
    final abiCode = await _abiCode();
    return DeployedContract(
      ContractAbi.fromJson(abiCode, 'DataHighwayLockdrop'),
      dhxContractAddress,
    );
  }

  Future<SignalWalletStructsResponse> signalWalletStructs(
      EthereumAddress accountAddress, EthereumAddress tokenAddress) async {
    final client = await _client();
    final contract = await _contract();

    List response = await client.call(
      contract: contract,
      function: contract.function('signalWalletStructs'),
      params: [
        accountAddress,
        tokenAddress,
      ],
    );

    return SignalWalletStructsResponse(
      claimStatus: response[0] == null
          ? null
          : ClaimStatus.values[(response[0] as BigInt).toInt()],
      approvedAmount: response[1],
      pendingAmount: response[2],
      rejectedAmount: response[3],
      term: response[4] == null
          ? null
          : LockdropTerm.values[(response[4] as BigInt).toInt()],
      tokenAmount: response[5],
      dataHighwayPublicKey: response[6],
      contractAddr: response[7],
      nonce: response[8],
      createdAt: response[9],
    );
  }

  Future<void> signal({
    @required LockdropTerm term,
    @required BigInt amount,
    @required Uint8List dhxPublicKey,
    @required EthereumAddress tokenContractAddress,
  }) async {
    final client = await _client();
    final contract = await _contract();

    List response = await client.call(
      contract: contract,
      function: contract.function('signal'),
      params: [
        term.deserialize(),
        amount,
        dhxPublicKey,
        tokenContractAddress,
      ],
    );
    print(response);
  }

  Future<LockWalletStructsResponse> lockWalletStructs(
      EthereumAddress accountAddress, EthereumAddress tokenAddress) async {
    final client = await _client();
    final contract = await _contract();

    List response = await client.call(
      contract: contract,
      function: contract.function('lockWalletStructs'),
      params: [
        accountAddress,
        tokenAddress,
      ],
    );

    return LockWalletStructsResponse(
      claimStatus: response[0] == null
          ? null
          : ClaimStatus.values[(response[0] as BigInt).toInt()],
      approvedAmount: response[1],
      pendingAmount: response[2],
      rejectedAmount: response[3],
      term: response[4] == null
          ? null
          : LockdropTerm.values[(response[4] as BigInt).toInt()],
      tokenAmount: response[5],
      dataHighwayPublicKey: response[6],
      lockAddress: response[7],
      isValidator: response[8],
      createdAt: response[9],
    );
  }

  Future<EthereumAddress> lock({
    @required EthereumAddress contractOwnerAddress,
    @required LockdropTerm term,
    @required BigInt amount,
    @required Uint8List dhxPublicKey,
    @required EthereumAddress tokenContractAddress,
    @required bool isValidator,
  }) async {
    final client = await _client();
    client.printErrors = true;
    final contract = await _contract();

    final balance = await client.getBalance(contractOwnerAddress);

    List response = await client.call(
      contract: contract,
      function: contract.function('lock'),
      params: [
        contractOwnerAddress,
        term.deserialize(),
        amount,
        dhxPublicKey,
        tokenContractAddress,
        isValidator,
      ],
    );
    return response[0] as EthereumAddress;
  }

  @deprecated
  Map claimDataSignaled;

  @deprecated
  Future<Map> getSignaledClaimsIota(
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
        ContractAbi.fromJson(abiCode, 'DataHighwayLockdrop'), contractAddr);

    final claimStatusUpdatedEvent = contract.event('ClaimStatusUpdated');
    final signalWalletStructsFunction =
        contract.function('signalWalletStructs');

    List signalWalletStructsList = await client.call(
        contract: contract,
        function: signalWalletStructsFunction,
        params: [ownAddress, kContractAddrIOTAPeggedTestnet]);

    // TODO - refactor into utils since this is repeat code
    // Convert List to Map so we have named keys
    var signalWalletStructs = new Map();
    signalWalletStructs['claimStatus'] = signalWalletStructsList[0];
    signalWalletStructs['approvedTokenERC20Amount'] =
        signalWalletStructsList[1];
    signalWalletStructs['pendingTokenERC20Amount'] = signalWalletStructsList[2];
    signalWalletStructs['rejectedTokenERC20Amount'] =
        signalWalletStructsList[3];
    signalWalletStructs['term'] = signalWalletStructsList[4];
    signalWalletStructs['tokenERC20Amount'] = signalWalletStructsList[5];
    signalWalletStructs['dataHighwayPublicKey'] = signalWalletStructsList[6];
    signalWalletStructs['contractAddr'] = signalWalletStructsList[7];
    signalWalletStructs['nonce'] = signalWalletStructsList[8];
    signalWalletStructs['createdAt'] = signalWalletStructsList[9];

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
    //   final pendingTokenERC20Amount = decoded[5] as BigInt;
    //   final rejectedTokenERC20Amount = decoded[6] as BigInt;
    //   final time = decoded[7] as int;

    //   if (user == ownAddress && tokenContractAddress == kContractAddrIOTAPeggedTestnet) {
    //     print('Updated signaled claim data ($claimType) of $user using token $tokenContractAddress to status $claimStatus');
    //     signalWalletStructsList = await client.call(
    //         contract: contract, function: signalWalletStructsFunction, params: [ownAddress, kContractAddrIOTAPeggedTestnet]);

    //     // TODO - refactor into utils since this is repeat code
    //     // Convert List to Map so we have named keys
    //     var signalWalletStructs = new Map();
    //     signalWalletStructs['claimStatus'] = signalWalletStructsList[0];
    //     signalWalletStructs['approvedTokenERC20Amount'] = signalWalletStructsList[1];
    //     signalWalletStructs['pendingTokenERC20Amount'] = signalWalletStructsList[2];
    //     signalWalletStructs['rejectedTokenERC20Amount'] = signalWalletStructsList[3];
    //     signalWalletStructs['term'] = signalWalletStructsList[4];
    //     signalWalletStructs['tokenERC20Amount'] = signalWalletStructsList[5];
    //     signalWalletStructs['dataHighwayPublicKey'] = signalWalletStructsList[6];
    //     signalWalletStructs['contractAddr'] = signalWalletStructsList[7];
    //     signalWalletStructs['nonce'] = signalWalletStructsList[8];
    //     signalWalletStructs['createdAt'] = signalWalletStructsList[9];

    //     claimDataSignaled = signalWalletStructs;
    //     print('Your latest signaled claim data is: ${signalWalletStructs}');
    //   }
    // });

    // await subscription.asFuture();
    // await subscription.cancel();

    // await client.dispose();

    return claimDataSignaled;
  }

  Future<void> dispose() async {
    await _cachedClient?.dispose();
  }
}
