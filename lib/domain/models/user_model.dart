import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

enum UserRole { parent, trainer, admin }

enum Gender { female, male, preferNotToSay }

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
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
