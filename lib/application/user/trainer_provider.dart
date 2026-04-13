import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/models/user_model.dart';
import '../providers/repository_providers.dart';

part 'trainer_provider.g.dart';

@riverpod
Future<List<UserModel>> trainerList(TrainerListRef ref) async {
  try {
    final snapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .where('role', isEqualTo: UserRole.trainer.name)
            .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return UserModel.fromJson(data);
    }).toList();
  } catch (e) {
    throw Exception('Failed to Fetch Trainer List: $e');
  }
}

final fetchTrainerProvider = FutureProvider.family<UserModel?, String>((
  ref,
  trainerId,
) async {
  if (trainerId.isEmpty) return null;
  return ref.read(userRepositoryProvider).getUserById(trainerId);
});
