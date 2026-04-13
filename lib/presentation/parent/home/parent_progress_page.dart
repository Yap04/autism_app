import 'package:auto_route/auto_route.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../core/constant/color_constant.dart';
import '../../../core/constant/textstyle_constant.dart';
import '../../../core/extension/widget_ext.dart';
import '../../shared/curved_header_background.dart';

@RoutePage()
class ParentProgressPage extends StatelessWidget {
  const ParentProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.cream,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            CurvedHeaderBackground(
              customHeight: MediaQuery.of(context).padding.top + 150,
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => context.router.maybePop(),
                          child: Container(
                            color: Colors.transparent,
                            padding: const EdgeInsets.only(
                              right: 12,
                              top: 8,
                              bottom: 8,
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios_new,
                              color: ThemeColor.black,
                              size: 20,
                            ),
                          ),
                        ),
                        Text(
                          'Performance',
                          style: AppWidget.h2TextFieldStyle(),
                        ),
                      ],
                    ),
                    24.heightBox,

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: ThemeColor.white,
                        borderRadius: BorderRadius.circular(20),
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
                            'Ringkasan Bulan Ini',
                            style: AppWidget.h3TextFieldStyle(),
                          ),
                          8.heightBox,
                          Text(
                            'Overall improvement in coordination.\nExcellent attendance!',
                            style: AppWidget.bodyMedium(),
                          ),
                        ],
                      ),
                    ),
                    28.heightBox,

                    Text(
                      'Overall Performance Score',
                      style: AppWidget.h3TextFieldStyle(),
                    ),
                    16.heightBox,

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      height: 220,
                      width: double.infinity,
                      child: LineChart(
                        LineChartData(
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
                                reservedSize: 30,
                                interval: 1,
                                getTitlesWidget: (value, meta) {
                                  var text = '';
                                  switch (value.toInt()) {
                                    case 0:
                                      text = 'Jan 2026';
                                    case 1:
                                      text = 'Feb 2026';
                                    case 2:
                                      text = 'Mac 2026';
                                    case 3:
                                      text = 'Apr 2026';
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      text,
                                      style: AppWidget.bodySmall().copyWith(
                                        color: ThemeColor.grey100,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          minX: 0,
                          maxX: 2,
                          minY: 0,
                          maxY: 100,
                          lineBarsData: [
                            LineChartBarData(
                              spots: const [
                                FlSpot(0, 20),
                                FlSpot(1, 48),
                                FlSpot(2, 95),
                              ],
                              isCurved: true,
                              color: ThemeColor.darkBlue,
                              barWidth: 4, // 线的粗细
                              isStrokeCapRound: true,
                              belowBarData: BarAreaData(
                                show: true,
                                color: ThemeColor.aquaBlue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    28.heightBox,

                    Text('Latest Records', style: AppWidget.h3TextFieldStyle()),
                    12.heightBox,
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: ThemeColor.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: ThemeColor.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              const CircleAvatar(
                                radius: 30,
                                backgroundColor: ThemeColor.grey100,
                                child: Icon(
                                  Icons.person,
                                  color: ThemeColor.white,
                                  size: 36,
                                ),
                              ),
                              8.heightBox,
                              Text(
                                'Coach Dave',
                                style: AppWidget.bodySmall().copyWith(
                                  color: ThemeColor.grey100,
                                ),
                              ),
                            ],
                          ),
                          16.widthBox,

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '11 Mac: Sesi Renang',
                                      style: AppWidget.bodyLarge().copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 20,
                                    ),
                                  ],
                                ),
                                6.heightBox,
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: ThemeColor.aquaBlue,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.pool, size: 14),
                                      4.widthBox,
                                      Text(
                                        'swimming',
                                        style: AppWidget.bodySmall().copyWith(
                                          color: ThemeColor.black,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                8.heightBox,
                                Text(
                                  'Focused well on balance drills. Continued progress in stroke mechanics.',
                                  style: AppWidget.bodyMedium().copyWith(
                                    color: ThemeColor.grey100,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    20.heightBox,

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 24,
                      ),
                      decoration: BoxDecoration(
                        color: ThemeColor.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: ThemeColor.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Attendance: 95%',
                            style: AppWidget.h3TextFieldStyle(),
                          ),
                          const SizedBox(
                            height: 50,
                            width: 50,
                            child: CircularProgressIndicator(
                              value: 0.95,
                              strokeWidth: 8,
                              backgroundColor: ThemeColor.lightGrey,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                ThemeColor.darkBlue,
                              ),
                            ),
                          ),
                        ],
                      ),
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
}
