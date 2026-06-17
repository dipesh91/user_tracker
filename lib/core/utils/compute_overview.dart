import 'package:user_tracker/core/consts/app_string.dart';
import 'package:user_tracker/core/utils/app_date_time.dart';
import 'package:user_tracker/data/models/attendance_model.dart';

class OverviewValues {
  final String workingTime;
  final String breakTime;
  final String remaining;

  OverviewValues({
    required this.workingTime,
    required this.breakTime,
    required this.remaining,
  });
}

OverviewValues computeOverview(AttendanceModel data) {
  final punchIn = AppDateTime.parseTime(data.punchInAt);
  final breakMins = int.tryParse(data.breakMinutes ?? '0') ?? 0;
  final notStarted = data.currentStatus.index == 0; // notCheckedIn

  if (punchIn == null || notStarted) {
    return OverviewValues(
      workingTime: '--h --m',
      breakTime: '--h --m',
      remaining: '--h --m',
    );
  }

  final elapsed =
      DateTime.now().difference(punchIn) - Duration(minutes: breakMins);
  final remaining = AppString.officeOut.difference(DateTime.now());

  return OverviewValues(
    workingTime: AppDateTime.formatDuration(elapsed),
    breakTime: AppDateTime.minutesToFormatted(data.breakMinutes),
    remaining: remaining.isNegative
        ? '00h 00m'
        : AppDateTime.formatDuration(remaining),
  );
}
