import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';
import 'api.dart';

abstract class ContractAbiProvider {
  String get name;
  Future<String> getAbiCode();

  factory ContractAbiProvider.fromAsset(String name, String path) {
    return _ContractAbiProviderAsset(name, path);
  }
}

class _ContractAbiProviderAsset implements ContractAbiProvider {
  final String assetPath;
  final String name;
  String _abi;

  _ContractAbiProviderAsset(this.name, this.assetPath);
  Future<String> getAbiCode() async {
    _abi ??= await rootBundle.loadString(assetPath);
    return _abi;
  }
}

abstract class BaseContractApi {
  final EthereumAddress contractAddress;
  final ContractAbiProvider abiProvider;
  final EthereumApi _ethereumApi;
  Web3Client _cachedClient;

  BaseContractApi(
      this.abiProvider, this.contractAddress, EthereumApi ethereumApi)
      : _ethereumApi = ethereumApi;

  Future<String> _abiCode() async {
    return await abiProvider.getAbiCode();
  }

  Future<Web3Client> getClient() async {
    if (_cachedClient != null) return _cachedClient;
    Web3Client client = await _ethereumApi.connectToWeb3EthereumClient();
    _cachedClient = client;
    return client;
  }

  Future<DeployedContract> getContract() async {
    final abiCode = await _abiCode();
    return DeployedContract(
      ContractAbi.fromJson(abiCode, abiProvider.name),
      contractAddress,
    );
  }

  Future<void> dispose() async {
    await _cachedClient?.dispose();
  }
}
