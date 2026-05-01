import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/utils/timestamp_converter.dart';

part 'child_model.freezed.dart';
part 'child_model.g.dart';

@freezed
class ChildModel with _$ChildModel {
  const factory ChildModel({
    required String id,
    required String parentId,
    required String name,
    required int age,
    String? gender,
    String? userAvatarUrl,
    String? remarks,
    @Default([]) List<String> specialNeeds,
    @Default([]) List<String> assignedTrainerIds,
    @Default(true) bool isActive,

    @TimestampConverter() DateTime? createdAt,
  }) = _ChildModel;
  const ChildModel._();

  factory ChildModel.fromJson(Map<String, dynamic> json) =>
      _$ChildModelFromJson(json);

  dynamic get status => null;
}
