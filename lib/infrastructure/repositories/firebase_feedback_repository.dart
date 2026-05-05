import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/feedback_model.dart';
import '../../domain/repositories/feedback_repository.dart';

class FirebaseFeedbackRepository implements FeedbackRepository {
  FirebaseFeedbackRepository(this._firestore);
  final FirebaseFirestore _firestore;

  static const String _path = 'feedbacks';

  CollectionReference<Map<String, dynamic>> get _ref =>
      _firestore.collection(_path);

  @override
  Future<void> saveFeedback(FeedbackModel feedback) async {
    try {
      await _ref
          .doc(feedback.id)
          .set(feedback.toJson(), SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to save session feedback: $e');
    }
  }

  @override
  Stream<List<FeedbackModel>> watchFeedbacksByChildId(String childId) {
    return _ref
        .where('childId', isEqualTo: childId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return FeedbackModel.fromJson(doc.data());
          }).toList();
        });
  }

  @override
  Future<FeedbackModel?> getFeedbackByAppointmentId(
    String appointmentId,
  ) async {
    try {
      final querySnapshot =
          await _ref
              .where('appointmentId', isEqualTo: appointmentId)
              .limit(1)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        return FeedbackModel.fromJson(querySnapshot.docs.first.data());
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch feedback: $e');
    }
  }

  @override
  Future<List<FeedbackModel>> getFeedbacksByTrainerId(String trainerId) async {
    final query =
        await _firestore
            .collection('feedbacks')
            .where('trainerId', isEqualTo: trainerId)
            .where('rating', isNull: false)
            .orderBy('createdAt', descending: true)
            .get();

    return query.docs.map((d) => FeedbackModel.fromJson(d.data())).toList();
  }

  @override
  Future<void> updateParentReview({
    required String appointmentId,
    required int rating,
    required String review,
  }) async {
    final query =
        await _firestore
            .collection('feedbacks')
            .where('appointmentId', isEqualTo: appointmentId)
            .limit(1)
            .get();

    if (query.docs.isEmpty) {
      throw Exception('Feedback not found');
    }

    final feedbackDoc = query.docs.first;
    final trainerId = feedbackDoc.data()['trainerId'] as String;

    await query.docs.first.reference.update({
      'rating': rating,
      'review': review,
    });

    final allFeedbacks =
        await _firestore
            .collection('feedbacks')
            .where('trainerId', isEqualTo: trainerId)
            .where('rating', isNull: false)
            .get();

    final ratings =
        allFeedbacks.docs
            .map((d) => (d.data()['rating'] as num).toDouble())
            .toList();

    if (ratings.isEmpty) {
      return;
    }

    final avg = ratings.reduce((a, b) => a + b) / ratings.length;

    await _firestore.collection('users').doc(trainerId).update({
      'avgRating': double.parse(avg.toStringAsFixed(1)),
      'totalReviews': ratings.length,
    });
  }
}
