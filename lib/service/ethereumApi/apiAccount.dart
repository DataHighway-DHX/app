import 'package:web3dart/web3dart.dart';

import '../../constants.dart';

class EthereumApiAccount {
  EthereumApiAccount();

  EthereumAddress ownAddress;

  EthereumAddress getOwnAddress() {
    // TODO - ask user to first provide their Ethereum account address (or scan via QR code)
    // Create Credential from private key
//    final credentials = await client.credentialsFromPrivateKey(privateKey);
    // Derive the public key and the address from a private key
//    final ownAddress = await credentials.extractAddress();
    ownAddress = kSampleAccountAddrMainnet;
    return ownAddress;
  }
}
