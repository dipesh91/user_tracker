import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_tracker/core/consts/app_colors.dart';
import 'package:user_tracker/core/utils/app_date_time.dart';
import 'package:user_tracker/core/widgets/app_loading.dart';
import 'package:user_tracker/features/reportScreen/logic/report_notifier.dart';
import 'package:user_tracker/features/reportScreen/widgets/report_shared_widgets.dart';
import 'package:user_tracker/providers/service_providers.dart';

class MonthlyReport extends ConsumerWidget {
  const MonthlyReport({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(monthlyReportProvider.notifier);
    final currentMonth = ref.watch(monthlyReportProvider);
    final monthKey = AppDateTime.monthYear(dateTime: currentMonth);

    return ref
        .watch(monthlyStatusProvider(monthKey))
        .when(
          data: (records) {
            final summary = computeSummary(records);
            final weeklyHours = monthlyWeeklyHours(records);

            final barGroups = List.generate(
              5,
              (i) => BarChartGroupData(
                x: i + 1,
                barRods: [
                  BarChartRodData(
                    toY: weeklyHours[i] == 0 ? 0.3 : weeklyHours[i],
                    color: weeklyHours[i] == 0
                        ? Colors.transparent
                        : AppColors.primaryColor,
                    width: 28,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(6),
                    ),
                    label: BarChartRodLabel(
                      show: true,
                      text: hoursLabel(weeklyHours[i]),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            );

            return Column(
              children: [
                20.verticalSpace,
                PeriodHeader(
                  label: monthKey.toUpperCase(),
                  onPrevious: notifier.previousMonth,
                  onNext: notifier.isCurrentMonth ? null : notifier.nextMonth,
                ),
                10.verticalSpace,
                SummaryBoxRow(
                  leftLabel: 'Total Working Time',
                  leftValue: summary.totalWorked,
                  rightLabel: 'Total Break Time',
                  rightValue: summary.totalBreak,
                ),
                10.verticalSpace,
                Expanded(
                  child: BarChart(
                    BarChartData(
                      borderData: FlBorderData(
                        border: const Border(bottom: BorderSide()),
                      ),
                      maxY: 60,
                      gridData: const FlGridData(show: false),
                      barTouchData: BarTouchData(enabled: false),
                      titlesData: FlTitlesData(
                        rightTitles: const AxisTitles(),
                        topTitles: const AxisTitles(),
                        leftTitles: const AxisTitles(),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (v, _) {
                              const labels = [
                                'Week 1',
                                'Week 2',
                                'Week 3',
                                'Week 4',
                                'Week 5',
                              ];
                              final i = v.toInt() - 1;
                              return Text(
                                labels[i],
                                style: TextStyle(fontSize: 11.sp),
                              );
                            },
                          ),
                        ),
                      ),
                      barGroups: barGroups,
                    ),
                  ),
                ),
                10.verticalSpace,
                DetailCard(
                  title: 'This Month Summary',
                  rows: [
                    DetailRow(
                      title: 'Working Days',
                      data: '${summary.workingDays} days',
                    ),
                    DetailRow(title: 'Overtime', data: summary.overtime),
                    DetailRow(
                      title: 'Total Break Time',
                      data: summary.totalBreak,
                      color: AppColors.primaryColor,
                    ),
                    DetailRow(
                      title: 'Net Working Time',
                      data: summary.totalWorked,
                      color: AppColors.primaryColor,
                    ),
                  ],
                ),
                20.verticalSpace,
              ],
            );
          },
          error: (_, _) => Center(
            child: Text(
              'No data for this month',
              style: TextStyle(color: AppColors.grey),
            ),
          ),
          loading: () => appLoading(),
        );
  }
}
