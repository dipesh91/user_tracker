import 'package:flutter_riverpod/legacy.dart';
import 'package:user_tracker/core/consts/app_string.dart';
import 'package:user_tracker/core/utils/app_date_time.dart';
import 'package:user_tracker/data/models/attendance_model.dart';

enum ReportOf { day, week, month }

class DailyReportNotifier extends StateNotifier<DateTime> {
  DailyReportNotifier() : super(DateTime.now());

  void previousDay() => state = state.subtract(const Duration(days: 1));

  void nextDay() {
    final tomorrow = state.add(const Duration(days: 1));
    if (tomorrow.isBefore(DateTime.now().add(const Duration(days: 1)))) {
      state = tomorrow;
    }
  }

  void selectedDate(DateTime date) => state = date;

  bool get isToday {
    final now = DateTime.now();
    return state.year == now.year &&
        state.month == now.month &&
        state.day == now.day;
  }

  String get formattedDay =>
      AppDateTime.todayDate(withoutWeek: true, dateTime: state);
}

final dailyReportProvider =
    StateNotifierProvider<DailyReportNotifier, DateTime>(
      (_) => DailyReportNotifier(),
    );

class WeeklyReportNotifier extends StateNotifier<DateTime> {
  WeeklyReportNotifier() : super(_mondayOf(DateTime.now()));

  static DateTime _mondayOf(DateTime d) {
    final monday = d.subtract(Duration(days: d.weekday - 1));
    return DateTime(monday.year, monday.month, monday.day);
  }

  void previousWeek() => state = state.subtract(const Duration(days: 7));

  void nextWeek() {
    if (!isCurrentWeek) state = state.add(const Duration(days: 7));
  }

  bool get isCurrentWeek {
    final monday = _mondayOf(DateTime.now());
    return state.year == monday.year &&
        state.month == monday.month &&
        state.day == monday.day;
  }

  List<DateTime> get weekDays =>
      List.generate(6, (i) => state.add(Duration(days: i)));

  DateTime get weekEnd => state.add(const Duration(days: 5));

  String get weekLabel {
    final start = '${state.day} ${AppString.monthsList[state.month - 1]}';
    final end =
        '${weekEnd.day} ${AppString.monthsList[weekEnd.month - 1]} ${weekEnd.year}';
    return '$start - $end';
  }

  String get monthKey => AppDateTime.monthYear(dateTime: state);
}

final weeklyReportProvider =
    StateNotifierProvider<WeeklyReportNotifier, DateTime>(
      (_) => WeeklyReportNotifier(),
    );

class MonthlyReportNotifier extends StateNotifier<DateTime> {
  MonthlyReportNotifier()
    : super(DateTime(DateTime.now().year, DateTime.now().month));

  void previousMonth() => state = DateTime(state.year, state.month - 1);

  void nextMonth() {
    if (!isCurrentMonth) {
      state = DateTime(state.year, state.month + 1);
    }
  }

  bool get isCurrentMonth {
    final now = DateTime.now();
    return state.year == now.year && state.month == now.month;
  }

  String get monthKey => AppDateTime.monthYear(dateTime: state);
}

final monthlyReportProvider =
    StateNotifierProvider<MonthlyReportNotifier, DateTime>(
      (_) => MonthlyReportNotifier(),
    );

class AttendanceSummary {
  final String totalWorked;
  final String totalBreak;
  final String overtime;
  final int workingDays;
  final double workedMinutes;
  final double breakMinutes;

  const AttendanceSummary({
    required this.totalWorked,
    required this.totalBreak,
    required this.overtime,
    required this.workingDays,
    required this.workedMinutes,
    required this.breakMinutes,
  });
}

AttendanceSummary computeSummary(
  List<AttendanceModel> records, {
  int regularHoursPerDay = 8,
}) {
  double totalWorkedMins = 0;
  double totalBreakMins = 0;

  for (final r in records) {
    final inT = AppDateTime.parseTime(r.punchInAt);
    final outT = AppDateTime.parseTime(r.punchOutAt);
    final brk = int.tryParse(r.breakMinutes ?? '0') ?? 0;
    if (inT != null && outT != null) {
      totalWorkedMins += outT.difference(inT).inMinutes - brk;
      totalBreakMins += brk;
    }
  }

  final regularMins = records.length * regularHoursPerDay * 60;
  final overTimeMins = (totalWorkedMins - regularMins).clamp(
    0,
    double.infinity,
  );

  return AttendanceSummary(
    totalWorked: AppDateTime.formatDuration(
      Duration(minutes: totalWorkedMins.round()),
    ),
    totalBreak: AppDateTime.formatDuration(
      Duration(minutes: totalBreakMins.round()),
    ),
    overtime: AppDateTime.formatDuration(
      Duration(minutes: overTimeMins.round()),
    ),
    workingDays: records.length,
    workedMinutes: totalWorkedMins,
    breakMinutes: totalBreakMins,
  );
}

double workedHours(AttendanceModel r) {
  final inT = AppDateTime.parseTime(r.punchInAt);
  final outT = AppDateTime.parseTime(r.punchOutAt);
  final brk = int.tryParse(r.breakMinutes ?? '0') ?? 0;
  if (inT == null || outT == null) return 0;
  return (outT.difference(inT).inMinutes - brk) / 60.0;
}

String hoursLabel(double y) {
  if (y == 0) return '';
  final dur = Duration(minutes: (y * 60).round());
  final h = dur.inHours;
  final m = dur.inMinutes.remainder(60);
  return m == 0 ? '${h}h' : '${h}h ${m}m';
}

List<double> monthlyWeeklyHours(List<AttendanceModel> records) {
  final buckets = [0.0, 0.0, 0.0, 0.0, 0.0];
  for (final r in records) {
    if (r.workDate == null) continue;
    final day = int.tryParse(r.workDate!.split(' ').first) ?? 1;
    final bucket = ((day - 1) ~/ 7).clamp(0, 4);
    buckets[bucket] += workedHours(r);
  }
  return buckets;
}
