import 'package:decimal/decimal.dart';

import 'model.dart';

extension EthereumExtensions on BigInt {
  Decimal toDecimal() {
    return Decimal.tryParse(this.toString()) /
        Decimal.parse('1000000000000000000');
  }
}

extension LockdropTermExtensions on LockdropTerm {
  BigInt deserialize() {
    return BigInt.from(LockdropTerm.values.indexOf(this));
  }

  int get months {
    switch (this) {
      case LockdropTerm.threeMo:
        return 3;
      case LockdropTerm.sixMo:
        return 6;
      case LockdropTerm.nineMo:
        return 9;
      case LockdropTerm.twelveMo:
        return 12;
      case LockdropTerm.twentyFourMo:
        return 24;
      case LockdropTerm.thirtySixMo:
        return 36;
      default:
        return null;
    }
  }
}
