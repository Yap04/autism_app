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

      final revenueQuery =
          await _firestore
              .collectionGroup('transactions')
              .where('paymentChannel', isEqualTo: 'stripe')
              .where('status', isEqualTo: 'completed')
              .get();

      var totalRevenue = 0.0;

      for (final doc in revenueQuery.docs) {
        final data = doc.data();
        final amount = (data['amount'] as num?)?.toDouble() ?? 0.0;

        if (amount > 0) {
          totalRevenue += amount;
        }
      }

      return DashboardStatsModel(
        totalUsers: totalUsers,
        activeTrainers: totalTrainers,
        totalRevenue: totalRevenue,
        totalParents: totalParents,
        totalAdmins: totalAdmins,
      );
    } catch (e) {
      throw Exception('Failed to fetch dashboard stats: $e');
    }
  }
}
