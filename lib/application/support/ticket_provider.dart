import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/models/ticket_message_model.dart';
import '../../domain/models/ticket_model.dart';
import '../auth/auth_notifier.dart';
import '../providers/repository_providers.dart';

part 'ticket_provider.g.dart';

@riverpod
Stream<List<TicketModel>> userTicketsStream(UserTicketsStreamRef ref) {
  final user = ref.watch(authNotifierProvider).value;

  if (user == null) {
    return Stream.value([]);
  }

  final repo = ref.watch(ticketRepositoryProvider);
  return repo.watchUserTickets(user.id);
}

@riverpod
Stream<List<TicketMessageModel>> ticketMessages(
  TicketMessagesRef ref,
  String ticketId,
) {
  final repo = ref.watch(ticketRepositoryProvider);
  return repo.watchTicketMessages(ticketId);
}
