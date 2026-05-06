import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/user_model.dart';
import '../providers/repository_providers.dart';

part 'user_provider.g.dart';

@riverpod
Stream<UserModel?> liveUserStream(LiveUserStreamRef ref, String userId) {
  return ref.read(userRepositoryProvider).watchUser(userId);
}
