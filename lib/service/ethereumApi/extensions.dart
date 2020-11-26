import 'package:decimal/decimal.dart';

extension EthereumExtensions on BigInt {
  Decimal toMxcAmount() {
    return Decimal.tryParse(this.toString()) /
        Decimal.parse('1000000000000000000');
  }
}
