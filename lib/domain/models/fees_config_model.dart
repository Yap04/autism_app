import 'package:freezed_annotation/freezed_annotation.dart';

part 'fees_config_model.freezed.dart';
part 'fees_config_model.g.dart';

@freezed
class FeesConfigModel with _$FeesConfigModel {
  const factory FeesConfigModel({
    required double slaPenaltyRate,
    required int slaTravelPenaltyHours,
    required double commStandardRate,
    required double commMasterRate,
    required int commThreshold,
    required double baseHourlyRate,
    required double remoteDiscountAmount,
  }) = _FeesConfigModel;

  factory FeesConfigModel.fromJson(Map<String, dynamic> json) =>
      _$FeesConfigModelFromJson(json);
}
