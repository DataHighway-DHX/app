import 'package:decimal/decimal.dart';
import 'package:polka_wallet/constants.dart';
import 'package:polka_wallet/service/ethereum_api/api.dart';
import 'package:polka_wallet/store/assets/types/currency.dart';
import 'package:web3dart/credentials.dart';

class SignalParams {
  String amount = '0';
  double msb;
  final ClaimType claimType = ClaimType.signal;

  LockdropTerm term = LockdropTerm.threeMo;
  TokenCurrency currency = TokenCurrency.mxc;

  EthereumAddress contractAddress;
  EthereumAddress get currentAddress => kAccountAddrTestnet;
  BigInt get parsedAmount {
    final parsedDecimal = Decimal.tryParse(amount);
    if (parsedDecimal == null) return null;

    return BigInt.parse((parsedDecimal * Decimal.parse('1000000000000000000'))
        .round()
        .toString());
  }

  String get transactionMessage {
    return '${term.deserialize()},signal,$amount(amount),${currency.name}PublicKey#,${contractAddress ?? 'waiting'}';
  }
}
