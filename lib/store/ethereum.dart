import 'package:mobx/mobx.dart';
import 'package:polka_wallet/store/app.dart';

part 'ethereum.g.dart';

class EthereumStore = _EthereumStore with _$EthereumStore;

abstract class _EthereumStore with Store {
  final store = globalAppStore;

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
  BigInt claimsTotalMXCLockedCapacity = BigInt.parse('0');

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
  BigInt claimsTotalMXCSignaledCapacity = BigInt.parse('0');

  @observable
  BigInt claimsApprovedIOTAPeggedSignaled = BigInt.parse('0');

  @observable
  BigInt claimsPendingIOTAPeggedSignaled = BigInt.parse('0');

  @observable
  BigInt claimsRejectedIOTAPeggedSignaled = BigInt.parse('0');

  @observable
  BigInt claimsTotalIOTAPeggedSignaledCapacity = BigInt.parse('0');

  @observable
  double claimsApprovedProportionsIOTAPeggedSignaled = 0;

  @observable
  double claimsPendingProportionsIOTAPeggedSignaled = 0;

  @observable
  double claimsRejectedProportionsIOTAPeggedSignaled = 0;

  @observable
  Map claimsDataMXCLocked = new Map();

  @observable
  Map claimsDataMXCSignaled = new Map();

  // Note: Do not support locking IOTA Pegged tokens

  @observable
  Map claimsDataIOTAPeggedSignaled = new Map();

  @observable
  BigInt claimsStatusMXCLocked = BigInt.parse('0');

  @observable
  BigInt claimsStatusMXCSignaled = BigInt.parse('0');

  @observable
  BigInt claimsStatusIOTAPeggedSignaled = BigInt.parse('0');

  @action
  void setBalanceMXC(BigInt balance) {
    balanceMXC = balance;
  }

  @action
  void setBalanceIOTAPegged(BigInt balance) {
    balanceIOTAPegged = balance;
  }

  @action
  void setClaimsPendingMXCLocked(BigInt pending) {
    claimsPendingMXCLocked = pending;
  }

  @action
  void setClaimsApprovedMXCLocked(BigInt approved) {
    claimsApprovedMXCLocked = approved;
  }

