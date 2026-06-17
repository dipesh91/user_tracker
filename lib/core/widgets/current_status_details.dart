import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_tracker/core/consts/app_colors.dart';
import 'package:user_tracker/core/utils/app_date_time.dart';

class CurrentStatusDetails {
  static Widget notCheckedIn(
    BuildContext context, {
    required VoidCallback onPunchIn,
  }) {
    return Column(
      spacing: 4.sp,
      children: [
        Text(
          '--:-- AM',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppColors.grey.withOpacity(0.8),
          ),
        ),
        Text(
          'You haven\'t punched in yet',
          style: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(color: AppColors.grey),
        ),
        10.verticalSpace,
        CupertinoButton.filled(
          onPressed: onPunchIn,
          sizeStyle: CupertinoButtonSize.large,
          color: Colors.green,
          minimumSize: Size(double.infinity, 16.sp),
          child: const Text('Punch In'),
        ),
      ],
    );
  }

  static Widget checkedIn(
    BuildContext context, {
    required String punchInAt,
    required VoidCallback onPunchOut,
    required VoidCallback onTakeBreak,
  }) {
    return Column(
      spacing: 4.sp,
      children: [
        Text('Checked In At', style: Theme.of(context).textTheme.labelLarge),
        Text(
          punchInAt,
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        8.verticalSpace,

        StreamBuilder(
          stream: Stream.periodic(const Duration(minutes: 1)),
          builder: (context, _) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Working Since  ',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                Text(
                  AppDateTime.elapsedSince(punchInAt),
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            );
          },
        ),
        14.verticalSpace,
        Row(
          children: [
            Expanded(
              child: CupertinoButton.filled(
                onPressed: onPunchOut,
                sizeStyle: CupertinoButtonSize.large,
                color: AppColors.primaryColor,
                minimumSize: Size(double.infinity, 20.sp),
                child: const Text('Punch Out'),
              ),
            ),
            10.horizontalSpace,
            Expanded(
              child: CupertinoButton.filled(
                onPressed: onTakeBreak,
                sizeStyle: CupertinoButtonSize.large,
                color: Colors.deepOrange.withOpacity(0.8),
                minimumSize: Size(double.infinity, 20.sp),
                child: const Text('Take Break'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  static Widget inBreak(
    BuildContext context, {
    required String? breakStartedAt,
    required String? breakType,
    required VoidCallback onEndBreak,
  }) {
    final breakLabel = breakType == 'lunch'
        ? 'Lunch Break'
        : breakType == 'tea'
        ? 'Tea Break'
        : 'Break';

    return Column(
      spacing: 4.sp,
      children: [
        Text(
          '$breakLabel started at',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        Text(
          breakStartedAt?.isNotEmpty == true ? breakStartedAt! : '--:-- --',
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        8.verticalSpace,

        StreamBuilder(
          stream: Stream.periodic(const Duration(minutes: 1)),
          builder: (context, _) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Break Since  ',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                Text(
                  AppDateTime.elapsedSince(breakStartedAt),
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.deepOrange,
                  ),
                ),
              ],
            );
          },
        ),
        10.verticalSpace,
        CupertinoButton.filled(
          onPressed: onEndBreak,
          sizeStyle: CupertinoButtonSize.large,
          color: Colors.deepOrangeAccent.withOpacity(0.9),
          minimumSize: Size(double.infinity, 16.sp),
          child: const Text('End Break'),
        ),
      ],
    );
  }

  static Widget checkedOut(
    BuildContext context, {
    required String punchOutAt,
    required String? punchInAt,
    required String? breakMinutes,
    required VoidCallback onPunchInAgain,
  }) {
    return Column(
      spacing: 6.sp,
      children: [
        Text('Punched Out At', style: Theme.of(context).textTheme.labelLarge),
        Text(
          punchOutAt,
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        8.verticalSpace,
        if (punchInAt != null && punchInAt.isNotEmpty)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Total Worked  ',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              Text(
                _totalWorked(punchInAt, punchOutAt, breakMinutes),
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        Text(
          'Great work today! 🎉',
          style: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(color: AppColors.grey),
        ),
        12.verticalSpace,
        CupertinoButton.filled(
          onPressed: onPunchInAgain,
          sizeStyle: CupertinoButtonSize.large,
          color: Colors.green,
          minimumSize: Size(double.infinity, 16.sp),
          child: const Text('Punch In Again'),
        ),
      ],
    );
  }

  static String _totalWorked(
    String punchInAt,
    String punchOutAt,
    String? breakMinutes,
  ) {
    final inTime = AppDateTime.parseTime(punchInAt);
    final outTime = AppDateTime.parseTime(punchOutAt);
    if (inTime == null || outTime == null) return '--h --m';
    final breakMins = int.tryParse(breakMinutes ?? '0') ?? 0;
    final worked = outTime.difference(inTime) - Duration(minutes: breakMins);
    return AppDateTime.formatDuration(worked);
  }
}
