// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AppStore on _AppStore, Store {
  final _$accountAtom = Atom(name: '_AppStore.account');

  @override
  AccountStore get account {
    _$accountAtom.reportRead();
    return super.account;
  }

  @override
  set account(AccountStore value) {
    _$accountAtom.reportWrite(value, super.account, () {
      super.account = value;
    });
  }

  final _$assetsAtom = Atom(name: '_AppStore.assets');

  @override
  AssetsStore get assets {
    _$assetsAtom.reportRead();
    return super.assets;
  }

  @override
  set assets(AssetsStore value) {
    _$assetsAtom.reportWrite(value, super.assets, () {
      super.assets = value;
    });
  }

  final _$stakingAtom = Atom(name: '_AppStore.staking');

  @override
  StakingStore get staking {
    _$stakingAtom.reportRead();
    return super.staking;
  }

  @override
  set staking(StakingStore value) {
    _$stakingAtom.reportWrite(value, super.staking, () {
      super.staking = value;
    });
  }

  final _$govAtom = Atom(name: '_AppStore.gov');

  @override
  GovernanceStore get gov {
    _$govAtom.reportRead();
    return super.gov;
  }

  @override
  set gov(GovernanceStore value) {
    _$govAtom.reportWrite(value, super.gov, () {
      super.gov = value;
    });
  }

  final _$settingsAtom = Atom(name: '_AppStore.settings');

  @override
  SettingsStore get settings {
    _$settingsAtom.reportRead();
    return super.settings;
  }

  @override
  set settings(SettingsStore value) {
    _$settingsAtom.reportWrite(value, super.settings, () {
      super.settings = value;
    });
  }

  final _$isReadyAtom = Atom(name: '_AppStore.isReady');

  @override
  bool get isReady {
    _$isReadyAtom.reportRead();
    return super.isReady;
  }

  @override
  set isReady(bool value) {
    _$isReadyAtom.reportWrite(value, super.isReady, () {
      super.isReady = value;
    });
  }

  final _$ethereumAtom = Atom(name: '_AppStore.ethereum');

  @override
  EthereumStore get ethereum {
    _$ethereumAtom.reportRead();
    return super.ethereum;
  }

  @override
  set ethereum(EthereumStore value) {
    _$ethereumAtom.reportWrite(value, super.ethereum, () {
      super.ethereum = value;
    });
  }

  final _$initAsyncAction = AsyncAction('_AppStore.init');

  @override
  Future<void> init(String sysLocaleCode) {
    return _$initAsyncAction.run(() => super.init(sysLocaleCode));
  }

  @override
  String toString() {
    return '''
account: ${account},
assets: ${assets},
staking: ${staking},
gov: ${gov},
settings: ${settings},
isReady: ${isReady},
ethereum: ${ethereum}
    ''';
  }
}
