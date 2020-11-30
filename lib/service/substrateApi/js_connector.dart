import 'dart:async';
import 'dart:convert';

import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:polka_wallet/common/logging.dart';

class EvalInfo {
  final String call;
  final Completer completer;

  EvalInfo(this.call, this.completer);
}

class JsConnector {
  static const _loggerTopic = 'js-connector';

  final Map<String, Function> _msgHandlers = {};
  final Map<int, EvalInfo> _msgCompleters = {};

  Map<int, EvalInfo> get debugCompleters => _msgCompleters;

  final FlutterWebviewPlugin _web;
  JsConnector(this._web);

  int _counter = DateTime.now().millisecondsSinceEpoch;

  int _getFreeCallNumber() {
    return _counter++;
  }

  String _getCallName(String code) {
    return code.split('(')[0];
  }

  void defineHandler(String name, void Function(dynamic) callback) {
    _msgHandlers[name] = callback;
  }

  void resetCompleters() {
    _msgCompleters.clear();
  }

  void onMessageReceived(JavascriptMessage message) {
    log(_loggerTopic, 'received msg: ${message.message}');
    try {
      final msg = jsonDecode(message.message);
      final int uid = msg['uid'];
      final String path = msg['call'];

      if (_msgCompleters[uid] != null) {
        final completer = _msgCompleters[uid].completer;

        if (msg['status'] == 'success') {
          completer.complete(msg['data']);
        } else {
          completer.completeError(msg['data']);
        }
      }

      if (_msgHandlers[path] != null) {
        Function handler = _msgHandlers[path];
        handler(msg['data']);
      }
    } catch (e) {
      log(_loggerTopic, 'bad json: $e');
    }
  }

  Future<dynamic> eval(
    String code, {
    bool direct = false,
    bool allowRepeat = false,
  }) async {
    final call = _getCallName(code);
    log(_loggerTopic, 'eval: $call');
    if (!allowRepeat) {
      final evalInfo = _msgCompleters.values
          .firstWhere((c) => c.call == call, orElse: () => null);
      if (evalInfo != null) return evalInfo.completer.future;
    }

    if (direct) {
      String res = await _web.evalJavascript(code);
      return res;
    }

    Completer c = new Completer();

    final uid = _getFreeCallNumber();
    //String method = 'uid=$uid;${code.split('(')[0]}';
    final evalInfo = EvalInfo(call, c);
    _msgCompleters[uid] = evalInfo;

    String script = '''
    try {
      $code.then(function(res) {
          PolkaWallet.postMessage(JSON.stringify({ 
            path: "$call", status: "success", data: res, uid: $uid
          }));
        }).catch(function(err) {
          PolkaWallet.postMessage(JSON.stringify({ 
            path: "$call", status: "error", data: err.message, uid: $uid
          }));
        })
    } catch (e) {
      PolkaWallet.postMessage(JSON.stringify({ 
        path: "$call", status: "error", data: e, uid: $uid
      }));
    }
    ''';
    await _web.evalJavascript(script);

    return c.future;
  }
}
