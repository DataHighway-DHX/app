import 'package:mobx/mobx.dart';

part 'ethereum.g.dart';

class EthereumStore = _EthereumStore with _$EthereumStore;

abstract class _EthereumStore with Store {
  @observable
  BigInt balanceMXC = BigInt.parse('0');

  @observable
  BigInt balanceIOTAPegged = BigInt.parse('0');

  @observable
  BigInt claimsApprovedMXCLocked = BigInt.parse('0');

  @observable
  BigInt claimsPendingMXCLocked = BigInt.parse('0');

  @observable
  BigInt claimsRejectedMXCLocked = BigInt.parse('0');

  @observable
  double claimsApprovedProportionsMXCLocked = 0;

  @observable
  double claimsPendingProportionsMXCLocked = 0;

  @observable
  double claimsRejectedProportionsMXCLocked = 0;

  @observable
  BigInt claimsTotalMXCLocked = BigInt.parse('0');

  @observable
  BigInt claimsApprovedMXCSignaled = BigInt.parse('0');

  @observable
  BigInt claimsPendingMXCSignaled = BigInt.parse('0');

  @observable
  BigInt claimsRejectedMXCSignaled = BigInt.parse('0');

  @observable
  double claimsApprovedProportionsMXCSignaled = 0;

  @observable
  double claimsPendingProportionsMXCSignaled = 0;

  @observable
  double claimsRejectedProportionsMXCSignaled = 0;

  @observable
  BigInt claimsTotalMXCSignaled = BigInt.parse('0');

  @observable
  BigInt claimsApprovedIOTAPeggedSignaled = BigInt.parse('0');

  @observable
  BigInt claimsPendingIOTAPeggedSignaled = BigInt.parse('0');

  @observable
  BigInt claimsRejectedIOTAPeggedSignaled = BigInt.parse('0');

  @observable
  BigInt claimsTotalIOTAPeggedSignaled = BigInt.parse('0');

  @observable
  double claimsApprovedProportionsIOTAPeggedSignaled = 0;

  @observable
  double claimsPendingProportionsIOTAPeggedSignaled = 0;

  @observable
  double claimsRejectedProportionsIOTAPeggedSignaled = 0;

  @action
  void setBalanceMXC(BigInt balance) {
    balanceMXC = balance;
  }

  @action
  void setBalanceIOTAPegged(BigInt balance) {
    balanceIOTAPegged = balance;
  }

  @action
  void setClaimsApprovedMXCLocked(BigInt approved) {
    claimsApprovedMXCLocked = approved;
  }

  @action
  void setClaimsPendingMXCLocked(BigInt pending) {
    claimsPendingMXCLocked = pending;
  }

  @action
  void setClaimsRejectedMXCLocked(BigInt rejected) {
    claimsRejectedMXCLocked = rejected;
  }

  @action
  void setClaimsApprovedIOTAPeggedSignaled(BigInt approved) {
    claimsApprovedIOTAPeggedSignaled = approved;
  }

  @action
  void setClaimsPendingIOTAPeggedSignaled(BigInt pending) {
    claimsPendingIOTAPeggedSignaled = pending;
  }

  @action
  void setClaimsRejectedIOTAPeggedSignaled(BigInt rejected) {
    claimsRejectedIOTAPeggedSignaled = rejected;
  }

  @action
  void setClaimsTotalMXCLocked() {
    claimsTotalMXCLocked = claimsApprovedMXCLocked + claimsPendingMXCLocked + claimsRejectedMXCLocked;
  }

  @action
  void countClaimsProportionsMXCLocked() {
    claimsApprovedProportionsMXCLocked = claimsApprovedMXCLocked / claimsTotalMXCLocked;

    claimsPendingProportionsMXCLocked = claimsPendingMXCLocked / claimsTotalMXCLocked;

    claimsRejectedProportionsMXCLocked = claimsRejectedMXCLocked / claimsTotalMXCLocked;
  }

  @action
  void setClaimsPendingMXCSignaled(BigInt pending) {
    claimsPendingMXCLocked = pending;
  }

  @action
  void setClaimsApprovedMXCSignaled(BigInt approved) {
    claimsApprovedMXCLocked = approved;
  }

  @action
  void setClaimsRejectedMXCSignaled(BigInt rejected) {
    claimsRejectedMXCLocked = rejected;
  }

  @action
  void setClaimsTotalMXCSignaled() {
    claimsTotalMXCSignaled = claimsApprovedMXCSignaled + claimsPendingMXCSignaled + claimsRejectedMXCSignaled;
  }

  @action
  void countClaimsProportionsMXCSignaled() {
    claimsApprovedProportionsMXCSignaled = claimsApprovedMXCSignaled / claimsTotalMXCSignaled;

    claimsPendingProportionsMXCSignaled = claimsPendingMXCSignaled / claimsTotalMXCSignaled;

    claimsRejectedProportionsMXCSignaled = claimsRejectedMXCSignaled / claimsTotalMXCSignaled;
  }

  @action
  void setClaimsTotalIOTAPeggedSignaled() {
    claimsTotalIOTAPeggedSignaled = claimsApprovedIOTAPeggedSignaled + claimsPendingIOTAPeggedSignaled + claimsRejectedIOTAPeggedSignaled;
  }

  @action
  void countClaimsProportionsIOTAPeggedSignaled() {
    claimsApprovedProportionsIOTAPeggedSignaled = claimsApprovedIOTAPeggedSignaled / claimsTotalIOTAPeggedSignaled;

    claimsPendingProportionsIOTAPeggedSignaled = claimsPendingIOTAPeggedSignaled / claimsTotalIOTAPeggedSignaled;

    claimsRejectedProportionsIOTAPeggedSignaled = claimsRejectedIOTAPeggedSignaled / claimsTotalIOTAPeggedSignaled;
  }
}