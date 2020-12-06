import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:polka_wallet/store/assets/types/currency.dart';
import 'package:web3dart/web3dart.dart';

import 'model.dart';
import 'package:http/http.dart' as http;

class DeployerApi {
  final DeployerHostInfo host;

  DeployerApi(this.host);

  void _handleError(http.Response res) {
    if (res.statusCode < 200 || res.statusCode >= 300) {
      String message;
      String name;
      try {
        final json = jsonDecode(res.body);
        message = json['message'];
        name = json['errorCode'];
      } catch (_) {}
      name ??= 'unknown';
      message ??= res.body;
      throw DeployerException(name, message);
    }
  }

  Future<void> signal({
    @required LockdropTerm term,
    @required BigInt amount,
    @required String dhxPublicKey,
    @required TokenCurrency token,
  }) async {
    final tokenName = token.name;
    final res = await http.post('${host.url}/lockdrop/signal', body: {
      'token': tokenName.toLowerCase(),
      'dhxPublicKey': dhxPublicKey,
      'term': term.index.toString(),
      'amount': amount.toString(),
    });
    _handleError(res);
    final json = jsonDecode(res.body);
    return json['transactionHash'];
  }

  Future<String> lock({
    @required EthereumAddress sender,
    @required LockdropTerm term,
    @required BigInt amount,
    @required String dhxPublicKey,
    @required TokenCurrency token,
    @required bool useValidator,
  }) async {
    final tokenName = token.name;
    final res = await http.post('${host.url}/lockdrop/lock', body: {
      'token': tokenName.toLowerCase(),
      'dhxPublicKey': dhxPublicKey,
      'term': term.index.toString(),
      'amount': amount.toString(),
      'sender': sender.hex,
      'useValidator': useValidator.toString(),
    });
    _handleError(res);
    final json = jsonDecode(res.body);
    return json['transactionHash'];
  }

  Future<String> claim({
    @required String transactionHash,
  }) async {
    Uri uri;
    final authority = host.url.split('//')[1];
    if (host.scheme == 'http') {
      uri = Uri.http(authority, '/lockdrop/claim', {
        'transactionHash': transactionHash,
      });
    } else {
      uri = Uri.https(authority, '/lockdrop/claim', {
        'transactionHash': transactionHash,
      });
    }
    final res = await http.get(uri);
    _handleError(res);
    final json = jsonDecode(res.body);
    return json['transactionHash'];
  }

  Future<Claim> getClaim({
    @required String transactionHash,
  }) async {
    Uri uri;
    final authority = host.url.split('//')[1];
    if (host.scheme == 'http') {
      uri = Uri.http(authority, '/lockdrop/getClaim', {
        'transactionHash': transactionHash,
      });
    } else {
      uri = Uri.https(authority, '/lockdrop/getClaim', {
        'transactionHash': transactionHash,
      });
    }
    final res = await http.get(uri);
    _handleError(res);
    final json = jsonDecode(res.body);
    return Claim.fromMap(json);
  }

  Future<List<Claim>> getAllClaims({
    @required String dhxPublicKey,
  }) async {
    Uri uri;
    final authority = host.url.split('//')[1];
    if (host.scheme == 'http') {
      uri = Uri.http(authority, '/lockdrop/allClaims', {
        'dhxPublicKey': dhxPublicKey,
      });
    } else {
      uri = Uri.https(authority, '/lockdrop/allClaims', {
        'dhxPublicKey': dhxPublicKey,
      });
    }
    final res = await http.get(uri);
    _handleError(res);
    final json = jsonDecode(res.body) as List;
    return json
        .map((t) => Claim.fromMap(Map<String, dynamic>.from(t)))
        .toList();
  }
}
