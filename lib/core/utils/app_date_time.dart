import 'package:user_tracker/core/consts/app_string.dart';

class AppDateTime {
  static String todayDate({bool withoutWeek = false, DateTime? dateTime}) {
    final now = dateTime ?? DateTime.now();
    final weekday = AppString.weeks[now.weekday - 1];
    final date = now.day;
    final month = AppString.monthsList[now.month - 1];
    final year = now.year;
    return withoutWeek ? '$date $month $year' : '$weekday, $date $month $year';
  }

  static String monthYear({DateTime? dateTime}) {
    final now = dateTime ?? DateTime.now();
    final month = AppString.monthsList[now.month - 1];
    final year = now.year;
    return '$month $year';
  }

  static String greeting() {
    final hour = DateTime.now().hour;
    if (hour > 5 && hour < 12) return 'Good Morning';
    if (hour >= 12 && hour < 17) return 'Good Afternoon';
    if (hour >= 17 && hour < 21) return 'Good Evening';
    return 'Good Night';
  }

  static String currentTime() {
    final now = DateTime.now();
    final hour = now.hour;
    final minute = now.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final h = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '${h.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
  }

  static DateTime? parseTime(String? timeStr) {
    if (timeStr == null || timeStr.trim().isEmpty) return null;
    try {
      final parts = timeStr.trim().split(' ');
      final timeParts = parts[0].split(':');
      var hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);
      final period = parts[1].toUpperCase();
      if (period == 'PM' && hour != 12) hour += 12;
      if (period == 'AM' && hour == 12) hour = 0;
      final now = DateTime.now();
      return DateTime(now.year, now.month, now.day, hour, minute);
    } catch (_) {
      return null;
    }
  }

  static String formatDuration(Duration? d) {
    if (d == null) return '--h --m';
    if (d.isNegative) return '00h 00m';
    final h = d.inHours.toString().padLeft(2, '0');
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    return '${h}h ${m}m';
  }

  static String elapsedSince(String? timeStr) {
    final from = parseTime(timeStr);
    if (from == null) return '--h --m';
    return formatDuration(DateTime.now().difference(from));
  }

  static String minutesToFormatted(String? minutes) {
    final mins = int.tryParse(minutes ?? '0') ?? 0;
    return formatDuration(Duration(minutes: mins));
  }

  static DateTime? parseDateStr(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return null;
    try {
      final parts = dateStr.trim().split(' ');
      final day = int.parse(parts[0]);
      final month = AppString.monthsList.indexOf(parts[1]) + 1;
      final year = int.parse(parts[2]);
      return DateTime(year, month, day);
    } catch (_) {
      return null;
    }
  }

  static bool isToday(String? dateStr) =>
      todayDate(withoutWeek: true) == dateStr;

  static bool isSunday(String? dateStr) =>
      parseDateStr(dateStr)?.weekday == DateTime.sunday;
}
