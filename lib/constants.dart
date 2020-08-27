import 'package:web3dart/web3dart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

var kEnvironment = DotEnv().env['ENVIRONMENT'];

// Account
var kMnemonicSeed = DotEnv().env['MNENOMIC'];
var kAccountAddrTestnet =
    EthereumAddress.fromHex(DotEnv().env['ETHEREUM_ADDRESS']);
//Latest 0x022478d51bF0cF12799E443ccd19527e075B6B37
//before 0x2733566693458ee7e35f63b309da864db2637dc1
var kGasLimitRecommended = '200000';
var kGasPriceRecommended = '30';

// Testnet
var kRpcUrlInfuraTestnetRopsten =
    'https://ropsten.infura.io/v3/${DotEnv().env['INFURA_API_PROJECT_ID']}';
var kWsUrlInfuraTestnetRopsten =
    'wss://ropsten.infura.io/ws/v3/${DotEnv().env['INFURA_API_PROJECT_ID']}';
final EthereumAddress kContractAddrDataHighwayLockdropTestnet =
    EthereumAddress.fromHex(DotEnv().env['CONTRACT_ADDRESS_LOCKDROP_TESTNET']);
final EthereumAddress kContractAddrMXCTestnet =
    EthereumAddress.fromHex(DotEnv().env['CONTRACT_ADDRESS_MXC_TESTNET']);
// TODO - add address of IOTA Pegged ERC20 contract to .env file
final EthereumAddress kContractAddrIOTAPeggedTestnet = EthereumAddress.fromHex(
    DotEnv().env['CONTRACT_ADDRESS_IOTA_PEGGED_TESTNET']);
var kAbiCodeFileMXC = "abi_mxc.json";
var kAbiCodeFileDataHighwayLockdropTestnet =
    "abi_datahighway_lockdrop_testnet.json";
// TODO - deploy IOTA Pegged ERC20 contract and copy ABI into JSON file
var kAbiCodeFileDataHighwayIOTAPeggedTestnet =
    "abi_datahighway_iota_pegged_testnet.json";

const demoUsername = 'aaaaaqwer1234';
const demoPassword = 'aaaaaqwer1234';

// // Mainnet
// var kRpcUrlInfuraMainnet =
//     'https://mainnet.infura.io/v3/${DotEnv().env['INFURA_API_PROJECT_ID']}';
// var kWsUrlInfuraMainnet =
//     'wss://mainnet.infura.io/v3/${DotEnv().env['INFURA_API_PROJECT_ID']}';
// final EthereumAddress kContractAddrDataHighwayLockdropMainnet =
//     EthereumAddress.fromHex(DotEnv().env['CONTRACT_ADDRESS_LOCKDROP_MAINNET']);
// final EthereumAddress kContractAddrMXCMainnet =
//     EthereumAddress.fromHex(DotEnv().env['CONTRACT_ADDRESS_MXC_MAINNET']);
// final EthereumAddress kContractAddrIOTAPeggedMainnet =
//     EthereumAddress.fromHex(DotEnv().env['CONTRACT_ADDRESS_IOTA_PEGGED_MAINNET']);
// Note: kAbiCodeFileMXC is same for both testnet and mainnet
// var kAbiCodeFileDataHighwayLockdropMainnet = "abi_datahighway_lockdrop_mainnet.json";
// var kAbiCodeFileDataHighwayIOTAPeggedMainnet = "abi_datahighway_iota_pegged_mainnet.json";
