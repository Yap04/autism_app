import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'admin_grant_cpd_notifier.g.dart';

@riverpod
class AdminGrantCpdNotifier extends _$AdminGrantCpdNotifier {
  @override
  FutureOr<void> build() {}

  Future<bool> grantPoints({required String email, required int points}) async {
    state = const AsyncLoading();

    try {
      final querySnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .where('email', isEqualTo: email.toLowerCase().trim())
              .limit(1)
              .get();

      if (querySnapshot.docs.isEmpty) {
        state = AsyncError(
          'No user found with this email.',
          StackTrace.current,
        );
        return false;
      }

      final doc = querySnapshot.docs.first;
      final data = doc.data();

      if (data['role'] != 'trainer') {
        state = AsyncError('This user is not a trainer.', StackTrace.current);
        return false;
      }

      final currentPoints = data['totalCpdPoints'] as int? ?? 0;
      final newPoints = currentPoints + points;

      await doc.reference.update({'totalCpdPoints': newPoints});

      state = const AsyncData(null);
      return true;
    } catch (e) {
      state = AsyncError('Failed to grant points: $e', StackTrace.current);
      return false;
    }
  }
}
