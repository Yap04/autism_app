import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/models/user_model.dart';
import '../providers/repository_providers.dart';

part 'chat_user_provider.g.dart';

@riverpod
Future<UserModel?> userById(UserByIdRef ref, String userId) async {
  if (userId.isEmpty) return null;

  return ref.watch(userRepositoryProvider).getUserById(userId);
}
