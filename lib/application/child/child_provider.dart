import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/child_model.dart';
import '../auth/auth_notifier.dart';
import '../providers/repository_providers.dart';

part 'child_provider.g.dart';

@riverpod
Stream<List<ChildModel>> userChildren(UserChildrenRef ref) {
  final currentUser = ref.watch(authNotifierProvider).value;

  if (currentUser == null) {
    return Stream.value([]);
  }

  return ref
      .watch(childRepositoryProvider)
      .watchChildrenByParentId(currentUser.id);
}
