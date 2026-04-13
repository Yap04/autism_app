import '../models/credit_transaction_model.dart';

abstract class TransactionRepository {
  Future<void> addTransaction(CreditTransactionModel transaction);

  Stream<List<CreditTransactionModel>> getUserTransactions(String userId);
}
