import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/user_model.dart';
import '../providers/repository_providers.dart';

part 'auth_notifier.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  FutureOr<UserModel?> build() async {
    final authRepo = ref.watch(authRepositoryProvider);
    final userRepo = ref.watch(userRepositoryProvider);

    final uid = await authRepo.getCurrentUserId();
    if (uid != null) {
      final user = await userRepo.getUserById(uid);
      if (user != null && user.status == UserStatus.suspended) {
        await authRepo.signOut();
        return null;
      }
      return user;
    }
    return null;
  }

  Future<void> register({
    required String email,
    required String password,
    required UserRole role,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final authRepo = ref.read(authRepositoryProvider);
      final userRepo = ref.read(userRepositoryProvider);

      final uid = await authRepo.signUpWithEmailAndPassword(
        email: email,
        password: password,
      );
      final newUser = UserModel(
        id: uid,
        email: email,
        role: role,
        createdAt: DateTime.now(),
      );
      await userRepo.saveUser(newUser);

      return newUser;
    });
  }

  Future<void> login({required String email, required String password}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final authRepo = ref.read(authRepositoryProvider);
      final userRepo = ref.read(userRepositoryProvider);

      final uid = await authRepo.loginWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = await userRepo.getUserById(uid);

      if (user == null) {
        throw Exception('User not found after login');
      }

      if (user.status == UserStatus.suspended) {
        await authRepo.signOut();
        throw Exception(
          'Your account has been suspended by the administrator.',
        );
      }

      return user;
    });
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).signOut();
      return null;
    });
  }
}
