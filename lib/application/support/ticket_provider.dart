import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/ticket_message_model.dart';
import '../../domain/models/ticket_model.dart';
import '../auth/auth_notifier.dart';
import '../providers/repository_providers.dart';

final userTicketsStreamProvider = StreamProvider.autoDispose<List<TicketModel>>(
  (ref) {
    final user = ref.watch(authNotifierProvider).value;

    if (user == null) {
      return Stream.value([]);
    }

    final repo = ref.watch(ticketRepositoryProvider);
    return repo.watchUserTickets(user.id);
  },
);

final ticketMessagesProvider = StreamProvider.family
    .autoDispose<List<TicketMessageModel>, String>((ref, ticketId) {
      final repo = ref.watch(ticketRepositoryProvider);
      return repo.watchTicketMessages(ticketId);
    });
