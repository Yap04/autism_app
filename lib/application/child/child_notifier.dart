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

  Future<void> addChild({
    required String name,
    required String ageString,
    required String gender,
    required List<String> specialNeeds,
    required String remarks,
    File? selectedImage,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final currentUser = ref.read(authNotifierProvider).value;
      if (currentUser == null) throw Exception('Current user not found.');
      final parentId = currentUser.id;

      String? uploadedImageUrl;
      if (selectedImage != null) {
        uploadedImageUrl = await ImageService.uploadToImgBB(selectedImage);
        if (uploadedImageUrl == null) {
          throw Exception('Image upload failed, please try again.');
        }
      }

      final newChild = ChildModel(
        id: const Uuid().v4(),
        parentId: parentId,
        name: name,
        age: int.parse(ageString),
        gender: gender,
        userAvatarUrl: uploadedImageUrl,
        specialNeeds: specialNeeds,
        remarks: remarks,
        createdAt: DateTime.now(),
      );

      await ref.read(childRepositoryProvider).saveChild(newChild);
    });
  }
}
