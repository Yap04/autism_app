import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/models/dashboard_stats_model.dart';
import '../../providers/repository_providers.dart';

final dashboardStatsProvider = FutureProvider.autoDispose<DashboardStatsModel>((
  ref,
) async {
  final repository = ref.read(dashboardRepositoryProvider);
  return repository.getDashboardStats();
});
