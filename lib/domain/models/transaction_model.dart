import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/utils/timestamp_converter.dart';

part 'transaction_model.freezed.dart';
part 'transaction_model.g.dart';

enum PaymentChannel { stripe, credit }

enum TransactionType { deduct, topUp, refund, payment }

enum TransactionStatus { pending, completed, refunded }

@freezed
class TransactionModel with _$TransactionModel {
  const factory TransactionModel({
    required String id,
    required String parentId,
    required TransactionType type,
    required PaymentChannel paymentChannel,
    required double amount,
    required String description,
    @TimestampConverter() required DateTime createdAt,
    @Default(TransactionStatus.completed) TransactionStatus status,
    String? relatedAppointmentId,
    String? stripePaymentIntentId,
  }) = _TransactionModel;

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);
}
