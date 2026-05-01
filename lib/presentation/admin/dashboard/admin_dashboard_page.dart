import 'package:auto_route/auto_route.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/admin/dashboard/admin_dashboard_provider.dart';
import '../../../core/constant/color_constant.dart';
import '../../../core/constant/textstyle_constant.dart';
import '../../../core/extension/widget_ext.dart';

@RoutePage()
class AdminDashboardPage extends ConsumerWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsyncValue = ref.watch(dashboardStatsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Dashboard Overview', style: AppWidget.h2TextFieldStyle()),
        24.heightBox,
        statsAsyncValue.when(
          data: (stats) {
            final totalParents = stats.totalParents;
            final totalTrainers = stats.activeTrainers;
            final totalAdmins = stats.totalAdmins;

            return Column(
              children: [
                Row(
                  children: [
                    _buildStatCard(
                      'Total Users',
                      '${stats.totalUsers}',
                      Icons.people,
                      ThemeColor.blue,
                    ),
                    24.widthBox,
                    _buildStatCard(
                      'Active Trainers',
                      '$totalTrainers',
                      Icons.sports,
                      ThemeColor.orange,
                    ),
                    24.widthBox,
                    _buildStatCard(
                      'Total Revenue',
                      'RM ${stats.totalRevenue.toStringAsFixed(2)}',
                      Icons.attach_money,
                      ThemeColor.green,
                    ),
                  ],
                ),

                32.heightBox,

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildChartContainer(
                        title: 'User Distribution',
                        child: _buildUserPieChart(
                          totalParents,
                          totalTrainers,
                          totalAdmins,
                        ),
                      ),
                    ),

                    24.widthBox,

                    Expanded(
                      flex: 2,
                      child: _buildChartContainer(
                        title: 'Revenue Trend (Last 6 Months)',
                        child: _buildRevenueBarChart(),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },

          loading:
              () => const SizedBox(
                height: 120,
                child: Center(
                  child: CircularProgressIndicator(color: ThemeColor.darkBlue),
                ),
              ),

          error:
              (err, _) => Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: ThemeColor.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'Failed to load dashboard data: $err',
                  style: AppWidget.bodyMedium().copyWith(color: ThemeColor.red),
                ),
              ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: ThemeColor.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: ThemeColor.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            20.widthBox,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppWidget.bodyMedium().copyWith(
                    color: ThemeColor.grey100,
                  ),
                ),
                8.heightBox,
                Text(value, style: AppWidget.h2TextFieldStyle()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartContainer({required String title, required Widget child}) {
    return Container(
      height: 350,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: ThemeColor.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ThemeColor.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppWidget.h3TextFieldStyle()),
          24.heightBox,
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _buildUserPieChart(int parents, int trainers, int admins) {
    final total = parents + trainers + admins;
    if (total == 0) {
      return const Center(child: Text('No user data'));
    }

    final parentPct = (parents / total * 100).toStringAsFixed(1);
    final trainerPct = (trainers / total * 100).toStringAsFixed(1);
    final adminPct = (admins / total * 100).toStringAsFixed(1);

    return Row(
      children: [
        Expanded(
          child: PieChart(
            PieChartData(
              sectionsSpace: 4,
              centerSpaceRadius: 40,
              sections: [
                PieChartSectionData(
                  color: ThemeColor.blue,
                  value: parents.toDouble(),
                  title: '$parentPct%',
                  radius: 50,
                  titleStyle: AppWidget.bodySmall().copyWith(
                    color: ThemeColor.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                PieChartSectionData(
                  color: ThemeColor.orange,
                  value: trainers.toDouble(),
                  title: '$trainerPct%',
                  radius: 50,
                  titleStyle: AppWidget.bodySmall().copyWith(
                    fontWeight: FontWeight.bold,
                    color: ThemeColor.white,
                  ),
                ),
                PieChartSectionData(
                  color: ThemeColor.green,
                  value: admins.toDouble(),
                  title: '$adminPct%',
                  radius: 50,
                  titleStyle: AppWidget.bodySmall().copyWith(
                    fontWeight: FontWeight.bold,
                    color: ThemeColor.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLegend(ThemeColor.blue, 'Parents ($parents)'),
            12.heightBox,
            _buildLegend(ThemeColor.orange, 'Trainers ($trainers)'),
            12.heightBox,
            _buildLegend(ThemeColor.green, 'Admins ($admins)'),
          ],
        ),
      ],
    );
  }

  Widget _buildLegend(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        8.widthBox,
        Text(text, style: AppWidget.bodySmall()),
      ],
    );
  }

  // 2. 收入趋势柱状图 (使用 Mock 数据演示视觉效果)
  Widget _buildRevenueBarChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 5000,
        barTouchData: const BarTouchData(enabled: true),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              reservedSize: 40,
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                final style = AppWidget.bodySmall().copyWith(
                  color: ThemeColor.grey100,
                  fontWeight: FontWeight.bold,
                );
                Widget text;
                switch (value.toInt()) {
                  case 0:
                    text = Text('Nov', style: style);
                  case 1:
                    text = Text('Dec', style: style);
                  case 2:
                    text = Text('Jan', style: style);
                  case 3:
                    text = Text('Feb', style: style);
                  case 4:
                    text = Text('Mar', style: style);
                  case 5:
                    text = Text('Apr', style: style);
                  default:
                    text = Text('', style: style);
                }
                return SideTitleWidget(meta: meta, space: 10, child: text);
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                if (value == 0) {
                  return emptyBox;
                }
                return Text(
                  '${(value / 1000).toStringAsFixed(1)}k',
                  style: AppWidget.bodyExtraSmall().copyWith(
                    color: ThemeColor.grey100,
                  ),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(),
          rightTitles: const AxisTitles(),
        ),
        gridData: FlGridData(
          drawVerticalLine: false,
          horizontalInterval: 1000,
          getDrawingHorizontalLine:
              (value) => FlLine(
                color: ThemeColor.lightGrey.withValues(alpha: 0.5),
                strokeWidth: 1,
              ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: [
          _makeBarData(0, 1200),
          _makeBarData(1, 2500),
          _makeBarData(2, 1800),
          _makeBarData(3, 3200),
          _makeBarData(4, 2900),
          _makeBarData(5, 4500),
        ],
      ),
    );
  }

  BarChartGroupData _makeBarData(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: ThemeColor.green,
          width: 22,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(6),
            topRight: Radius.circular(6),
          ),
        ),
      ],
    );
  }
}
