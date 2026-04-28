import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/models/ticket_model.dart';
import '../../providers/repository_providers.dart';

final adminTicketsStreamProvider =
    StreamProvider.autoDispose<List<TicketModel>>((ref) {
      return ref.watch(ticketRepositoryProvider).watchAllTickets();
    });

final selectedTicketIdProvider = StateProvider<String?>((ref) => null);
