import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/utils/timestamp_converter.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

enum UserRole { parent, trainer, admin }

enum VerificationStatus { none, pending, approved, rejected }

enum Gender { male, female, other }

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
    String? bio,
    String? location,
    double? latitude,
    double? longitude,
    double? walletBalance,
    String? bankName,
    String? bankAccountNumber,
    String? accountHolderName,
    double? avgRating,
    int? totalReviews,
    @Default(VerificationStatus.none) VerificationStatus verificationStatus,
    List<String>? certificateUrls,
    String? rejectReason,
    @Default([]) List<String> sports,
    @Default(0) int sessionCredits,
    @Default(UserStatus.active) UserStatus status,
    @Default(true) bool isAcceptingRequests,
    @Default([]) List<String> badges,
    @Default(0) int totalCpdPoints,
    @Default(false) bool acceptsHomeBased,
    @Default(0) int meltdownGraceUsedThisMonth,
    @TimestampConverter() DateTime? lastGraceResetDate,
    DateTime? resumeAt,
    List<dynamic>? operatingHours,
    @TimestampConverter() DateTime? createdAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
