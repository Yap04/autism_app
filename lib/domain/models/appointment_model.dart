import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/utils/timestamp_converter.dart';

part 'appointment_model.freezed.dart';
part 'appointment_model.g.dart';

enum AppointmentStatus { pending, accepted, rejected, completed, cancelled }

enum SessionType { inPerson, remote }

enum PaymentMethod { credit, singlePay }

enum PaymentStatus { paid, pendingPayment, refunded }

@freezed
class AppointmentModel with _$AppointmentModel {
  const factory AppointmentModel({
    required String id,
    required String parentId,
    required String parentName,
    required String childId,
    required String childName,
    required String trainerId,
    required String trainerName,
    required String sport,
    required String location,
    required int duration,
    required SessionType sessionType,
    @TimestampConverter() required DateTime dateTime,
    required AppointmentStatus status,
    @TimestampConverter() required DateTime createdAt,
    required PaymentMethod paymentMethod,
    required PaymentStatus paymentStatus,
    String? recurringGroupId,
    String? sequenceInfo,
    String? childAvatarUrl,
    String? parentAvatarUrl,
  }) = _AppointmentModel;

  factory AppointmentModel.fromJson(Map<String, dynamic> json) =>
      _$AppointmentModelFromJson(json);
}
