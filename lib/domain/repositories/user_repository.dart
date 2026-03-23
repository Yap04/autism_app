import '../models/user_model.dart';

abstract class UserRepository {
  Future<UserModel?> getUserById(String uid);

  Future<void> saveUser(UserModel user);

  Future<List<UserModel>> getTrainers();

}
