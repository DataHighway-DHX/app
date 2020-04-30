import 'package:json_annotation/json_annotation.dart';

part 'transferData.g.dart';

@JsonSerializable()
class TransferData extends _TransferData {
  static TransferData fromJson(Map<String, dynamic> json) =>
      _$TransferDataFromJson(json);
}

abstract class _TransferData {
  @JsonKey(name: 'block_num')
  int blockNum = 0;

  @JsonKey(name: 'block_timestamp')
  int blockTimestamp = 0;

  @JsonKey(name: 'extrinsic_index')
  String extrinsicIndex = "";

  String fee = "";

  String from = "";
  String to = "";
  String amount = "";
  String hash = "";
  String module = "";
  bool success = true;
}
