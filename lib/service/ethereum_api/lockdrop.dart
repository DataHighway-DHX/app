import 'dart:async' show Future;
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:polka_wallet/constants.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web3dart/credentials.dart';

import 'api.dart';

import '../../constants.dart';
import 'contract.dart';

class LockdropApi extends BaseContractApi {
  LockdropApi(this.host, ContractAbiProvider abiProvider,
      EthereumAddress contractAddress, EthereumApi ethereumApi)
      : super(abiProvider, contractAddress, ethereumApi);

  final DeployerHostInfo host;

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

  // Future<void> signal({
  //   @required LockdropTerm term,
  //   @required BigInt amount,
  //   @required Uint8List dhxPublicKey,
  //   @required EthereumAddress tokenContractAddress,
  // }) async {
  //   final client = await getClient();
  //   final contract = await getContract();

  //   List response = await client.call(
  //     contract: contract,
  //     function: contract.function('signal'),
  //     params: [
  //       term.deserialize(),
  //       amount,
  //       dhxPublicKey,
  //       tokenContractAddress,
  //     ],
  //   );
  //   print(response);
  // }

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

  // /// Creates locking transaction and returns its hash
  // Future<String> lock({
  //   @required EthereumAddress contractOwnerAddress,
  //   @required LockdropTerm term,
  //   @required BigInt amount,
  //   @required Uint8List dhxPublicKey,
  //   @required EthereumAddress tokenContractAddress,
  //   @required bool isValidator,
  //   int maxGas = 2000000,
  //   int gasPrice = 30,
  // }) async {
  //   final client = await getClient();
  //   client.printErrors = true;
  //   final contract = await getContract();
  //   final privateKeyWrapped =
  //       await client.credentialsFromPrivateKey(ethPrivateKey);
  //   final tx = Transaction.callContract(
  //     contract: contract,
  //     function: contract.function('lock'),
  //     maxGas: maxGas,
  //     gasPrice: EtherAmount.fromUnitAndValue(EtherUnit.gwei, gasPrice),
  //     parameters: [
  //       contractOwnerAddress,
  //       term.deserialize(),
  //       amount,
  //       dhxPublicKey,
  //       tokenContractAddress,
  //       isValidator,
  //     ],
  //   );
  //   tx.toString();
  //   final res = await client.sendTransaction(
  //     privateKeyWrapped,
  //     Transaction.callContract(
  //       contract: contract,
  //       function: contract.function('lock'),
  //       maxGas: maxGas,
  //       gasPrice: EtherAmount.fromUnitAndValue(EtherUnit.gwei, gasPrice),
  //       parameters: [
  //         contractOwnerAddress,
  //         term.deserialize(),
  //         amount,
  //         dhxPublicKey,
  //         tokenContractAddress,
  //         isValidator,
  //       ],
  //     ),
  //     fetchChainIdFromNetworkId: true,
  //   );
  //   final transaction = await client.getTransactionByHash(res);
  //   print(transaction);
  //   return null; //res;
  // }

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
}
