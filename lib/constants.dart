import 'package:web3dart/web3dart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Account
var kSamplePrivateKey = DotEnv().env['SAMPLE_PRIVATE_KEY'];
var kSampleAccountAddrMainnet =
    EthereumAddress.fromHex('0x022478d51bF0cF12799E443ccd19527e075B6B37');
    //Latest 0x022478d51bF0cF12799E443ccd19527e075B6B37
    //before 0x2733566693458ee7e35f63b309da864db2637dc1

// Testnet
var kRpcUrlInfuraGoerli =
    'https://goerli.infura.io/v3/${DotEnv().env['INFURA_PROJECT_ID']}';
var kWsUrlInfuraGoerli =
    'wss://goerli.infura.io/v3/${DotEnv().env['INFURA_PROJECT_ID']}';

// Mainnet
var kRpcUrlInfuraMainnet =
    'https://mainnet.infura.io/v3/${DotEnv().env['INFURA_PROJECT_ID']}';
var kWsUrlInfuraMainnet =
    'wss://mainnet.infura.io/v3/${DotEnv().env['INFURA_PROJECT_ID']}';
final EthereumAddress kContractAddrMXCMainnet =
    EthereumAddress.fromHex('0x5Ca381bBfb58f0092df149bD3D243b08B9a8386e');
// FIXME - deploy contract and replace address below
final EthereumAddress kContractAddrDataHighwayMiningMainnet =
    EthereumAddress.fromHex('0x0');
