import 'dart:async' show Future;

import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'package:web_socket_channel/io.dart';

class EthereumApi {
  EthereumApi({this.rpcUrl, this.wsUrl});

  final String rpcUrl;
  final String wsUrl;
  Web3Client client;

  // Establish connection to the Ethereum RPC node using socketConnector
  // for event streams over websockets instead of http-polls.
  // Note that the socketConnector property is experimental.
  Future<Web3Client> connectToWeb3EthereumClient() async {
    return client = Web3Client(this.rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(this.wsUrl).cast<String>();
    });
  }
}
