import 'package:decimal/decimal.dart';
import 'package:polka_wallet/constants.dart';
import 'package:polka_wallet/service/ethereumApi/model.dart';
import 'package:web3dart/credentials.dart';

class SignalParams {
  String amount = '0';
  LockdropTerm term = LockdropTerm.threeMo;
  SignalCurrency currency = SignalCurrency.mxc;

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

class SignalCurrency {
  final String name;
  final EthereumAddress address;
  const SignalCurrency._(this.name, this.address);

  static SignalCurrency mxc = SignalCurrency._('MXC', kContractAddrMXCTestnet);
  static SignalCurrency iota =
      SignalCurrency._('IOTA', kContractAddrIOTAPeggedTestnet);
  // static const LockCurrency dhx = LockCurrency._('DHX');
  // static const LockCurrency dot = LockCurrency._('DOT');
  static List<SignalCurrency> values = [
    mxc,
    iota, /*dhx, dot*/
  ];

  @override
  String toString() {
    return name;
  }
}
