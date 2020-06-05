// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assets.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AssetsStore on _AssetsStore, Store {
  Computed<ObservableList<TransferData>> _$txsViewComputed;

  @override
  ObservableList<TransferData> get txsView => (_$txsViewComputed ??=
          Computed<ObservableList<TransferData>>(() => super.txsView,
              name: '_AssetsStore.txsView'))
      .value;
  Computed<ObservableList<Map<String, dynamic>>> _$balanceHistoryComputed;

  @override
  ObservableList<Map<String, dynamic>> get balanceHistory =>
      (_$balanceHistoryComputed ??=
              Computed<ObservableList<Map<String, dynamic>>>(
                  () => super.balanceHistory,
                  name: '_AssetsStore.balanceHistory'))
          .value;

  final _$cacheTxsTimestampAtom = Atom(name: '_AssetsStore.cacheTxsTimestamp');

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

  final _$isTxsLoadingAtom = Atom(name: '_AssetsStore.isTxsLoading');

  @override
  bool get isTxsLoading {
    _$isTxsLoadingAtom.reportRead();
    return super.isTxsLoading;
  }

  @override
  set isTxsLoading(bool value) {
    _$isTxsLoadingAtom.reportWrite(value, super.isTxsLoading, () {
      super.isTxsLoading = value;
    });
  }

  final _$submittingAtom = Atom(name: '_AssetsStore.submitting');

  @override
  bool get submitting {
    _$submittingAtom.reportRead();
    return super.submitting;
  }

  @override
  set submitting(bool value) {
    _$submittingAtom.reportWrite(value, super.submitting, () {
      super.submitting = value;
    });
  }

  final _$balanceAtom = Atom(name: '_AssetsStore.balance');

  @override
  String get balance {
    _$balanceAtom.reportRead();
    return super.balance;
  }

  @override
  set balance(String value) {
    _$balanceAtom.reportWrite(value, super.balance, () {
      super.balance = value;
    });
  }

  final _$isExpandAtom = Atom(name: '_AssetsStore.isExpand');

  @override
  List<dynamic> get isExpand {
    _$isExpandAtom.reportRead();
    return super.isExpand;
  }

  @override
  set isExpand(List<dynamic> value) {
    _$isExpandAtom.reportWrite(value, super.isExpand, () {
      super.isExpand = value;
    });
  }

  final _$txsAtom = Atom(name: '_AssetsStore.txs');

  @override
  ObservableList<TransferData> get txs {
    _$txsAtom.reportRead();
    return super.txs;
  }

  @override
  set txs(ObservableList<TransferData> value) {
    _$txsAtom.reportWrite(value, super.txs, () {
      super.txs = value;
    });
  }

  final _$txsFilterAtom = Atom(name: '_AssetsStore.txsFilter');

  @override
  int get txsFilter {
    _$txsFilterAtom.reportRead();
    return super.txsFilter;
  }

  @override
  set txsFilter(int value) {
    _$txsFilterAtom.reportWrite(value, super.txsFilter, () {
      super.txsFilter = value;
    });
  }

  final _$blockMapAtom = Atom(name: '_AssetsStore.blockMap');

  @override
  ObservableMap<int, BlockData> get blockMap {
    _$blockMapAtom.reportRead();
    return super.blockMap;
  }

  @override
  set blockMap(ObservableMap<int, BlockData> value) {
    _$blockMapAtom.reportWrite(value, super.blockMap, () {
      super.blockMap = value;
    });
  }

  final _$clearTxsAsyncAction = AsyncAction('_AssetsStore.clearTxs');

  @override
  Future<void> clearTxs() {
    return _$clearTxsAsyncAction.run(() => super.clearTxs());
  }

  final _$addTxsAsyncAction = AsyncAction('_AssetsStore.addTxs');

  @override
  Future<void> addTxs(List<dynamic> ls, String address,
      {bool shouldCache = false}) {
    return _$addTxsAsyncAction
        .run(() => super.addTxs(ls, address, shouldCache: shouldCache));
  }

  final _$setBlockMapAsyncAction = AsyncAction('_AssetsStore.setBlockMap');

  @override
  Future<void> setBlockMap(String data) {
    return _$setBlockMapAsyncAction.run(() => super.setBlockMap(data));
  }

  final _$loadAccountCacheAsyncAction =
      AsyncAction('_AssetsStore.loadAccountCache');

  @override
  Future<void> loadAccountCache() {
    return _$loadAccountCacheAsyncAction.run(() => super.loadAccountCache());
  }

  final _$loadCacheAsyncAction = AsyncAction('_AssetsStore.loadCache');

  @override
  Future<void> loadCache() {
    return _$loadCacheAsyncAction.run(() => super.loadCache());
  }

  final _$_AssetsStoreActionController = ActionController(name: '_AssetsStore');

  @override
  void setIsExpand(String name) {
    final _$actionInfo = _$_AssetsStoreActionController.startAction(
        name: '_AssetsStore.setIsExpand');
    try {
      return super.setIsExpand(name);
    } finally {
      _$_AssetsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTxsLoading(bool isLoading) {
    final _$actionInfo = _$_AssetsStoreActionController.startAction(
        name: '_AssetsStore.setTxsLoading');
    try {
      return super.setTxsLoading(isLoading);
    } finally {
      _$_AssetsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setAccountBalance(String pubKey, String amt) {
    final _$actionInfo = _$_AssetsStoreActionController.startAction(
        name: '_AssetsStore.setAccountBalance');
    try {
      return super.setAccountBalance(pubKey, amt);
    } finally {
      _$_AssetsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTxsFilter(int filter) {
    final _$actionInfo = _$_AssetsStoreActionController.startAction(
        name: '_AssetsStore.setTxsFilter');
    try {
      return super.setTxsFilter(filter);
    } finally {
      _$_AssetsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSubmitting(bool isSubmitting) {
    final _$actionInfo = _$_AssetsStoreActionController.startAction(
        name: '_AssetsStore.setSubmitting');
    try {
      return super.setSubmitting(isSubmitting);
    } finally {
      _$_AssetsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
cacheTxsTimestamp: ${cacheTxsTimestamp},
isTxsLoading: ${isTxsLoading},
submitting: ${submitting},
balance: ${balance},
isExpand: ${isExpand},
txs: ${txs},
txsFilter: ${txsFilter},
blockMap: ${blockMap},
txsView: ${txsView},
balanceHistory: ${balanceHistory}
    ''';
  }
}

mixin _$TransferData on _TransferData, Store {
  final _$typeAtom = Atom(name: '_TransferData.type');

  @override
  String get type {
    _$typeAtom.reportRead();
    return super.type;
  }

  @override
  set type(String value) {
    _$typeAtom.reportWrite(value, super.type, () {
      super.type = value;
    });
  }

  final _$idAtom = Atom(name: '_TransferData.id');

  @override
  String get id {
    _$idAtom.reportRead();
    return super.id;
  }

  @override
  set id(String value) {
    _$idAtom.reportWrite(value, super.id, () {
      super.id = value;
    });
  }

  final _$hashAtom = Atom(name: '_TransferData.hash');

  @override
  String get hash {
    _$hashAtom.reportRead();
    return super.hash;
  }

  @override
  set hash(String value) {
    _$hashAtom.reportWrite(value, super.hash, () {
      super.hash = value;
    });
  }

  final _$blockAtom = Atom(name: '_TransferData.block');

  @override
  int get block {
    _$blockAtom.reportRead();
    return super.block;
  }

  @override
  set block(int value) {
    _$blockAtom.reportWrite(value, super.block, () {
      super.block = value;
    });
  }

  final _$senderAtom = Atom(name: '_TransferData.sender');

  @override
  String get sender {
    _$senderAtom.reportRead();
    return super.sender;
  }

  @override
  set sender(String value) {
    _$senderAtom.reportWrite(value, super.sender, () {
      super.sender = value;
    });
  }

  final _$senderIdAtom = Atom(name: '_TransferData.senderId');

  @override
  String get senderId {
    _$senderIdAtom.reportRead();
    return super.senderId;
  }

  @override
  set senderId(String value) {
    _$senderIdAtom.reportWrite(value, super.senderId, () {
      super.senderId = value;
    });
  }

  final _$destinationAtom = Atom(name: '_TransferData.destination');

  @override
  String get destination {
    _$destinationAtom.reportRead();
    return super.destination;
  }

  @override
  set destination(String value) {
    _$destinationAtom.reportWrite(value, super.destination, () {
      super.destination = value;
    });
  }

  final _$destinationIdAtom = Atom(name: '_TransferData.destinationId');

  @override
  String get destinationId {
    _$destinationIdAtom.reportRead();
    return super.destinationId;
  }

  @override
  set destinationId(String value) {
    _$destinationIdAtom.reportWrite(value, super.destinationId, () {
      super.destinationId = value;
    });
  }

  final _$valueAtom = Atom(name: '_TransferData.value');

  @override
  int get value {
    _$valueAtom.reportRead();
    return super.value;
  }

  @override
  set value(int value) {
    _$valueAtom.reportWrite(value, super.value, () {
      super.value = value;
    });
  }

  final _$feeAtom = Atom(name: '_TransferData.fee');

  @override
  int get fee {
    _$feeAtom.reportRead();
    return super.fee;
  }

  @override
  set fee(int value) {
    _$feeAtom.reportWrite(value, super.fee, () {
      super.fee = value;
    });
  }

  @override
  String toString() {
    return '''
type: ${type},
id: ${id},
hash: ${hash},
block: ${block},
sender: ${sender},
senderId: ${senderId},
destination: ${destination},
destinationId: ${destinationId},
value: ${value},
fee: ${fee}
    ''';
  }
}

mixin _$BlockData on _BlockData, Store {
  final _$idAtom = Atom(name: '_BlockData.id');

  @override
  int get id {
    _$idAtom.reportRead();
    return super.id;
  }

  @override
  set id(int value) {
    _$idAtom.reportWrite(value, super.id, () {
      super.id = value;
    });
  }

  final _$hashAtom = Atom(name: '_BlockData.hash');

  @override
  String get hash {
    _$hashAtom.reportRead();
    return super.hash;
  }

  @override
  set hash(String value) {
    _$hashAtom.reportWrite(value, super.hash, () {
      super.hash = value;
    });
  }

  final _$timeAtom = Atom(name: '_BlockData.time');

  @override
  DateTime get time {
    _$timeAtom.reportRead();
    return super.time;
  }

  @override
  set time(DateTime value) {
    _$timeAtom.reportWrite(value, super.time, () {
      super.time = value;
    });
  }

  @override
  String toString() {
    return '''
id: ${id},
hash: ${hash},
time: ${time}
    ''';
  }
}
