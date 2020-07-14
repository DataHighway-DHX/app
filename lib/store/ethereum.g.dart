// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ethereum.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$EthereumStore on _EthereumStore, Store {
  final _$balanceMXCAtom = Atom(name: '_EthereumStore.balanceMXC');

  @override
  BigInt get balanceMXC {
    _$balanceMXCAtom.reportRead();
    return super.balanceMXC;
  }

  @override
  set balanceMXC(BigInt value) {
    _$balanceMXCAtom.reportWrite(value, super.balanceMXC, () {
      super.balanceMXC = value;
    });
  }

  final _$claimsPendingMXCLockedAtom =
      Atom(name: '_EthereumStore.claimsPendingMXCLocked');

  @override
  BigInt get claimsPendingMXCLocked {
    _$claimsPendingMXCLockedAtom.reportRead();
    return super.claimsPendingMXCLocked;
  }

  @override
  set claimsPendingMXCLocked(BigInt value) {
    _$claimsPendingMXCLockedAtom
        .reportWrite(value, super.claimsPendingMXCLocked, () {
      super.claimsPendingMXCLocked = value;
    });
  }

  final _$claimsApprovedMXCLockedAtom =
      Atom(name: '_EthereumStore.claimsApprovedMXCLocked');

  @override
  BigInt get claimsApprovedMXCLocked {
    _$claimsApprovedMXCLockedAtom.reportRead();
    return super.claimsApprovedMXCLocked;
  }

  @override
  set claimsApprovedMXCLocked(BigInt value) {
    _$claimsApprovedMXCLockedAtom
        .reportWrite(value, super.claimsApprovedMXCLocked, () {
      super.claimsApprovedMXCLocked = value;
    });
  }

  final _$_EthereumStoreActionController =
      ActionController(name: '_EthereumStore');

  @override
  void setBalanceMXC(BigInt balance) {
    final _$actionInfo = _$_EthereumStoreActionController.startAction(
        name: '_EthereumStore.setBalanceMXC');
    try {
      return super.setBalanceMXC(balance);
    } finally {
      _$_EthereumStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setClaimsPendingMXCLocked(BigInt pending) {
    final _$actionInfo = _$_EthereumStoreActionController.startAction(
        name: '_EthereumStore.setClaimsPendingMXCLocked');
    try {
      return super.setClaimsPendingMXCLocked(pending);
    } finally {
      _$_EthereumStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setClaimsApprovedMXCLocked(BigInt approved) {
    final _$actionInfo = _$_EthereumStoreActionController.startAction(
        name: '_EthereumStore.setClaimsApprovedMXCLocked');
    try {
      return super.setClaimsApprovedMXCLocked(approved);
    } finally {
      _$_EthereumStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
balanceMXC: ${balanceMXC},
claimsPendingMXCLocked: ${claimsPendingMXCLocked},
claimsApprovedMXCLocked: ${claimsApprovedMXCLocked}
    ''';
  }
}
