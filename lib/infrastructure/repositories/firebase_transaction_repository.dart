import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/transaction_model.dart';
import '../../domain/repositories/transaction_repository.dart';

class FirebaseTransactionRepository implements TransactionRepository {
  FirebaseTransactionRepository(this._firestore);
  final FirebaseFirestore _firestore;

  @override
  Future<void> addTransaction(TransactionModel transaction) async {
    await _firestore
        .collection('users')
        .doc(transaction.parentId)
        .collection('transactions')
        .doc(transaction.id)
        .set(transaction.toJson());
  }

  @override
  Stream<List<TransactionModel>> getUserTransactions(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => TransactionModel.fromJson(doc.data()))
              .toList();
        });
  }
}
