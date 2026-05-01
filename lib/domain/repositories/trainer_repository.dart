import '../../domain/models/user_model.dart';

abstract class TrainerRepository {
  Future<void> submitTrainerApplication({
    required String userId,
    required List<String> certificateUrls,
    required List<String> sports,
    required String bio,
  });

  Stream<List<UserModel>> watchAllApplications();

  Future<void> reviewApplication({
    required String userId,
    required bool isApproved,
    String? reason,
  });
}
