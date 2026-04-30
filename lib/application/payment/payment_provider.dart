import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/models/transaction_model.dart';
import '../providers/repository_providers.dart';

part 'payment_provider.g.dart';

@riverpod
Stream<List<TransactionModel>> userTransactions(
  UserTransactionsRef ref,
  String userId,
) {
  return ref.watch(transactionRepositoryProvider).getUserTransactions(userId);
}
