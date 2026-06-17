import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_tracker/core/consts/app_colors.dart';
import 'package:user_tracker/core/consts/app_enums.dart';
import 'package:user_tracker/core/utils/app_date_time.dart';
import 'package:user_tracker/core/widgets/app_loading.dart';
import 'package:user_tracker/features/reportScreen/logic/report_notifier.dart';
import 'package:user_tracker/features/reportScreen/widgets/report_shared_widgets.dart';
import 'package:user_tracker/providers/service_providers.dart';

class DailyReport extends ConsumerWidget {
  const DailyReport({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(dailyReportProvider.notifier);
    final currentDate = ref.watch(dailyReportProvider);
    final formattedDay = AppDateTime.todayDate(
      withoutWeek: true,
      dateTime: currentDate,
    );

    return ref
        .watch(dayStatusProvider(formattedDay))
        .when(
          data: (list) {
            print('------------------>>>>>>>}}}}}}}}}');
            print('------------------${list.first.toMap()}');
            final data = list.isEmpty ? null : list.first;

            final inT = AppDateTime.parseTime(data?.punchInAt);
            final outT = AppDateTime.parseTime(data?.punchOutAt);
            final breakMins = int.tryParse(data?.breakMinutes ?? '0') ?? 0;
            final lunchMins = int.tryParse(data?.lunchBreak ?? '0') ?? 0;
            final teaMins = int.tryParse(data?.teaBreak ?? '0') ?? 0;
            final otherMins = int.tryParse(data?.otherBreak ?? '0') ?? 0;
            Duration? workedDuration;
            if (inT != null && outT != null) {
              workedDuration =
                  outT.difference(inT) - Duration(minutes: breakMins);
            } else if (inT != null &&
                data?.currentStatus != CurrentStatus.notCheckedIn) {
              workedDuration =
                  DateTime.now().difference(inT) - Duration(minutes: breakMins);
            }
            if (workedDuration == null) return _emptyState(context);

            final inOfficeTime = AppDateTime.formatDuration(
              workedDuration + Duration(minutes: breakMins),
            );

            final totalWorked = AppDateTime.formatDuration(workedDuration);
            final totalBreak = AppDateTime.minutesToFormatted(
              data?.breakMinutes,
            );

            final workMins = workedDuration.inMinutes.toDouble();

            final noData =
                data == null ||
                data.currentStatus == CurrentStatus.notCheckedIn;

            return Column(
              children: [
                20.verticalSpace,
                PeriodHeader(
                  label: formattedDay,
                  onTap: () async {
                    DateTime? date = await showDatePicker(
                      context: context,
                      firstDate: DateTime(1999),
                      lastDate: DateTime.now(),
                      initialDate: currentDate,
                    );
                    if (date != null) {
                      notifier.selectedDate(date);
                    }
                  },
                  onPrevious: notifier.previousDay,
                  onNext: notifier.isToday ? null : notifier.nextDay,
                ),
                10.verticalSpace,
                SummaryBoxRow(
                  leftLabel: 'Total Working Time',
                  leftValue: totalWorked,
                  rightLabel: 'Total Break Time',
                  rightValue: totalBreak,
                ),
                10.verticalSpace,
                noData
                    ? Expanded(child: _emptyState(context))
                    : Expanded(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            PieChart(
                              PieChartData(
                                centerSpaceRadius: 80.r,
                                sectionsSpace: 2.sp,
                                startDegreeOffset: 270,
                                sections: [
                                  if (workMins > 0)
                                    _pieSection(
                                      workMins,
                                      AppColors.primaryColor,
                                    ),
                                  if (lunchMins > 0)
                                    _pieSection(
                                      lunchMins.toDouble(),
                                      AppColors.lunchBreak,
                                    ),
                                  if (teaMins > 0)
                                    _pieSection(
                                      teaMins.toDouble(),
                                      AppColors.teaBreak,
                                    ),
                                  if (otherMins > 0)
                                    _pieSection(
                                      otherMins.toDouble(),
                                      AppColors.grey,
                                    ),
                                ],
                              ),
                              duration: Duration(milliseconds: 400),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  inOfficeTime,
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Total',
                                  style: TextStyle(color: AppColors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                if (!noData) ...[
                  10.verticalSpace,
                  _legend(lunchMins, teaMins, otherMins, workMins.toInt()),
                ],
                10.verticalSpace,
                DetailCard(
                  title: 'Details',
                  rows: [
                    DetailRow(
                      title: 'In Time',
                      data: data?.punchInAt ?? '--:--',
                    ),
                    DetailRow(
                      title: 'Out Time',
                      data: data?.punchOutAt ?? '--:--',
                    ),
                    DetailRow(
                      title: 'Total Working Time',
                      data: totalWorked,
                      color: AppColors.primaryColor,
                    ),
                    DetailRow(
                      title: 'Total Break Time',
                      data: totalBreak,
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
              'No data for this date',
              style: TextStyle(color: AppColors.grey),
            ),
          ),
          loading: () => appLoading(),
        );
  }

  PieChartSectionData _pieSection(double value, Color color) =>
      PieChartSectionData(
        value: value,
        showTitle: false,
        radius: 50.r,
        color: color,
      );

  Widget _legend(int lunchMins, int teaMins, int otherMins, int totalWorked) {
    return Wrap(
      spacing: 12.sp,
      runSpacing: 6.sp,
      children: [
        _dot(AppColors.primaryColor, 'Working', totalWorked.toString()),
        if (lunchMins > 0)
          _dot(AppColors.lunchBreak, 'Lunch Break', lunchMins.toString()),
        if (teaMins > 0)
          _dot(AppColors.teaBreak, 'Tea Break', teaMins.toString()),
        if (otherMins > 0)
          _dot(AppColors.grey, 'Other Break', otherMins.toString()),
      ],
    );
  }

  Widget _dot(Color color, String label, String time) => Row(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      CircleAvatar(backgroundColor: color, radius: 5.r),
      6.horizontalSpace,
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 12.sp, color: AppColors.grey),
          ),
          Text(
            AppDateTime.minutesToFormatted(time),
            style: TextStyle(fontSize: 12.sp, color: AppColors.grey),
          ),
        ],
      ),
    ],
  );

  Widget _emptyState(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.event_busy_outlined,
          size: 56.sp,
          color: AppColors.grey.withOpacity(0.5),
        ),
        12.verticalSpace,
        Text(
          'No attendance data',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: AppColors.grey),
        ),
      ],
    ),
  );
}
