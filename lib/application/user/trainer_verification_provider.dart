import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/models/user_model.dart';
import '../../infrastructure/services/image_service.dart';
import '../auth/auth_notifier.dart';
import '../providers/repository_providers.dart';

part 'trainer_verification_provider.g.dart';

@riverpod
Stream<List<UserModel>> trainerApplications(TrainerApplicationsRef ref) {
  final repo = ref.watch(trainerRepositoryProvider);
  return repo.watchAllApplications();
}

@riverpod
class TrainerVerificationNotifier extends _$TrainerVerificationNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> submitApplication({
    required List<File> certificateImages,
    required List<String> existingUrls,
    required List<String> selectedSports,
    required String bio,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final currentUser = ref.read(authNotifierProvider).value;
      final firebaseAuthUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null && firebaseAuthUser == null) {
        throw Exception('Please login first.');
      }

      final userId = currentUser?.id ?? firebaseAuthUser!.uid;

      final uploadedUrls = <String>[...existingUrls];

      for (final file in certificateImages) {
        final url = await ImageService.uploadToImgBB(file);
        if (url == null) {
          throw Exception('Failed to upload image. Please try again.');
        }
        uploadedUrls.add(url);
      }

      await ref
          .read(trainerRepositoryProvider)
          .submitTrainerApplication(
            userId: userId,
            certificateUrls: uploadedUrls,
            sports: selectedSports,
            bio: bio,
          );
    });
  }
}
