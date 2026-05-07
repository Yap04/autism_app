import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/dashboard_stats_model.dart';
import '../../domain/repositories/dashboard_repository.dart';

class FirebaseDashboardRepository implements DashboardRepository {
  FirebaseDashboardRepository(this._firestore);
  final FirebaseFirestore _firestore;

  @override
  Future<DashboardStatsModel> getDashboardStats() async {
    try {
      final usersQuery = await _firestore.collection('users').count().get();
      final totalUsers = usersQuery.count ?? 0;

      final trainersQuery =
          await _firestore
              .collection('users')
              .where('role', isEqualTo: 'trainer')
              .count()
              .get();

      final parentsQuery =
          await _firestore
              .collection('users')
              .where('role', isEqualTo: 'parent')
              .count()
              .get();

      final adminsQuery =
          await _firestore
              .collection('users')
              .where('role', isEqualTo: 'admin')
              .count()
              .get();

      final totalTrainers = trainersQuery.count ?? 0;
      final totalParents = parentsQuery.count ?? 0;
      final totalAdmins = adminsQuery.count ?? 0;

      var netProfit = 0.0;
      try {
        final adminStatsDoc =
            await _firestore.collection('admin').doc('platform_stats').get();
        if (adminStatsDoc.exists) {
          netProfit =
              (adminStatsDoc.data()?['totalCommissionEarned'] as num?)
                  ?.toDouble() ??
              0.0;
        }
      } catch (e) {
        throw Exception('Failed to fetch admin stats: $e');
      }

      final gmvQuery =
          await _firestore
              .collectionGroup('transactions')
              .where('paymentChannel', isEqualTo: 'stripe')
              .where('status', isEqualTo: 'completed')
              .get();

      var totalGmv = 0.0;
      final monthlyGmv = List<double>.filled(6, 0);
      final now = DateTime.now();

      for (final doc in gmvQuery.docs) {
        final data = doc.data();

        if (data['type'] == 'refund') {
          continue;
        }

        final amount = (data['amount'] as num?)?.toDouble() ?? 0.0;
        final absoluteAmount = amount.abs();

        if (absoluteAmount > 0) {
          totalGmv += absoluteAmount;

          final createdAtRaw = data['createdAt'];
          if (createdAtRaw != null) {
            DateTime txDate;
            if (createdAtRaw is Timestamp) {
              txDate = createdAtRaw.toDate();
            } else if (createdAtRaw is String) {
              txDate = DateTime.tryParse(createdAtRaw) ?? now;
            } else {
              txDate = now;
            }

            final monthDiff =
                (now.year - txDate.year) * 12 + (now.month - txDate.month);
            if (monthDiff >= 0 && monthDiff < 6) {
              final targetIndex = 5 - monthDiff;
              monthlyGmv[targetIndex] += absoluteAmount;
            }
          }
        }
      }

      return DashboardStatsModel(
        totalUsers: totalUsers,
        activeTrainers: totalTrainers,
        totalParents: totalParents,
        totalAdmins: totalAdmins,
        totalGmv: totalGmv,
        netProfit: netProfit,
        monthlyGmv: monthlyGmv,
      );
    } catch (e) {
      throw Exception('Failed to fetch dashboard stats: $e');
    }
  }
}
