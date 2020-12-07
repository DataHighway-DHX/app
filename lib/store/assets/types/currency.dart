import 'package:polka_wallet/service/ethereum_api/api.dart';
import 'package:web3dart/web3dart.dart';

class TokenCurrency {
  final String name;
  final EthereumAddress address;
  const TokenCurrency._(this.name, this.address);

  static TokenCurrency get mxc =>
      TokenCurrency._('MXC', ethereum.mxcToken.contractAddress);
  static TokenCurrency get iota =>
      TokenCurrency._('IOTA', ethereum.iotaToken.contractAddress);
  // static const TokenCurrency dhx = TokenCurrency._('DHX');
  // static const TokenCurrency dot = TokenCurrency._('DOT');

  static List<TokenCurrency> get values => [
        mxc,
        iota, /*dhx, dot*/
      ];

  @override
  bool operator ==(other) {
    return other is TokenCurrency &&
        other.name == this.name &&
        other.address == this.address;
  }

  @override
  int get hashCode {
    int result = 17;
    result = 37 * result + name.hashCode;
    result = 37 * result + address.hashCode;
    return result;
  }

  @override
  String toString() {
    return name;
  }
}
