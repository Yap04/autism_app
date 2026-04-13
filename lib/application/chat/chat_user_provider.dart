import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/user_model.dart';
import '../providers/repository_providers.dart';

final userByIdProvider = FutureProvider.family<UserModel?, String>((
  ref,
  userId,
) async {
  if (userId.isEmpty) return null;
  return ref.read(userRepositoryProvider).getUserById(userId);
});
