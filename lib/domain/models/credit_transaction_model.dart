import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/utils/timestamp_converter.dart';

part 'credit_transaction_model.freezed.dart';
part 'credit_transaction_model.g.dart';

enum PaymentChannel { stripe, credit }

enum TransactionType { deduct, topUp, refund, payment }

enum TransactionStatus { pending, completed, refunded }

@freezed
class CreditTransactionModel with _$CreditTransactionModel {
  const factory CreditTransactionModel({
    required String id,
    required String parentId,
    required TransactionType type,
    required PaymentChannel paymentChannel, 
    required double amount,
    required String description,
    @TimestampConverter() required DateTime createdAt,
    @Default(TransactionStatus.completed) TransactionStatus status,
    String? relatedAppointmentId,
  }) = _CreditTransactionModel;

  factory CreditTransactionModel.fromJson(Map<String, dynamic> json) =>
      _$CreditTransactionModelFromJson(json);
}
