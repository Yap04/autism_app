import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/feedback_model.dart';
import '../providers/repository_providers.dart';

part 'feedback_provider.g.dart';

@riverpod
Stream<List<FeedbackModel>> studentFeedbacks(
  StudentFeedbacksRef ref,
  String childId,
) {
  return ref.watch(feedbackRepositoryProvider).watchFeedbacksByChildId(childId);
}
