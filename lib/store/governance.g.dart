// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'governance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CouncilInfo _$CouncilInfoFromJson(Map<String, dynamic> json) {
  return CouncilInfo()
    ..desiredSeats = json['desiredSeats'] as int
    ..termDuration = json['termDuration'] as int
    ..votingBond = json['votingBond'] as int
    ..members = (json['members'] as List)
        ?.map((e) => (e as List)?.map((e) => e as String)?.toList())
        ?.toList()
    ..runnersUp = (json['runnersUp'] as List)
        ?.map((e) => (e as List)?.map((e) => e as String)?.toList())
        ?.toList()
    ..candidates =
        (json['candidates'] as List)?.map((e) => e as String)?.toList()
    ..candidateCount = json['candidateCount'] as int
    ..candidacyBond = json['candidacyBond'] as int;
}

Map<String, dynamic> _$CouncilInfoToJson(CouncilInfo instance) =>
    <String, dynamic>{
      'desiredSeats': instance.desiredSeats,
      'termDuration': instance.termDuration,
      'votingBond': instance.votingBond,
      'members': instance.members,
      'runnersUp': instance.runnersUp,
      'candidates': instance.candidates,
      'candidateCount': instance.candidateCount,
      'candidacyBond': instance.candidacyBond,
    };

ReferendumInfo _$ReferendumInfoFromJson(Map<String, dynamic> json) {
  return ReferendumInfo()
    ..index = json['index'] as int
    ..hash = json['hash'] as String
    ..status = json['status'] as Map<String, dynamic>
    ..proposal = json['proposal'] as Map<String, dynamic>
    ..preimage = json['preimage'] as Map<String, dynamic>
    ..detail = json['detail'] as Map<String, dynamic>
    ..votes = json['votes'] as Map<String, dynamic>;
}

Map<String, dynamic> _$ReferendumInfoToJson(ReferendumInfo instance) =>
    <String, dynamic>{
      'index': instance.index,
      'hash': instance.hash,
      'status': instance.status,
      'proposal': instance.proposal,
      'preimage': instance.preimage,
      'detail': instance.detail,
      'votes': instance.votes,
    };

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$GovernanceStore on _GovernanceStore, Store {
  Computed<Map<int, int>> _$votedMapComputed;

  @override
  Map<int, int> get votedMap =>
      (_$votedMapComputed ??= Computed<Map<int, int>>(() => super.votedMap,
              name: '_GovernanceStore.votedMap'))
          .value;

  final _$cacheCouncilTimestampAtom =
      Atom(name: '_GovernanceStore.cacheCouncilTimestamp');

  @override
  int get cacheCouncilTimestamp {
    _$cacheCouncilTimestampAtom.reportRead();
    return super.cacheCouncilTimestamp;
  }

  @override
  set cacheCouncilTimestamp(int value) {
    _$cacheCouncilTimestampAtom.reportWrite(value, super.cacheCouncilTimestamp,
        () {
      super.cacheCouncilTimestamp = value;
    });
  }

  final _$bestNumberAtom = Atom(name: '_GovernanceStore.bestNumber');

  @override
  int get bestNumber {
    _$bestNumberAtom.reportRead();
    return super.bestNumber;
  }

  @override
  set bestNumber(int value) {
    _$bestNumberAtom.reportWrite(value, super.bestNumber, () {
      super.bestNumber = value;
    });
  }

  final _$councilAtom = Atom(name: '_GovernanceStore.council');

  @override
  CouncilInfo get council {
    _$councilAtom.reportRead();
    return super.council;
  }

  @override
  set council(CouncilInfo value) {
    _$councilAtom.reportWrite(value, super.council, () {
      super.council = value;
    });
  }

  final _$referendumsAtom = Atom(name: '_GovernanceStore.referendums');

  @override
  ObservableList<ReferendumInfo> get referendums {
    _$referendumsAtom.reportRead();
    return super.referendums;
  }

  @override
  set referendums(ObservableList<ReferendumInfo> value) {
    _$referendumsAtom.reportWrite(value, super.referendums, () {
      super.referendums = value;
    });
  }

  final _$userReferendumVotesAtom =
      Atom(name: '_GovernanceStore.userReferendumVotes');

  @override
  ObservableList<Map<dynamic, dynamic>> get userReferendumVotes {
    _$userReferendumVotesAtom.reportRead();
    return super.userReferendumVotes;
  }

  @override
  set userReferendumVotes(ObservableList<Map<dynamic, dynamic>> value) {
    _$userReferendumVotesAtom.reportWrite(value, super.userReferendumVotes, () {
      super.userReferendumVotes = value;
    });
  }

  final _$loadCacheAsyncAction = AsyncAction('_GovernanceStore.loadCache');

  @override
  Future<void> loadCache() {
    return _$loadCacheAsyncAction.run(() => super.loadCache());
  }

  final _$_GovernanceStoreActionController =
      ActionController(name: '_GovernanceStore');

  @override
  void setCouncilInfo(Map<dynamic, dynamic> info, {bool shouldCache = true}) {
    final _$actionInfo = _$_GovernanceStoreActionController.startAction(
        name: '_GovernanceStore.setCouncilInfo');
    try {
      return super.setCouncilInfo(info, shouldCache: shouldCache);
    } finally {
      _$_GovernanceStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setBestNumber(int number) {
    final _$actionInfo = _$_GovernanceStoreActionController.startAction(
        name: '_GovernanceStore.setBestNumber');
    try {
      return super.setBestNumber(number);
    } finally {
      _$_GovernanceStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setReferendums(List<dynamic> ls) {
    final _$actionInfo = _$_GovernanceStoreActionController.startAction(
        name: '_GovernanceStore.setReferendums');
    try {
      return super.setReferendums(ls);
    } finally {
      _$_GovernanceStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setUserReferendumVotes(String address, List<dynamic> ls) {
    final _$actionInfo = _$_GovernanceStoreActionController.startAction(
        name: '_GovernanceStore.setUserReferendumVotes');
    try {
      return super.setUserReferendumVotes(address, ls);
    } finally {
      _$_GovernanceStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearSate() {
    final _$actionInfo = _$_GovernanceStoreActionController.startAction(
        name: '_GovernanceStore.clearSate');
    try {
      return super.clearSate();
    } finally {
      _$_GovernanceStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
cacheCouncilTimestamp: ${cacheCouncilTimestamp},
bestNumber: ${bestNumber},
council: ${council},
referendums: ${referendums},
userReferendumVotes: ${userReferendumVotes},
votedMap: ${votedMap}
    ''';
  }
}

mixin _$CouncilInfo on _CouncilInfo, Store {
  @override
  String toString() {
    return '''

    ''';
  }
}

mixin _$ReferendumInfo on _ReferendumInfo, Store {
  @override
  String toString() {
    return '''

    ''';
  }
}
