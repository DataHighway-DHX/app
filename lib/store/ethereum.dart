import 'package:mobx/mobx.dart';

part 'ethereum.g.dart';

class EthereumStore = _EthereumStore with _$EthereumStore;

abstract class _EthereumStore with Store {
  @observable
  BigInt balanceMXC = BigInt.parse('0');

  @observable
  BigInt claimsPendingMXCLocked = BigInt.parse('0');

  @observable
  BigInt claimsApprovedMXCLocked = BigInt.parse('0');

  @action
  void setBalanceMXC(BigInt balance) {
    balanceMXC = balance;
  }

  @action
  void setClaimsPendingMXCLocked(BigInt pending) {
    claimsPendingMXCLocked = pending;
  }

  @action
  void setClaimsApprovedMXCLocked(BigInt approved) {
    claimsApprovedMXCLocked = approved;
  }
}