import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:polka_wallet/service/substrateApi/js_connector.dart';

class WebviewManager {
  FlutterWebviewPlugin _web;
  JsConnector _connector;
  StreamSubscription _subscription;
  bool _launched = false;

  VoidCallback onLoaded;

  JsConnector get connector => _connector;
  bool get launched => _launched;

  Future<void> reload() async {
    _connector.resetCompleters();
    await _web.reload();
  }

  Future<void> launch() async {
    if (launched) throw Exception('Can' 't launch twice');
    _launched = true;
    if (_web != null) {
      _connector.resetCompleters();
      await _web.reload();
      return;
    }

    _web = FlutterWebviewPlugin();
    _connector = JsConnector(_web);

    _subscription = _web.onStateChanged.listen((viewState) async {
      if (viewState.type == WebViewState.finishLoad) {
        onLoaded();
      }
    });

    await _web.launch(
      'about:blank',
      javascriptChannels: [
        JavascriptChannel(
          name: 'PolkaWallet',
          onMessageReceived: (JavascriptMessage message) async {
            _connector.onMessageReceived(message);
          },
        ),
      ].toSet(),
      ignoreSSLErrors: true,
      hidden: true,
    );
  }

  void dispose() {
    _subscription?.cancel();
  }
}
