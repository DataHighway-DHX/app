import 'package:polka_wallet/constants.dart';
import 'package:polka_wallet/service/ethereumApi/model.dart';
import 'package:web3dart/credentials.dart';
import 'package:decimal/decimal.dart';

class LockParams {
  String amount = '0';
  bool isValidator = false;
  LockdropTerm term = LockdropTerm.threeMo;
  LockCurrency currency = LockCurrency.mxc;

  EthereumAddress get currentAddress => kAccountAddrTestnet;
  BigInt get parsedAmount {
    final parsedDecimal = Decimal.tryParse(amount);
    if (parsedDecimal == null) return null;

    return BigInt.parse((parsedDecimal * Decimal.parse('1000000000000000000'))
        .round()
        .toString());
  }

  String get transactionMessage {
    return '${term.deserialize()},lock,$amount(amount),${currency.name}PublicKey#,$currentAddress';
  }
}

class LockCurrency {
  final String name;
  final EthereumAddress address;
  const LockCurrency._(this.name, this.address);

  static LockCurrency mxc = LockCurrency._('MXC', kContractAddrMXCTestnet);
  static LockCurrency iota =
      LockCurrency._('IOTA', kContractAddrIOTAPeggedTestnet);
  // static const LockCurrency dhx = LockCurrency._('DHX');
  // static const LockCurrency dot = LockCurrency._('DOT');
  static List<LockCurrency> values = [
    mxc,
    iota, /*dhx, dot*/
  ];

  @override
  String toString() {
    return name;
  }
}
