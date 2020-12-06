import 'extensions.dart';
import 'dart:typed_data';

import 'package:web3dart/credentials.dart';

enum LockdropTerm {
  threeMo,
  sixMo,
  nineMo,
  twelveMo,
  twentyFourMo,
  thirtySixMo,
}

class DeployerHostInfo {
  final String ip;
  final String hostname;
  final String scheme;
  final String city;
  final String ethereumAddress;

  String get url => '$scheme://$hostname';

  DeployerHostInfo({
    this.ip,
    this.hostname,
    this.scheme,
    this.city,
    this.ethereumAddress,
  });

  factory DeployerHostInfo.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return DeployerHostInfo(
      ip: map['ip'],
      hostname: map['hostname'],
      scheme: map['scheme'],
      city: map['city'],
      ethereumAddress: map['ethereum_address'],
    );
  }
}

enum ClaimType { lock, signal }

enum ClaimStatus { pending, finalized }

class DeployerException implements Exception {
  final String message;
  final String name;

  DeployerException(this.name, this.message);
}

class Claim {
  final ClaimType type;
  final String tokenAddress;
  final String tokenName;
  final String amount;
  final LockdropTerm term;
  final String dataHighwayPublicKey;
  final String depositTransaction;
  final String ethereumAccount;
  final String createdAt;
  final String lockAddress;
  Claim({
    this.type,
    this.tokenAddress,
    this.tokenName,
    this.amount,
    this.term,
    this.dataHighwayPublicKey,
    this.depositTransaction,
    this.ethereumAccount,
    this.createdAt,
    this.lockAddress,
  });

  String get transactionMessage {
    return '${term.deserialize()},lock,$amount(amount),${tokenName}PublicKey#,${lockAddress ?? 'waiting'}';
  }

  factory Claim.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Claim(
      type: map['type'] == 'lock' ? ClaimType.lock : ClaimType.signal,
      tokenAddress: map['tokenAddress'],
      tokenName: map['tokenName'],
      amount: map['amount'],
      term: LockdropTerm.values[map['term']],
      dataHighwayPublicKey: map['dataHighwayPublicKey'],
      depositTransaction: map['depositTransaction'],
      ethereumAccount: map['ethereumAccount'],
      createdAt: map['createdAt'],
      lockAddress: map['lockAddress'],
    );
  }
}

class LockWalletStructsResponse {
  final ClaimStatus claimStatus;
  final BigInt approvedAmount;
  final BigInt pendingAmount;
  final BigInt rejectedAmount;
  final LockdropTerm term;
  final BigInt tokenAmount;
  final Uint8List dataHighwayPublicKey;
  final EthereumAddress lockAddress;
  final bool isValidator;
  final BigInt createdAt;
  LockWalletStructsResponse({
    this.claimStatus,
    this.approvedAmount,
    this.pendingAmount,
    this.rejectedAmount,
    this.term,
    this.tokenAmount,
    this.dataHighwayPublicKey,
    this.lockAddress,
    this.isValidator,
    this.createdAt,
  });
}

class SignalWalletStructsResponse {
  final ClaimStatus claimStatus;
  final BigInt approvedAmount;
  final BigInt pendingAmount;
  final BigInt rejectedAmount;
  final LockdropTerm term;
  final BigInt tokenAmount;
  final Uint8List dataHighwayPublicKey;
  final EthereumAddress contractAddr;
  final BigInt nonce;
  final BigInt createdAt;
  SignalWalletStructsResponse({
    this.claimStatus,
    this.approvedAmount,
    this.pendingAmount,
    this.rejectedAmount,
    this.term,
    this.tokenAmount,
    this.dataHighwayPublicKey,
    this.contractAddr,
    this.nonce,
    this.createdAt,
  });
}

enum TransactionStatus { pending, failed, succeed }
