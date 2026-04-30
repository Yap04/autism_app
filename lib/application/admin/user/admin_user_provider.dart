import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/models/user_model.dart';
import '../../providers/repository_providers.dart';

part 'admin_user_provider.g.dart';

@riverpod
Stream<List<UserModel>> allUsersStream(AllUsersStreamRef ref) {
  final repo = ref.watch(userRepositoryProvider);
  return repo.watchAllUsers();
}

@riverpod
class UserRoleFilter extends _$UserRoleFilter {
  @override
  String build() {
    return 'All';
  }

  void setFilter(String role) {
    state = role;
  }
}
