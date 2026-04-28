import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/utils/timestamp_converter.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

enum UserRole { parent, trainer, admin }

enum Gender { female, male, preferNotToSay }

enum UserStatus { active, suspended }

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    required UserRole role,
    String? name,
    String? nickname,
    String? phoneNumber,
    Gender? gender,
    String? address,
    String? userAvatarUrl,
    @Default(0) int sessionCredits,
    @Default(UserStatus.active) UserStatus status,
    @Default(true) bool isAcceptingRequests,
    DateTime? resumeAt,
    List<dynamic>? operatingHours,
    @TimestampConverter() DateTime? createdAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
