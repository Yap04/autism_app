import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/models/transaction_model.dart';
import '../../providers/repository_providers.dart';

final allTransactionsStreamProvider =
    StreamProvider.autoDispose<List<TransactionModel>>((ref) {
      final repo = ref.watch(transactionRepositoryProvider);
      return repo.watchAllTransactions();
    });

final transactionFilterProvider = StateProvider<String>((ref) => 'All');
