import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constant/badge_constant.dart';

part 'admin_grant_cpd_notifier.g.dart';

@riverpod
class AdminGrantCpdNotifier extends _$AdminGrantCpdNotifier {
  @override
  FutureOr<void> build() {}

  Future<Map<String, dynamic>> grantPoints({
    required String email,
    required int points,
  }) async {
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
        return {'success': false, 'newBadges': <BadgeDef>[]};
      }

      final doc = querySnapshot.docs.first;
      final data = doc.data();

      if (data['role'] != 'trainer') {
        state = AsyncError('This user is not a trainer.', StackTrace.current);
        return {'success': false, 'newBadges': <BadgeDef>[]};
      }

      final currentPoints = data['totalCpdPoints'] as int? ?? 0;
      final newPoints = currentPoints + points;

      final existingBadgeIds =
          (data['badges'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [];

      final eligibleBadgeIds =
          AppBadges.allBadges
              .where((badge) => newPoints >= badge.requiredPoints)
              .map((badge) => badge.id)
              .toList();

      final newlyUnlockedBadges =
          AppBadges.allBadges
              .where(
                (badge) =>
                    eligibleBadgeIds.contains(badge.id) &&
                    !existingBadgeIds.contains(badge.id),
              )
              .toList();

      final updateData = <String, dynamic>{'totalCpdPoints': newPoints};

      if (eligibleBadgeIds.isNotEmpty) {
        updateData['badges'] = FieldValue.arrayUnion(eligibleBadgeIds);
      }

      await doc.reference.update(updateData);

      if (newlyUnlockedBadges.isNotEmpty) {
        debugPrint(
          '🎉 Trainer unlocked new badges: ${newlyUnlockedBadges.map((b) => b.label).join(', ')}',
        );
      }

      state = const AsyncData(null);
      return {'success': true, 'newBadges': newlyUnlockedBadges};
    } catch (e) {
      state = AsyncError('Failed to grant points: $e', StackTrace.current);
      return {'success': false, 'newBadges': <BadgeDef>[]};
    }
  }
}
