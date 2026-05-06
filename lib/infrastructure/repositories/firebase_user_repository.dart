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

  @override
  Future<void> updateUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).update(user.toJson());
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  @override
  Future<void> updateUserStatus(String userId, UserStatus status) async {
    await _firestore.collection('users').doc(userId).update({
      'status': status.name,
    });
  }

  @override
  Stream<List<UserModel>> watchAllUsers() {
    return _firestore
        .collection('users')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return UserModel.fromJson(data);
          }).toList();
        });
  }

  @override
  Future<List<UserModel>> getPendingTrainers() async {
    try {
      final snapshot =
          await _firestore
              .collection('users')
              .where('role', isEqualTo: 'trainer')
              .where('verificationStatus', isEqualTo: 'pending')
              .get();

      return snapshot.docs
          .map((doc) => UserModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch pending trainers: $e');
    }
  }

  @override
  Future<String?> getUserFcmToken(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        return doc.data()?['fcmToken'] as String?;
      }
      return null;
    } catch (e) {
      print('⚠️ Failed to get FCM token for user $uid: $e');
      return null;
    }
  }

  @override
  Future<void> updateUserFcmToken(String uid, String token) async {
    try {
      await _firestore.collection('users').doc(uid).update({'fcmToken': token});
    } catch (e) {
      print('⚠️ Failed to update FCM token: $e');
    }
  }

  @override
  Stream<UserModel?> watchUser(String userId) {
    return _firestore.collection('users').doc(userId).snapshots().map((
      snapshot,
    ) {
      if (snapshot.exists && snapshot.data() != null) {
        return UserModel.fromJson(snapshot.data()!);
      }
      return null;
    });
  }
}
