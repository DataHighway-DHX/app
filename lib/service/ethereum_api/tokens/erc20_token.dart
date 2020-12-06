import 'package:web3dart/web3dart.dart';
import '../api.dart';
import '../contract.dart';

class Erc20TokenApi extends BaseContractApi {
  Erc20TokenApi(ContractAbiProvider abiProvider,
      EthereumAddress contractAddress, EthereumApi ethereumApi)
      : super(abiProvider, contractAddress, ethereumApi);

  /// Gets balance with 18 decimals (divide on 1000000000000000000)
  Future<BigInt> balanceOf(EthereumAddress address) async {
    final client = await getClient();
    final contract = await getContract();
    final response = await client.call(
        contract: contract,
        function: contract.function('balanceOf'),
        params: [address]);
    return response[0];
  }
}
