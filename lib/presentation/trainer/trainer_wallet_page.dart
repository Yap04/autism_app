import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../core/constant/color_constant.dart';
import '../../core/constant/textstyle_constant.dart';
import '../../core/extension/widget_ext.dart';
import '../shared/curved_header_background.dart';

class TrainerWalletPage extends StatelessWidget {
  const TrainerWalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.cream,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            CurvedHeaderBackground(
              customHeight: MediaQuery.of(context).padding.top + 160,
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('My Wallet', style: AppWidget.h2TextFieldStyle()),
                        const CircleAvatar(
                          radius: 20,
                          backgroundColor: ThemeColor.white,
                          child: Icon(
                            Icons.person,
                            color: ThemeColor.grey100,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                    24.heightBox,

                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: ThemeColor.white,
                        borderRadius: BorderRadius.circular(24),
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
                          Text(
                            'Withdrawable Balance',
                            style: AppWidget.bodyMedium().copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          16.heightBox,
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: ThemeColor.aquaBlue.withValues(
                                  alpha: 0.8,
                                ),
                                child: const Icon(
                                  Icons.sync,
                                  color: ThemeColor.white,
                                  size: 18,
                                ),
                              ),
                              12.widthBox,
                              Text(
                                'RM 1,500.00',
                                style: AppWidget.h1TextFieldStyle(),
                              ),
                            ],
                          ),
                          24.heightBox,
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: ThemeColor.darkBlue,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.account_balance_wallet,
                                    color: ThemeColor.white,
                                    size: 20,
                                  ),
                                  8.widthBox,
                                  Text(
                                    'Withdraw Money',
                                    style: AppWidget.bodyMedium().copyWith(
                                      color: ThemeColor.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    32.heightBox,

                    Text(
                      'Revenue Overview',
                      style: AppWidget.h3TextFieldStyle(),
                    ),
                    4.heightBox,
                    Text('Total Monthly Income', style: AppWidget.bodySmall()),
                    20.heightBox,

                    SizedBox(
                      height: 200,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          gridData: FlGridData(
                            drawVerticalLine: false,
                            horizontalInterval: 25,
                            getDrawingHorizontalLine: (value) {
                              return const FlLine(
                                color: ThemeColor.lightGrey,
                                strokeWidth: 1,
                              );
                            },
                          ),
                          borderData: FlBorderData(show: false),
                          titlesData: FlTitlesData(
                            topTitles: const AxisTitles(),
                            rightTitles: const AxisTitles(),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 25,
                                reservedSize: 30,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    value.toInt().toString(),
                                    style: AppWidget.bodySmall().copyWith(
                                      color: ThemeColor.grey100,
                                    ),
                                  );
                                },
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  var text = '';
                                  switch (value.toInt()) {
                                    case 0:
                                      text = 'Dec 2025';
                                    case 1:
                                      text = 'Jan 2026';
                                    case 2:
                                      text = 'Feb 2026';
                                    case 3:
                                      text = 'Mac 2026';
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      text,
                                      style: AppWidget.bodySmall(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          maxY: 100,
                          barGroups: [
                            _buildBarGroup(0, 38),
                            _buildBarGroup(1, 58),
                            _buildBarGroup(2, 80),
                            _buildBarGroup(3, 95),
                          ],
                        ),
                      ),
                    ),
                    32.heightBox,

                    Text(
                      'Transaction History',
                      style: AppWidget.h3TextFieldStyle(),
                    ),
                    16.heightBox,

                    _buildTransactionCard(
                      title: 'Mac 11: Swimming Session\n(Ahmad)',
                      subtitle: 'Swimming',
                      amount: '+ RM 80.00',
                      isPositive: true,
                      icon: Icons.person,
                    ),
                    _buildTransactionCard(
                      title: 'Mac 5: Withdrawl Money',
                      subtitle: '',
                      amount: '- RM 1,000.00',
                      isPositive: false,
                      icon: Icons.account_balance,
                    ),

                    40.heightBox,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _buildBarGroup(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: ThemeColor.aquaBlue.withValues(alpha: 0.9),
          width: 36,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionCard({
    required String title,
    required String subtitle,
    required String amount,
    required bool isPositive,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeColor.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: ThemeColor.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: ThemeColor.grey100.withValues(alpha: 0.2),
            child: Icon(icon, color: ThemeColor.darkBlue, size: 24),
          ),
          16.widthBox,

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppWidget.bodyMedium().copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (subtitle.isNotEmpty) ...[
                  4.heightBox,
                  Row(
                    children: [
                      const Icon(
                        Icons.pool,
                        size: 14,
                        color: ThemeColor.darkBlue,
                      ),
                      4.widthBox,
                      Text(subtitle, style: AppWidget.bodySmall()),
                    ],
                  ),
                ],
              ],
            ),
          ),

          Text(
            amount,
            style: AppWidget.bodyMedium().copyWith(
              fontWeight: FontWeight.bold,
              color: isPositive ? ThemeColor.green : ThemeColor.negative,
            ),
          ),
        ],
      ),
    );
  }
}
