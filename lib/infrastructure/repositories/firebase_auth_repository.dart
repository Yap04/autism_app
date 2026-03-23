import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/repositories/auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository(this._firebaseAuth);
  final FirebaseAuth _firebaseAuth;

  @override
  Future<String?> getCurrentUserId() async {
    return _firebaseAuth.currentUser?.uid;
  }

  @override
  Future<String> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user!.uid;
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleAuthError(e.code));
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<String> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user!.uid;
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleAuthError(e.code));
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    }
  }

  String _handleAuthError(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'Account with this email does not exist. Please sign up first.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'An account with this email already exists. Please sign in.';
      case 'invalid-email':
        return 'Invalid email format.';
      case 'weak-password':
        return 'Password is too weak. Please use a more complex password.';
      default:
        return 'Authentication failed with error code: $errorCode';
    }
  }
}
