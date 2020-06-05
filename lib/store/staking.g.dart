// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staking.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$StakingStore on _StakingStore, Store {
  Computed<ObservableList<String>> _$nextUpsComputed;

  @override
  ObservableList<String> get nextUps => (_$nextUpsComputed ??=
          Computed<ObservableList<String>>(() => super.nextUps,
              name: '_StakingStore.nextUps'))
      .value;
  Computed<ObservableList<ValidatorData>> _$nominatingListComputed;

  @override
  ObservableList<ValidatorData> get nominatingList =>
      (_$nominatingListComputed ??= Computed<ObservableList<ValidatorData>>(
              () => super.nominatingList,
              name: '_StakingStore.nominatingList'))
          .value;
  Computed<int> _$accountUnlockingTotalComputed;

  @override
  int get accountUnlockingTotal => (_$accountUnlockingTotalComputed ??=
          Computed<int>(() => super.accountUnlockingTotal,
              name: '_StakingStore.accountUnlockingTotal'))
      .value;
  Computed<int> _$accountRewardTotalComputed;

  @override
  int get accountRewardTotal => (_$accountRewardTotalComputed ??= Computed<int>(
          () => super.accountRewardTotal,
          name: '_StakingStore.accountRewardTotal'))
      .value;

  final _$cacheTxsTimestampAtom = Atom(name: '_StakingStore.cacheTxsTimestamp');

  @override
  int get cacheTxsTimestamp {
    _$cacheTxsTimestampAtom.reportRead();
    return super.cacheTxsTimestamp;
  }

  @override
  set cacheTxsTimestamp(int value) {
    _$cacheTxsTimestampAtom.reportWrite(value, super.cacheTxsTimestamp, () {
      super.cacheTxsTimestamp = value;
    });
  }

  final _$overviewAtom = Atom(name: '_StakingStore.overview');

  @override
  ObservableMap<String, dynamic> get overview {
    _$overviewAtom.reportRead();
    return super.overview;
  }

  @override
  set overview(ObservableMap<String, dynamic> value) {
    _$overviewAtom.reportWrite(value, super.overview, () {
      super.overview = value;
    });
  }

  final _$doneAtom = Atom(name: '_StakingStore.done');

  @override
  bool get done {
    _$doneAtom.reportRead();
    return super.done;
  }

  @override
  set done(bool value) {
    _$doneAtom.reportWrite(value, super.done, () {
      super.done = value;
    });
  }

  final _$stakedAtom = Atom(name: '_StakingStore.staked');

  @override
  int get staked {
    _$stakedAtom.reportRead();
    return super.staked;
  }

  @override
  set staked(int value) {
    _$stakedAtom.reportWrite(value, super.staked, () {
      super.staked = value;
    });
  }

  final _$nominatorCountAtom = Atom(name: '_StakingStore.nominatorCount');

  @override
  int get nominatorCount {
    _$nominatorCountAtom.reportRead();
    return super.nominatorCount;
  }

  @override
  set nominatorCount(int value) {
    _$nominatorCountAtom.reportWrite(value, super.nominatorCount, () {
      super.nominatorCount = value;
    });
  }

  final _$validatorsInfoAtom = Atom(name: '_StakingStore.validatorsInfo');

  @override
  ObservableList<ValidatorData> get validatorsInfo {
    _$validatorsInfoAtom.reportRead();
    return super.validatorsInfo;
  }

  @override
  set validatorsInfo(ObservableList<ValidatorData> value) {
    _$validatorsInfoAtom.reportWrite(value, super.validatorsInfo, () {
      super.validatorsInfo = value;
    });
  }

  final _$nextUpsInfoAtom = Atom(name: '_StakingStore.nextUpsInfo');

  @override
  ObservableList<ValidatorData> get nextUpsInfo {
    _$nextUpsInfoAtom.reportRead();
    return super.nextUpsInfo;
  }

  @override
  set nextUpsInfo(ObservableList<ValidatorData> value) {
    _$nextUpsInfoAtom.reportWrite(value, super.nextUpsInfo, () {
      super.nextUpsInfo = value;
    });
  }

  final _$ledgerAtom = Atom(name: '_StakingStore.ledger');

  @override
  ObservableMap<String, dynamic> get ledger {
    _$ledgerAtom.reportRead();
    return super.ledger;
  }

  @override
  set ledger(ObservableMap<String, dynamic> value) {
    _$ledgerAtom.reportWrite(value, super.ledger, () {
      super.ledger = value;
    });
  }

  final _$txsAtom = Atom(name: '_StakingStore.txs');

  @override
  ObservableList<Map<dynamic, dynamic>> get txs {
    _$txsAtom.reportRead();
    return super.txs;
  }

  @override
  set txs(ObservableList<Map<dynamic, dynamic>> value) {
    _$txsAtom.reportWrite(value, super.txs, () {
      super.txs = value;
    });
  }

  final _$rewardsChartDataCacheAtom =
      Atom(name: '_StakingStore.rewardsChartDataCache');

  @override
  ObservableMap<String, dynamic> get rewardsChartDataCache {
    _$rewardsChartDataCacheAtom.reportRead();
    return super.rewardsChartDataCache;
  }

  @override
  set rewardsChartDataCache(ObservableMap<String, dynamic> value) {
    _$rewardsChartDataCacheAtom.reportWrite(value, super.rewardsChartDataCache,
        () {
      super.rewardsChartDataCache = value;
    });
  }

  final _$stakesChartDataCacheAtom =
      Atom(name: '_StakingStore.stakesChartDataCache');

  @override
  ObservableMap<String, dynamic> get stakesChartDataCache {
    _$stakesChartDataCacheAtom.reportRead();
    return super.stakesChartDataCache;
  }

  @override
  set stakesChartDataCache(ObservableMap<String, dynamic> value) {
    _$stakesChartDataCacheAtom.reportWrite(value, super.stakesChartDataCache,
        () {
      super.stakesChartDataCache = value;
    });
  }

  final _$clearTxsAsyncAction = AsyncAction('_StakingStore.clearTxs');

  @override
  Future<void> clearTxs() {
    return _$clearTxsAsyncAction.run(() => super.clearTxs());
  }

  final _$addTxsAsyncAction = AsyncAction('_StakingStore.addTxs');

  @override
  Future<void> addTxs(List<Map<dynamic, dynamic>> ls,
      {bool shouldCache = false}) {
    return _$addTxsAsyncAction
        .run(() => super.addTxs(ls, shouldCache: shouldCache));
  }

  final _$loadAccountCacheAsyncAction =
      AsyncAction('_StakingStore.loadAccountCache');

  @override
  Future<void> loadAccountCache() {
    return _$loadAccountCacheAsyncAction.run(() => super.loadAccountCache());
  }

  final _$loadCacheAsyncAction = AsyncAction('_StakingStore.loadCache');

  @override
  Future<void> loadCache() {
    return _$loadCacheAsyncAction.run(() => super.loadCache());
  }

  final _$_StakingStoreActionController =
      ActionController(name: '_StakingStore');

  @override
  void setValidatorsInfo(Map<String, dynamic> data, {bool shouldCache = true}) {
    final _$actionInfo = _$_StakingStoreActionController.startAction(
        name: '_StakingStore.setValidatorsInfo');
    try {
      return super.setValidatorsInfo(data, shouldCache: shouldCache);
    } finally {
      _$_StakingStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setNextUpsInfo(dynamic list) {
    final _$actionInfo = _$_StakingStoreActionController.startAction(
        name: '_StakingStore.setNextUpsInfo');
    try {
      return super.setNextUpsInfo(list);
    } finally {
      _$_StakingStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setOverview(Map<String, dynamic> data, {bool shouldCache = true}) {
    final _$actionInfo = _$_StakingStoreActionController.startAction(
        name: '_StakingStore.setOverview');
    try {
      return super.setOverview(data, shouldCache: shouldCache);
    } finally {
      _$_StakingStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLedger(String pubKey, Map<String, dynamic> data,
      {bool shouldCache = true, bool reset = false}) {
    final _$actionInfo = _$_StakingStoreActionController.startAction(
        name: '_StakingStore.setLedger');
    try {
      return super
          .setLedger(pubKey, data, shouldCache: shouldCache, reset: reset);
    } finally {
      _$_StakingStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearState() {
    final _$actionInfo = _$_StakingStoreActionController.startAction(
        name: '_StakingStore.clearState');
    try {
      return super.clearState();
    } finally {
      _$_StakingStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setRewardsChartData(String validatorId, Map<dynamic, dynamic> data) {
    final _$actionInfo = _$_StakingStoreActionController.startAction(
        name: '_StakingStore.setRewardsChartData');
    try {
      return super.setRewardsChartData(validatorId, data);
    } finally {
      _$_StakingStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setStakesChartData(String validatorId, Map<dynamic, dynamic> data) {
    final _$actionInfo = _$_StakingStoreActionController.startAction(
        name: '_StakingStore.setStakesChartData');
    try {
      return super.setStakesChartData(validatorId, data);
    } finally {
      _$_StakingStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
cacheTxsTimestamp: ${cacheTxsTimestamp},
overview: ${overview},
done: ${done},
staked: ${staked},
nominatorCount: ${nominatorCount},
validatorsInfo: ${validatorsInfo},
nextUpsInfo: ${nextUpsInfo},
ledger: ${ledger},
txs: ${txs},
rewardsChartDataCache: ${rewardsChartDataCache},
stakesChartDataCache: ${stakesChartDataCache},
nextUps: ${nextUps},
nominatingList: ${nominatingList},
accountUnlockingTotal: ${accountUnlockingTotal},
accountRewardTotal: ${accountRewardTotal}
    ''';
  }
}

mixin _$ValidatorData on _ValidatorData, Store {
  final _$accountIdAtom = Atom(name: '_ValidatorData.accountId');

  @override
  String get accountId {
    _$accountIdAtom.reportRead();
    return super.accountId;
  }

  @override
  set accountId(String value) {
    _$accountIdAtom.reportWrite(value, super.accountId, () {
      super.accountId = value;
    });
  }

  final _$totalAtom = Atom(name: '_ValidatorData.total');

  @override
  int get total {
    _$totalAtom.reportRead();
    return super.total;
  }

  @override
  set total(int value) {
    _$totalAtom.reportWrite(value, super.total, () {
      super.total = value;
    });
  }

  final _$bondOwnAtom = Atom(name: '_ValidatorData.bondOwn');

  @override
  int get bondOwn {
    _$bondOwnAtom.reportRead();
    return super.bondOwn;
  }

  @override
  set bondOwn(int value) {
    _$bondOwnAtom.reportWrite(value, super.bondOwn, () {
      super.bondOwn = value;
    });
  }

  final _$bondOtherAtom = Atom(name: '_ValidatorData.bondOther');

  @override
  int get bondOther {
    _$bondOtherAtom.reportRead();
    return super.bondOther;
  }

  @override
  set bondOther(int value) {
    _$bondOtherAtom.reportWrite(value, super.bondOther, () {
      super.bondOther = value;
    });
  }

  final _$pointsAtom = Atom(name: '_ValidatorData.points');

  @override
  int get points {
    _$pointsAtom.reportRead();
    return super.points;
  }

  @override
  set points(int value) {
    _$pointsAtom.reportWrite(value, super.points, () {
      super.points = value;
    });
  }

  final _$commissionAtom = Atom(name: '_ValidatorData.commission');

  @override
  String get commission {
    _$commissionAtom.reportRead();
    return super.commission;
  }

  @override
  set commission(String value) {
    _$commissionAtom.reportWrite(value, super.commission, () {
      super.commission = value;
    });
  }

  final _$nominatorsAtom = Atom(name: '_ValidatorData.nominators');

  @override
  List<Map<String, dynamic>> get nominators {
    _$nominatorsAtom.reportRead();
    return super.nominators;
  }

  @override
  set nominators(List<Map<String, dynamic>> value) {
    _$nominatorsAtom.reportWrite(value, super.nominators, () {
      super.nominators = value;
    });
  }

  @override
  String toString() {
    return '''
accountId: ${accountId},
total: ${total},
bondOwn: ${bondOwn},
bondOther: ${bondOther},
points: ${points},
commission: ${commission},
nominators: ${nominators}
    ''';
  }
}
