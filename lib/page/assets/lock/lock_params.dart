import 'package:polka_wallet/constants.dart';
import 'package:polka_wallet/service/ethereum_api/api.dart';
import 'package:polka_wallet/store/assets/types/currency.dart';
import 'package:web3dart/credentials.dart';
import 'package:decimal/decimal.dart';

class LockParams {
  String amount = '0';
  bool isValidator = false;
  double msb;

  final ClaimType claimType = ClaimType.lock;

  LockdropTerm term = LockdropTerm.threeMo;
  TokenCurrency currency = TokenCurrency.mxc;

  EthereumAddress get contractOwnerAddress =>
      EthereumAddress.fromHex(ethereum.lockdrop.host.ethereumAddress);
  EthereumAddress currentAddress;
  EthereumAddress lockAddress;

  BigInt get parsedAmount {
    final parsedDecimal = Decimal.tryParse(amount);
    if (parsedDecimal == null) return null;

    return BigInt.parse((parsedDecimal * Decimal.parse('1000000000000000000'))
        .round()
        .toString());
  }

  bool get amountValid {
    final parsedAmount = this.parsedAmount;
    return parsedAmount != null && parsedAmount > BigInt.zero;
  }

  String get transactionMessage {
    return '${term.deserialize()},lock,$amount(amount),${currency.name}PublicKey#,${lockAddress ?? 'waiting'}';
  }
}
