import 'dart:async' show Future;
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:polka_wallet/constants.dart';
import 'package:polka_wallet/service/ethereumApi/model.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web3dart/credentials.dart';

import 'api.dart';
import 'apiAccount.dart';

import '../../constants.dart';
import 'contract.dart';

class LockdropApi extends BaseContractApi {
  LockdropApi(ContractAbiProvider abiProvider, EthereumAddress contractAddress,
      EthereumApi ethereumApi)
      : super(abiProvider, contractAddress, ethereumApi);

  Future<SignalWalletStructsResponse> signalWalletStructs(
      EthereumAddress accountAddress, EthereumAddress tokenAddress) async {
    final client = await getClient();
    final contract = await getContract();

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
    final client = await getClient();
    final contract = await getContract();

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
    final client = await getClient();
    final contract = await getContract();

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

  /// Creates locking transaction and returns its hash
  Future<String> lock({
    @required EthereumAddress contractOwnerAddress,
    @required LockdropTerm term,
    @required BigInt amount,
    @required Uint8List dhxPublicKey,
    @required EthereumAddress tokenContractAddress,
    @required bool isValidator,
    @required String privateKey,
    int maxGas = 2000000,
    int gasPrice = 30,
  }) async {
    final client = await getClient();
    client.printErrors = true;
    final contract = await getContract();
    final privateKeyWrapped =
        await client.credentialsFromPrivateKey(ethPrivateKey);
    final res = await client.sendTransaction(
      privateKeyWrapped,
      Transaction.callContract(
        contract: contract,
        function: contract.function('lock'),
        maxGas: maxGas,
        gasPrice: EtherAmount.fromUnitAndValue(EtherUnit.gwei, gasPrice),
        parameters: [
          contractOwnerAddress,
          term.deserialize(),
          amount,
          dhxPublicKey,
          tokenContractAddress,
          isValidator,
        ],
      ),
      fetchChainIdFromNetworkId: true,
    );
    final transaction = await client.getTransactionByHash(res);
    print(transaction);
    return res;
  }

  Future<TransactionStatus> waitForTransaction(String hash,
      {Duration timeout = const Duration(milliseconds: 1000)}) async {
    var status = TransactionStatus.pending;
    do {
      status = await getTransactionStatus(hash);
      if (status == TransactionStatus.pending) {
        await Future.delayed(timeout);
      }
    } while (status == TransactionStatus.pending);
    return status;
  }

  Future<TransactionStatus> getTransactionStatus(String hash) async {
    final client = await getClient();
    final transaction = await client.getTransactionReceipt(hash);
    if (transaction == null ||
        transaction.blockNumber == null ||
        transaction.blockNumber.isPending) {
      return TransactionStatus.pending;
    }
    return transaction.status
        ? TransactionStatus.succeed
        : TransactionStatus.failed;
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
}
