import 'package:web3dart/web3dart.dart';
import '../api.dart';
import '../contract.dart';
import 'erc20_token.dart';

class IotaTokenApi extends Erc20TokenApi {
  IotaTokenApi(ContractAbiProvider abiProvider, EthereumAddress contractAddress,
      EthereumApi ethereumApi)
      : super(abiProvider, contractAddress, ethereumApi);
}
