import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/models/user_model.dart';
import '../../providers/repository_providers.dart';

final allUsersStreamProvider = StreamProvider.autoDispose<List<UserModel>>((
  ref,
) {
  final repo = ref.watch(userRepositoryProvider);
  return repo.watchAllUsers();
});

final userRoleFilterProvider = StateProvider<String>((ref) => 'All');
