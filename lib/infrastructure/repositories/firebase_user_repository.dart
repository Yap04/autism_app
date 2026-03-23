import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/user_model.dart';
import '../../domain/repositories/user_repository.dart';

class FirebaseUserRepository implements UserRepository {
  FirebaseUserRepository(this._firestore);
  final FirebaseFirestore _firestore;

  @override
  Future<List<UserModel>> getTrainers() async {
    try {
      final snapshot =
          await _firestore
              .collection('users')
              .where('role', isEqualTo: 'trainer')
              .get();
      return snapshot.docs
          .map((doc) => UserModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to get trainers: $e');
    }
  }

  @override
  Future<UserModel?> getUserById(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        return UserModel.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  @override
  Future<void> saveUser(UserModel user) async {
    try {
      await _firestore
          .collection('users')
          .doc(user.id)
          .set(user.toJson(), SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to save user: $e');
    }
  }
}
