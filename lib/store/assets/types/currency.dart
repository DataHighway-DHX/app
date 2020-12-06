import 'package:polka_wallet/constants.dart';
import 'package:web3dart/web3dart.dart';

class TokenCurrency {
  final String name;
  final EthereumAddress address;
  const TokenCurrency._(this.name, this.address);

  static TokenCurrency mxc = TokenCurrency._('MXC', kContractAddrMXCTestnet);
  static TokenCurrency iota =
      TokenCurrency._('IOTA', kContractAddrIOTAPeggedTestnet);
  // static const TokenCurrency dhx = TokenCurrency._('DHX');
  // static const TokenCurrency dot = TokenCurrency._('DOT');
  static List<TokenCurrency> values = [
    mxc,
    iota, /*dhx, dot*/
  ];

  @override
  String toString() {
    return name;
  }
}
