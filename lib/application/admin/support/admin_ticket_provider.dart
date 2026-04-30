import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/models/ticket_model.dart';
import '../../providers/repository_providers.dart';

part 'admin_ticket_provider.g.dart';

@riverpod
Stream<List<TicketModel>> adminTicketsStream(AdminTicketsStreamRef ref) {
  return ref.watch(ticketRepositoryProvider).watchAllTickets();
}

@riverpod
class SelectedTicketId extends _$SelectedTicketId {
  @override
  String? build() {
    return null;
  }

  void set(String? id) {
    state = id;
  }

  void clear() {
    state = null;
  }
}
