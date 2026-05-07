import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

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
                      'Total GMV',
                      'RM ${stats.totalGmv.toStringAsFixed(2)}',
                      Icons.show_chart,
                      ThemeColor.orange,
                    ),
                    24.widthBox,
                    _buildStatCard(
                      'Net Profit',
                      'RM ${stats.netProfit.toStringAsFixed(2)}',
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
                        title: 'GMV Trend (Last 6 Months)',
                        child: _buildRevenueBarChart(stats.monthlyGmv),
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

  Widget _buildRevenueBarChart(List<double> monthlyRevenue) {
    var maxRevenue = monthlyRevenue.isEmpty ? 5000 : monthlyRevenue.reduce(max);
    if (maxRevenue < 1000) maxRevenue = 1000;
    final calculatedMaxY = maxRevenue * 1.2;

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: calculatedMaxY,
        barTouchData: const BarTouchData(enabled: true),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              reservedSize: 40,
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                final index = value.toInt();
                if (index < 0 || index > 5) {
                  return emptyBox;
                }

                final now = DateTime.now();
                final targetDate = DateTime(now.year, now.month - (5 - index));
                final monthStr = DateFormat('MMM').format(targetDate);

                final style = AppWidget.bodySmall().copyWith(
                  color: ThemeColor.grey100,
                  fontWeight: FontWeight.bold,
                );

                return SideTitleWidget(
                  meta: meta,
                  space: 10,
                  child: Text(monthStr, style: style),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                if (value == 0) return emptyBox;

                String text;
                if (value >= 1000) {
                  text = '${(value / 1000).toStringAsFixed(1)}k';
                } else {
                  text = value.toStringAsFixed(0);
                }

                return Text(
                  text,
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
          horizontalInterval: calculatedMaxY / 5,
          getDrawingHorizontalLine:
              (value) => FlLine(
                color: ThemeColor.lightGrey.withValues(alpha: 0.5),
                strokeWidth: 1,
              ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(6, (index) {
          final yValue =
              index < monthlyRevenue.length ? monthlyRevenue[index] : 0.0;
          return _makeBarData(index, yValue);
        }),
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
