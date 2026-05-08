import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/user_model.dart';
import '../providers/repository_providers.dart';

part 'auth_notifier.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  Future<void> _updateDeviceToken(String uid) async {
    if (kIsWeb) {
      return;
    }

    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await ref.read(userRepositoryProvider).updateUserFcmToken(uid, token);
      }
    } catch (e) {
      print('⚠️ Failed to update FCM token: $e');
    }
  }

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

      _updateDeviceToken(uid);

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
        verificationStatus:
            role == UserRole.trainer
                ? VerificationStatus.pending
                : VerificationStatus.none,
        createdAt: DateTime.now(),
      );
      await userRepo.saveUser(newUser);

      _updateDeviceToken(uid);

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

      _updateDeviceToken(uid);

      return user;
    });
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final currentUser = state.value;
      if (currentUser != null) {
        await ref
            .read(userRepositoryProvider)
            .updateUserFcmToken(currentUser.id, '');
      }
      await ref.read(authRepositoryProvider).signOut();
      return null;
    });
  }

  void updateLocalUser(UserModel updatedUser) {
    state = AsyncData(updatedUser);
  }

  // For Trainers:

  Future<void> toggleAcceptingRequests(bool value) async {
    final currentUser = state.value;
    if (currentUser == null) {
      return;
    }

    final updatedUser = currentUser.copyWith(isAcceptingRequests: value);
    state = AsyncData(updatedUser);

    try {
      await ref.read(userRepositoryProvider).updateUser(updatedUser);
    } catch (e) {
      state = AsyncData(currentUser);
      rethrow;
    }
  }

  Future<void> pauseAcceptingRequests(Duration? duration) async {
    final currentUser = state.value;
    if (currentUser == null) {
      return;
    }

    DateTime? resumeTime;
    if (duration != null) {
      resumeTime = DateTime.now().add(duration);
    }

    final updatedUser = currentUser.copyWith(
      isAcceptingRequests: false,
      resumeAt: resumeTime,
    );

    state = AsyncData(updatedUser);
    await ref.read(userRepositoryProvider).updateUser(updatedUser);
  }

  Future<void> resumeAcceptingRequests() async {
    final currentUser = state.value;
    if (currentUser == null) {
      return;
    }

    final updatedUser = currentUser.copyWith(
      isAcceptingRequests: true,
      resumeAt: null,
    );

    state = AsyncData(updatedUser);
    await ref.read(userRepositoryProvider).updateUser(updatedUser);
  }

  Future<void> updatePublicProfile({
    required bool acceptsHomeBased,
    String? bio,
    String? location,
    List<String>? sports,
    double? latitude,
    double? longitude,
    double? travelSurcharge,
  }) async {
    final currentUser = state.value;
    if (currentUser == null) {
      return;
    }

    final updatedUser = currentUser.copyWith(
      bio: bio ?? currentUser.bio,
      location: location ?? currentUser.location,
      sports: sports ?? currentUser.sports,
      latitude: latitude ?? currentUser.latitude,
      longitude: longitude ?? currentUser.longitude,
      acceptsHomeBased: acceptsHomeBased,
      travelSurcharge: travelSurcharge ?? currentUser.travelSurcharge,
    );

    state = AsyncData(updatedUser);

    try {
      final userRepo = ref.read(userRepositoryProvider);
      await userRepo.updateUser(updatedUser);
    } catch (e) {
      state = AsyncData(currentUser);
      throw Exception('Failed to update profile to server: $e');
    }
  }
}
