import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/models/transaction_model.dart';
import '../../providers/repository_providers.dart';

part 'admin_transaction_provider.g.dart';

@riverpod
Stream<List<TransactionModel>> allTransactionsStream(
  AllTransactionsStreamRef ref,
) {
  final repo = ref.watch(transactionRepositoryProvider);
  return repo.watchAllTransactions();
}

@riverpod
class TransactionFilter extends _$TransactionFilter {
  @override
  String build() {
    return 'All';
  }

  void setFilter(String filter) {
    state = filter;
  }
}
