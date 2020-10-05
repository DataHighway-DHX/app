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

extension LockdropTermExtensions on LockdropTerm {
  BigInt deserialize() {
    return BigInt.from(LockdropTerm.values.indexOf(this));
  }
}

enum ClaimType { lock, signal }

enum ClaimStatus { pending, finalized }

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
