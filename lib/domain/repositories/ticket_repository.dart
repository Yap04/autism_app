import '../models/ticket_message_model.dart';
import '../models/ticket_model.dart';

abstract class TicketRepository {
  Stream<List<TicketModel>> watchUserTickets(String userId);

  Future<void> createTicket(TicketModel ticket);

  Stream<List<TicketMessageModel>> watchTicketMessages(String ticketId);

  Future<void> sendTicketMessage(
    String ticketId,
    TicketMessageModel message,
    String newLastMessage,
  );

  Stream<List<TicketModel>> watchAllTickets();

  Future<void> updateTicketStatus(String ticketId, TicketStatus status);
}
