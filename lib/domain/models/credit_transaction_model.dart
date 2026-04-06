import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/utils/timestamp_converter.dart';

part 'credit_transaction_model.freezed.dart';
part 'credit_transaction_model.g.dart';

enum TransactionType { deduct, topUp, refund }

@freezed
class CreditTransactionModel with _$CreditTransactionModel {
  const factory CreditTransactionModel({
    required String id,
    required String parentId,
    required TransactionType type,
    required int amount,
    required String description,
    @TimestampConverter() required DateTime createdAt,
    String? relatedAppointmentId,
  }) = _CreditTransactionModel;

  factory CreditTransactionModel.fromJson(Map<String, dynamic> json) =>
      _$CreditTransactionModelFromJson(json);
}
