import '../models/feedback_model.dart';

abstract class FeedbackRepository {
  Future<void> saveFeedback(FeedbackModel feedback);

  Stream<List<FeedbackModel>> watchFeedbacksByChildId(String childId);

  Future<FeedbackModel?> getFeedbackByAppointmentId(String appointmentId);
}
