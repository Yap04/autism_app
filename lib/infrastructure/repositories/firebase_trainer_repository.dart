import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/user_model.dart';
import '../../domain/repositories/trainer_repository.dart';

class FirebaseTrainerRepository implements TrainerRepository {
  FirebaseTrainerRepository(this._firestore);

  final FirebaseFirestore _firestore;

  static const String _usersPath = 'users';

  CollectionReference<Map<String, dynamic>> get _usersRef =>
      _firestore.collection(_usersPath);

  @override
  Future<void> submitTrainerApplication({
    required String userId,
    required List<String> certificateUrls,
    required List<String> sports,
    required String bio,
  }) async {
    try {
      await _usersRef.doc(userId).update({
        'verificationStatus': VerificationStatus.pending.name,
        'certificateUrls': certificateUrls,
        'sports': sports,
        'bio': bio,
      });
    } catch (e) {
      throw Exception('Failed to submit trainer application: $e');
    }
  }

  @override
  Stream<List<UserModel>> watchAllApplications() {
    return _usersRef
        .where(
          'verificationStatus',
          whereIn: [
            VerificationStatus.pending.name,
            VerificationStatus.approved.name,
            VerificationStatus.rejected.name,
          ],
        )
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
  Future<void> reviewApplication({
    required String userId,
    required bool isApproved,
    String? reason,
  }) async {
    try {
      final updates = <String, dynamic>{
        'verificationStatus':
            isApproved
                ? VerificationStatus.approved.name
                : VerificationStatus.rejected.name,
      };

      if (isApproved) {
        updates['role'] = UserRole.trainer.name;
      }

      if (!isApproved && reason != null) {
        updates['rejectReason'] = reason;
      }

      await _usersRef.doc(userId).update(updates);
    } catch (e) {
      throw Exception('Failed to review application: $e');
    }
  }
}
