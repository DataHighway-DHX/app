import 'package:polka_wallet/service/ethereumApi/contract.dart';
import 'package:web3dart/web3dart.dart';

import 'api.dart';

class MxcTokenApi extends BaseContractApi {
  MxcTokenApi(ContractAbiProvider abiProvider, EthereumAddress contractAddress,
      EthereumApi ethereumApi)
      : super(abiProvider, contractAddress, ethereumApi);

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
