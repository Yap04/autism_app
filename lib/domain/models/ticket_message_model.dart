import 'package:freezed_annotation/freezed_annotation.dart';
import '../../core/utils/timestamp_converter.dart';

part 'ticket_message_model.freezed.dart';
part 'ticket_message_model.g.dart';

@freezed
class TicketMessageModel with _$TicketMessageModel {
  const factory TicketMessageModel({
    required String id,
    required bool isFromAdmin,
    required String message,
    @TimestampConverter() required DateTime createdAt,
  }) = _TicketMessageModel;

  factory TicketMessageModel.fromJson(Map<String, dynamic> json) =>
      _$TicketMessageModelFromJson(json);
}