  @action
  void setClaimsRejectedMXCLocked(BigInt rejected) {
    claimsRejectedMXCLocked = rejected;
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
  void setClaimsStatusMXCLocked(BigInt claimsStatus) {
    claimsStatusMXCLocked = claimsStatus;
  }

  @action
  void setClaimsStatusMXCSignaled(BigInt claimsStatus) {
    claimsStatusMXCSignaled = claimsStatus;
  }

  @action
  void setClaimsStatusIOTAPeggedSignaled(BigInt claimsStatus) {
    claimsStatusIOTAPeggedSignaled = claimsStatus;
  }

  @action
  void setClaimsDataMXCLocked(Map data) {
    print('setClaimsDataMXCLocked with data ${data}');
    print(data['claimStatus'].runtimeType);
    claimsDataMXCLocked = data;

    // store.ethereum.setClaimsApprovedMXCLocked(BigInt.tryParse(data['approvedTokenERC20Amount'].toString()));
    // store.ethereum.setClaimsPendingMXCLocked(BigInt.tryParse(data['pendingTokenERC20Amount'].toString()));
    // store.ethereum.setClaimsRejectedMXCLocked(BigInt.tryParse(data['rejectedTokenERC20Amount'].toString()));

    // // Claim Finalized
    // if (data['claimStatus'].toInt() == 1 ) {
    //   print('setClaimsDataMXCLocked with claim finalized status');
    //   store.ethereum.setClaimsStatusMXCLocked(data['claimStatus']);
    // // Claim Pending
    // } else if (data['claimStatus'].toInt() == 0) {
    //   print('setClaimsDataMXCLocked with claim pending status');
    //    store.ethereum.setClaimsStatusMXCLocked(data['claimStatus']);
    // }

    // store.ethereum.setClaimsTotalMXCLockedCapacity(BigInt.tryParse(data['tokenERC20Amount'].toString()));
    // store.ethereum.countClaimsProportionsMXCLocked();

    // print('done1 $claimsApprovedMXCLocked');
  }

  @action
  void setClaimsDataMXCSignaled(Map data) {
    print('setClaimsDataMXCSignaled with data ${data}');
    claimsDataMXCSignaled = data;

    // FIXME - when this code is uncommented, for some reason it overwrites the data in the Lock row of MXC
    // in the UI, instead of the Signal row of MXC.

    store.ethereum.setClaimsApprovedMXCSignaled(BigInt.tryParse(data['approvedTokenERC20Amount'].toString()));
    store.ethereum.setClaimsPendingMXCSignaled(BigInt.tryParse(data['pendingTokenERC20Amount'].toString()));
    store.ethereum.setClaimsRejectedMXCSignaled(BigInt.tryParse(data['rejectedTokenERC20Amount'].toString()));

    // Claim Finalized
    if (data['claimStatus'].toInt() == 1 ) {
      print('setClaimsDataMXCSignaled with claim finalized status');
      store.ethereum.setClaimsStatusMXCSignaled(data['claimStatus']);
    // Claim Pending
    } else if (data['claimStatus'].toInt() == 0) {
      print('setClaimsDataMXCSignaled with claim pending status');
       store.ethereum.setClaimsStatusMXCSignaled(data['claimStatus']);
    }

    store.ethereum.setClaimsTotalMXCSignaledCapacity(BigInt.tryParse(data['tokenERC20Amount'].toString()));
    store.ethereum.countClaimsProportionsMXCSignaled();

    print('done2 $claimsDataMXCSignaled');
  }

  @action
  void setClaimsDataIOTAPeggedSignaled(Map data) {
    claimsDataIOTAPeggedSignaled = data;

    // store.ethereum.setClaimsApprovedIOTAPeggedSignaled(BigInt.tryParse(data['approvedTokenERC20Amount'].toString()));
    // store.ethereum.setClaimsPendingIOTAPeggedSignaled(BigInt.tryParse(data['pendingTokenERC20Amount'].toString()));
    // store.ethereum.setClaimsRejectedIOTAPeggedSignaled(BigInt.tryParse(data['rejectedTokenERC20Amount'].toString()));

    // // Claim Finalized
    // if (data['claimStatus'].toInt() == 1 ) {
    //   print('setClaimsDataIOTAPeggedSignaled with claim finalized status');
    //   store.ethereum.setClaimsStatusIOTAPeggedSignaled(data['claimStatus']);
    // // Claim Pending
    // } else if (data['claimStatus'].toInt() == 0) {
    //   print('setClaimsDataMXCSignaled with claim pending status');
    //    store.ethereum.setClaimsStatusIOTAPeggedSignaled(data['claimStatus']);
    // }

    // store.ethereum.setClaimsTotalIOTAPeggedSignaledCapacity(BigInt.tryParse(data['tokenERC20Amount'].toString()));
    // store.ethereum.countClaimsProportionsIOTAPeggedSignaled();
  }

  @action
  void setClaimsTotalMXCLockedCapacity(BigInt capacity) {
    claimsTotalMXCLockedCapacity = capacity;
  }

  @action
  void countClaimsProportionsMXCLocked() {
    print('countClaimsProportionsMXCLocked with: ${claimsApprovedMXCLocked} / ${claimsTotalMXCLockedCapacity}');
    claimsApprovedProportionsMXCLocked = (claimsApprovedMXCLocked.toInt() != 0) ? (claimsApprovedMXCLocked / claimsTotalMXCLockedCapacity) * 100 : 0;

    claimsPendingProportionsMXCLocked = (claimsPendingMXCLocked.toInt() != 0) ? (claimsPendingMXCLocked / claimsTotalMXCLockedCapacity) * 100 : 0;

    claimsRejectedProportionsMXCLocked = (claimsRejectedMXCLocked.toInt() != 0) ? (claimsRejectedMXCLocked / claimsTotalMXCLockedCapacity) * 100 : 0;
  }

  @action
  void setClaimsTotalMXCSignaledCapacity(BigInt capacity) {
    claimsTotalMXCSignaledCapacity = capacity;
  }

  @action
  void countClaimsProportionsMXCSignaled() {
    print('countClaimsProportionsMXCSignaled with: ${claimsApprovedMXCSignaled} / ${claimsTotalMXCSignaledCapacity}');
    claimsApprovedProportionsMXCSignaled = (claimsApprovedMXCSignaled.toInt() != 0) ? (claimsApprovedMXCSignaled / claimsTotalMXCSignaledCapacity) * 100 : 0;

    claimsPendingProportionsMXCSignaled = (claimsPendingMXCSignaled.toInt() != 0) ? (claimsPendingMXCSignaled / claimsTotalMXCSignaledCapacity) * 100 : 0;

    claimsRejectedProportionsMXCSignaled = (claimsRejectedMXCSignaled.toInt() != 0) ? (claimsRejectedMXCSignaled / claimsTotalMXCSignaledCapacity) * 100 : 0;
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
  void setClaimsTotalIOTAPeggedSignaledCapacity(BigInt capacity) {
    claimsTotalIOTAPeggedSignaledCapacity = capacity;
  }

  @action
  void countClaimsProportionsIOTAPeggedSignaled() {
    claimsApprovedProportionsIOTAPeggedSignaled = (claimsApprovedIOTAPeggedSignaled.toInt() != 0) ? (claimsApprovedIOTAPeggedSignaled / claimsTotalIOTAPeggedSignaledCapacity) * 100 : 0;

    claimsPendingProportionsIOTAPeggedSignaled = (claimsPendingIOTAPeggedSignaled.toInt() != 0) ? (claimsPendingIOTAPeggedSignaled / claimsTotalIOTAPeggedSignaledCapacity) * 100 : 0;

    claimsRejectedProportionsIOTAPeggedSignaled = (claimsRejectedIOTAPeggedSignaled.toInt() != 0) ? (claimsRejectedIOTAPeggedSignaled / claimsTotalIOTAPeggedSignaledCapacity) * 100 : 0;
  }
}