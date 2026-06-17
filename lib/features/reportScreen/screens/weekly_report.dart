import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_tracker/core/consts/app_colors.dart';
import 'package:user_tracker/core/utils/app_date_time.dart';
import 'package:user_tracker/core/widgets/app_loading.dart';
import 'package:user_tracker/data/models/attendance_model.dart';
import 'package:user_tracker/features/reportScreen/logic/report_notifier.dart';
import 'package:user_tracker/features/reportScreen/widgets/report_shared_widgets.dart';
import 'package:user_tracker/providers/service_providers.dart';

class WeeklyReport extends ConsumerWidget {
  const WeeklyReport({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(weeklyReportProvider.notifier);
    final currentWeek = ref.watch(weeklyReportProvider);
    final monthKey = AppDateTime.monthYear(dateTime: currentWeek);

    return ref
        .watch(monthlyStatusProvider(monthKey))
        .when(
          data: (allData) {
            final dataMap = <String, AttendanceModel>{};
            for (final d in allData) {
              if (d.workDate != null) dataMap[d.workDate!] = d;
            }

            final weekDays = notifier.weekDays;
            final weekLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
            final barGroups = <BarChartGroupData>[];
            final weekRecords = <AttendanceModel>[];

            for (int i = 0; i < weekDays.length; i++) {
              final key = AppDateTime.todayDate(
                withoutWeek: true,
                dateTime: weekDays[i],
              );
              final rec = dataMap[key];
              final h = rec != null ? workedHours(rec) : 0.0;
              if (rec != null) weekRecords.add(rec);
              barGroups.add(_bar(x: i, y: h));
            }

            final summary = computeSummary(weekRecords);

            return Column(
              children: [
                20.verticalSpace,
                PeriodHeader(
                  label: notifier.weekLabel,
                  onPrevious: notifier.previousWeek,
                  onNext: notifier.isCurrentWeek ? null : notifier.nextWeek,
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
                        border: Border(bottom: BorderSide()),
                      ),
                      maxY: 12,
                      gridData: FlGridData(show: false),
                      barTouchData: BarTouchData(enabled: false),
                      titlesData: FlTitlesData(
                        rightTitles: AxisTitles(),
                        topTitles: AxisTitles(),
                        leftTitles: AxisTitles(),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (v, _) {
                              final i = v.toInt();
                              return Text(
                                weekLabels[i],
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
                  title: 'This Week Summary',
                  rows: [
                    DetailRow(title: 'Regular Hours', data: '40h 00m'),
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
            child: Text('No data', style: TextStyle(color: AppColors.grey)),
          ),
          loading: () => appLoading(),
        );
  }

  BarChartGroupData _bar({required int x, required double y}) =>
      BarChartGroupData(
        x: x,
        barRods: [
          BarChartRodData(
            toY: y == 0 ? 0.3 : y,
            color: y == 0 ? Colors.transparent : AppColors.primaryColor,
            width: 20,
            borderRadius: BorderRadius.vertical(top: Radius.circular(6)),
            label: BarChartRodLabel(
              show: true,
              text: hoursLabel(y),
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ],
      );
}
