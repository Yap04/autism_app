import 'dart:io';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../domain/models/child_model.dart';
import '../../infrastructure/services/image_service.dart';
import '../auth/auth_notifier.dart';
import '../providers/repository_providers.dart';

part 'child_notifier.g.dart';

@riverpod
class ChildNotifier extends _$ChildNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> saveChild({
    required String name,
    required String ageString,
    required String gender,
    required List<String> specialNeeds,
    required String remarks,
    String? id,
    File? selectedImage,
    String? existingImageUrl,
    DateTime? existingCreatedAt,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final currentUser = ref.read(authNotifierProvider).value;
      if (currentUser == null) throw Exception('Current user not found.');
      final parentId = currentUser.id;

      var finalImageUrl = existingImageUrl;
      if (selectedImage != null) {
        finalImageUrl = await ImageService.uploadToImgBB(selectedImage);
        if (finalImageUrl == null) {
          throw Exception('Image upload failed, please try again.');
        }
      }

      final childToSave = ChildModel(
        id: id ?? const Uuid().v4(),
        parentId: parentId,
        name: name,
        age: int.parse(ageString),
        gender: gender,
        userAvatarUrl: finalImageUrl,
        specialNeeds: specialNeeds,
        remarks: remarks,
        createdAt: existingCreatedAt ?? DateTime.now(),
      );

      await ref.read(childRepositoryProvider).saveChild(childToSave);
    });
  }
}
