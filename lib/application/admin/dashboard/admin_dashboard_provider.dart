import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/models/dashboard_stats_model.dart';
import '../../providers/repository_providers.dart';

part 'admin_dashboard_provider.g.dart';

@riverpod
Future<DashboardStatsModel> dashboardStats(DashboardStatsRef ref) async {
  final repository = ref.watch(dashboardRepositoryProvider);
  return repository.getDashboardStats();
}
