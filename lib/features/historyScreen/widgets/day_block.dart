import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_tracker/core/consts/app_colors.dart';
import 'package:user_tracker/core/consts/app_enums.dart';
import 'package:user_tracker/core/themes/app_box_decorations.dart';
import 'package:user_tracker/core/utils/app_date_time.dart';
import 'package:user_tracker/data/models/attendance_model.dart';
import 'package:user_tracker/features/reportScreen/logic/report_notifier.dart';
import 'package:user_tracker/providers/ui_provider.dart';

class DayBlock extends ConsumerWidget {
  final AttendanceModel day;

  const DayBlock({super.key, required this.day});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isToday = AppDateTime.isToday(day.workDate);
    final inTime = AppDateTime.parseTime(day.punchInAt);
    final outTime = AppDateTime.parseTime(day.punchOutAt);
    final breakMins = int.tryParse(day.breakMinutes ?? '0') ?? 0;
    final totalDuration = (inTime != null && outTime != null)
        ? outTime.difference(inTime) - Duration(minutes: breakMins)
        : null;

    return GestureDetector(
      onTap: () {
        ref
            .read(dailyReportProvider.notifier)
            .selectedDate(AppDateTime.parseDateStr(day.workDate)!);
        ref.read(selectedTabProvider.notifier).state = .day;
        ref.read(currentPageIndexProvider.notifier).state =
            Screens.reportScreen.index;
      },
      child: Container(
        margin: EdgeInsets.only(top: 10.sp),
        padding: EdgeInsets.all(12.sp),
        decoration: isToday
            ? AppBoxDecorations.simple(
                context,
                color: AppColors.primaryColor.withOpacity(0.08),
              )
            : AppBoxDecorations.simple(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(context, isToday: isToday),

            14.verticalSpace,
            _attendanceRow(totalDuration),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context, {required bool isToday}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          day.workDate ?? '',
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        if (isToday)
          _badge(label: 'Today', icon: null, color: AppColors.primaryColor),
      ],
    );
  }

  Widget _badge({
    required String label,
    required IconData? icon,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 2.sp),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12.sp, color: color),
            4.horizontalSpace,
          ],
          Text(label, style: TextStyle(color: color, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _attendanceRow(Duration? totalDuration) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _detail('In Time', day.punchInAt ?? '--:--'),
        _detail('Out Time', day.punchOutAt ?? '--:--'),
        _detail(
          'Total',
          AppDateTime.formatDuration(totalDuration),
          color: AppColors.primaryColor,
          align: CrossAxisAlignment.end,
        ),
      ],
    );
  }

  Column _detail(
    String title,
    String value, {
    Color? color,
    CrossAxisAlignment align = CrossAxisAlignment.start,
  }) {
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(title, style: TextStyle(color: AppColors.grey, fontSize: 13)),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
