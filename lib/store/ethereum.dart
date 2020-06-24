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
  void setClaimsDataMXCLocked(Map data) {
    print('setClaimsDataMXCLocked with data ${data}');
    // print(data['claimStatus'].runtimeType);
    claimsDataMXCLocked = data;

    // Claim Rejected
    if (data['claimStatus'].toInt() == 2 ) {
      print('setClaimsDataMXCLocked with rejected status ${data['approvedTokenERC20Amount']}');
      store.ethereum.setClaimsPendingMXCLocked(BigInt.parse('0'));
      store.ethereum.setClaimsApprovedMXCLocked(BigInt.parse('0'));
      store.ethereum.setClaimsRejectedMXCLocked(BigInt.tryParse(data['approvedTokenERC20Amount'].toString()));
    // Claim Pending
    } else if (data['claimStatus'].toInt() == 0) {
      print('setClaimsDataMXCLocked with pending status ${data['approvedTokenERC20Amount']}');
      store.ethereum.setClaimsPendingMXCLocked(BigInt.tryParse(data['approvedTokenERC20Amount'].toString()));
      store.ethereum.setClaimsApprovedMXCLocked(BigInt.parse('0'));
      store.ethereum.setClaimsRejectedMXCLocked(BigInt.parse('0'));
    // Claim Approved
    } else if (data['claimStatus'].toInt() == 1) {
      print('setClaimsDataMXCLocked with approved status ${data['approvedTokenERC20Amount']}');
      // If approved, the proportion not approved is pending
      store.ethereum.setClaimsPendingMXCLocked(BigInt.tryParse((data['tokenERC20Amount'] - data['approvedTokenERC20Amount']).toString()));
      store.ethereum.setClaimsApprovedMXCLocked(BigInt.tryParse(data['approvedTokenERC20Amount'].toString()));
      store.ethereum.setClaimsRejectedMXCLocked(BigInt.parse('0'));
    }

    store.ethereum.setClaimsTotalMXCLockedCapacity(BigInt.tryParse(data['tokenERC20Amount'].toString()));
    store.ethereum.countClaimsProportionsMXCLocked();

    print('done1 $claimsApprovedMXCLocked');
  }

  @action
  void setClaimsDataMXCSignaled(Map data) {
    print('setClaimsDataMXCSignaled with data ${data}');
    claimsDataMXCSignaled = data;

    // FIXME - when this code is uncommented, for some reason it overwrites the data in the Lock row of MXC
    // in the UI, instead of the Signal row of MXC.
    // // Claim Rejected
    // if (data['claimStatus'].toInt() == 2) {
    //   print('setClaimsDataMXCSignaled with rejected status ${data['approvedTokenERC20Amount']}');
    //   store.ethereum.setClaimsPendingMXCSignaled(BigInt.parse('0'));
    //   store.ethereum.setClaimsApprovedMXCSignaled(BigInt.parse('0'));
    //   store.ethereum.setClaimsRejectedMXCSignaled(BigInt.tryParse(data['approvedTokenERC20Amount'].toString()));
    // // Claim Pending
    // } else if (data['claimStatus'].toInt() == 0) {
    //   print('setClaimsDataMXCSignaled with pending status ${data['approvedTokenERC20Amount']}');
    //   store.ethereum.setClaimsPendingMXCSignaled(BigInt.tryParse(data['approvedTokenERC20Amount'].toString()));
    //   store.ethereum.setClaimsApprovedMXCSignaled(BigInt.parse('0'));
    //   store.ethereum.setClaimsRejectedMXCSignaled(BigInt.parse('0'));
    // // Claim Approved
    // } else if (data['claimStatus'].toInt() == 1) {
    //   print('setClaimsDataMXCSignaled with approved status ${data['approvedTokenERC20Amount']}');
    //   // If approved, the proportion not approved is pending
    //   store.ethereum.setClaimsPendingMXCSignaled(BigInt.tryParse((data['tokenERC20Amount'] - data['approvedTokenERC20Amount']).toString()));
    //   store.ethereum.setClaimsApprovedMXCSignaled(BigInt.tryParse(data['approvedTokenERC20Amount'].toString()));
    //   store.ethereum.setClaimsRejectedMXCSignaled(BigInt.parse('0'));
    // }

    // store.ethereum.setClaimsTotalMXCSignaledCapacity(BigInt.tryParse(data['tokenERC20Amount'].toString()));
    // store.ethereum.countClaimsProportionsMXCSignaled();

    // print('done2 $claimsDataMXCSignaled');
  }

  @action
  void setClaimsDataIOTAPeggedSignaled(Map data) {
    claimsDataIOTAPeggedSignaled = data;

    // TODO - update to be similar to `setClaimsDataMXCSignaled` once we resolve why the lock approved data (except for the proportion)
    // no longer appears in the UI momentarily if we run `setClaimsDataMXCSignaled` after running `setClaimsDataMXCLocked` 
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