import '../models/user_model.dart';

abstract class UserRepository {
  Future<UserModel?> getUserById(String uid);

  Future<void> saveUser(UserModel user);

  Future<void> updateUser(UserModel user);

  Future<List<UserModel>> getTrainers();

  Stream<List<UserModel>> watchAllUsers();

  Future<void> updateUserStatus(String userId, UserStatus status);

  Future<List<UserModel>> getPendingTrainers();

  Future<String?> getUserFcmToken(String uid);

  Future<void> updateUserFcmToken(String uid, String token);
}
