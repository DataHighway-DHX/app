import 'package:web3dart/web3dart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Account
var kMnemonicSeed = DotEnv().env['MNENOMIC'];
var kAccountAddrTestnet =
    EthereumAddress.fromHex(DotEnv().env['ETHEREUM_ADDRESS']);
//Latest 0x022478d51bF0cF12799E443ccd19527e075B6B37
//before 0x2733566693458ee7e35f63b309da864db2637dc1

// Testnet
var kRpcUrlInfuraTestnetRopsten =
    'https://ropsten.infura.io/v3/${DotEnv().env['INFURA_API_PROJECT_ID']}';
var kWsUrlInfuraTestnetRopsten =
    'wss://ropsten.infura.io/ws/v3/${DotEnv().env['INFURA_API_PROJECT_ID']}';

// FIXME - deploy contract and replace address below
final EthereumAddress kContractAddrDataHighwayMiningTestnet =
    EthereumAddress.fromHex(DotEnv().env['CONTRACT_ADDRESS_LOCKDROP_TESTNET']);
final EthereumAddress kContractAddrMXCTestnet =
    EthereumAddress.fromHex(DotEnv().env['CONTRACT_ADDRESS_MXC_TESTNET']);

// // Mainnet
// var kRpcUrlInfuraMainnet =
//     'https://mainnet.infura.io/v3/${DotEnv().env['INFURA_API_PROJECT_ID']}';
// var kWsUrlInfuraMainnet =
//     'wss://mainnet.infura.io/v3/${DotEnv().env['INFURA_API_PROJECT_ID']}';
// final EthereumAddress kContractAddrMXCTestnet =
//     EthereumAddress.fromHex('0x5Ca381bBfb58f0092df149bD3D243b08B9a8386e');
