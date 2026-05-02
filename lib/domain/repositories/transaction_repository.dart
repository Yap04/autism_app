import '../models/transaction_model.dart';

abstract class TransactionRepository {
  Future<void> addTransaction(TransactionModel transaction);

  Future<void> updateTransaction(TransactionModel transaction);

  Stream<List<TransactionModel>> getUserTransactions(String userId);

  Stream<List<TransactionModel>> watchAllTransactions();
}
