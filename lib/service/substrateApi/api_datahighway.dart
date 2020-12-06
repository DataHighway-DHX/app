import 'dart:async';

import 'api.dart';

// {"token_token_mxc":40,"token_token_iota":1,"token_token_dot":1,"token_max_token":1,"token_max_loyalty":1}

class MsbRatesConfig {
  final double mxc;
  final double iota;
  final double dot;
  final double maxToken;
  final double maxLoyalty;

  MsbRatesConfig({
    this.mxc,
    this.iota,
    this.dot,
    this.maxToken,
    this.maxLoyalty,
  });

  factory MsbRatesConfig.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return MsbRatesConfig(
      mxc: map['token_token_mxc'].toDouble() / 1000.0,
      iota: map['token_token_iota'].toDouble() / 1000.0,
      dot: map['token_token_dot'].toDouble() / 1000.0,
      maxToken: map['token_max_token'].toDouble(),
      maxLoyalty: map['token_max_loyalty'].toDouble(),
    );
  }
}

class ApiDatahighway {
  final Api apiRoot;

  ApiDatahighway(this.apiRoot);

  Future<MsbRatesConfig> getMSBRates() async {
    final Map res = await apiRoot.connector.eval('mining.getMSBRates()');
    return MsbRatesConfig.fromMap(res);
  }
}
