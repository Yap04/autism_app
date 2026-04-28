import 'package:freezed_annotation/freezed_annotation.dart';
import '../../core/utils/timestamp_converter.dart';

part 'ticket_model.freezed.dart';
part 'ticket_model.g.dart';

enum TicketStatus { open, resolved, escalated }

@freezed
class TicketModel with _$TicketModel {
  const factory TicketModel({
    required String id,
    required String userId,
    required String userRole,
    required String category,
    required String lastMessage,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime updatedAt,
    @Default(false) bool lastMessageFromAdmin,
    @Default(TicketStatus.open) TicketStatus status,
  }) = _TicketModel;

  factory TicketModel.fromJson(Map<String, dynamic> json) =>
      _$TicketModelFromJson(json);
}
