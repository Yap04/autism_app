abstract class AuthRepository {
  Future<String> loginWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<String> signUpWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> signOut();

  Future<String?> getCurrentUserId();

  Future<void> sendPasswordResetEmail({required String email});
}
