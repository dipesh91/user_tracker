import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:user_tracker/core/consts/app_string.dart';
import 'package:user_tracker/core/utils/app_date_time.dart';
import 'package:user_tracker/data/services/notification_service.dart';
import 'package:user_tracker/data/models/attendance_model.dart';

class AttendanceServices {
  final _supabase = Supabase.instance.client;
  late final _db = _supabase.from(AppString.attendanceTable);

  String get _userId => _supabase.auth.currentUser!.id;

  String get _today => AppDateTime.todayDate(withoutWeek: true);

  Stream<List<AttendanceModel>> getDayStatusInfo({String? day}) {
    final fetchDate = day ?? _today;
    print('--------> fetchDate: $fetchDate, userId: $_userId');

    return _supabase
        .from(AppString.attendanceTable)
        .stream(primaryKey: ['id'])
        .eq('user_id', _userId)
        .order('created_at')
        .map((rows) {
          print('--------> Total: ${rows.length} rows');
          final todayRows = rows
              .where((r) => r['work_date'] == fetchDate)
              .toList();
          print('--------> FILTERED: ${todayRows.length}');
          return todayRows.map(AttendanceModel.fromJson).toList();
        });
  }

  Stream<List<AttendanceModel>> getMonthlyStatusInfo(String month) => _supabase
      .from(AppString.attendanceTable)
      .stream(primaryKey: ['id'])
      .eq('user_id', _userId)
      .map((rows) {
        final monthly = rows
            .where((r) => r['work_date'].toString().contains(month))
            .toList();
        if (monthly.isEmpty) return <AttendanceModel>[];
        return monthly.map(AttendanceModel.fromJson).toList();
      });

  Future<void> createStatusInfo(AttendanceModel value) async {
    try {
      final existing = await _db
          .select()
          .eq('user_id', _userId)
          .eq('work_date', value.workDate ?? _today)
          .maybeSingle();

      if (existing != null) return;

      await _db.insert(value.toMap());
    } on Exception catch (e) {
      throw Exception('Error creating status info: $e');
    }
  }

  Future<void> punchIn() async {
    final time = AppDateTime.currentTime();
    await _db
        .update({'punch_in_at': time, 'current_status': 'checkedIn'})
        .eq('user_id', _userId)
        .eq('work_date', _today);
    await NotificationService.onCheckIn(time);
  }

  Future<void> punchOut() async {
    final time = AppDateTime.currentTime();
    await _db
        .update({'punch_out_at': time, 'current_status': 'checkedOut'})
        .eq('user_id', _userId)
        .eq('work_date', _today);
    await NotificationService.onCheckOut(time);
  }

  Future<void> punchInAgain(AttendanceModel current) async {
    final lastPunchOut = AppDateTime.parseTime(current.punchOutAt);
    final tt =
        DateTime.now().difference(lastPunchOut!).inMinutes +
        int.parse(current.otherBreak ?? '0');
    final totalBreak = int.parse(current.breakMinutes ?? '0') + tt;
    await _db
        .update({
          'punch_out_at': null,
          'current_status': 'checkedIn',
          'other_break': tt.toString(),
          'break_minutes': totalBreak.toString(),
        })
        .eq('user_id', _userId)
        .eq('work_date', _today);
  }

  Future<void> startBreak(String breakType) async {
    final time = AppDateTime.currentTime();
    await _db
        .update({
          'current_status': 'InBreak',
          'break_started_at': time,
          'break_type': breakType,
        })
        .eq('user_id', _userId)
        .eq('work_date', _today);
    await NotificationService.onBreakStart(
      breakType: breakType,
      startTime: time,
    );
  }

  Future<void> endBreak(AttendanceModel current) async {
    final started = AppDateTime.parseTime(current.breakStartedAt);
    final duration = started != null
        ? DateTime.now().difference(started).inMinutes
        : 0;
    final totalBreak =
        (int.tryParse(current.breakMinutes ?? '0') ?? 0) + duration;

    final updates = <String, dynamic>{
      'current_status': 'checkedIn',
      'break_started_at': null,
      'break_type': null,
      'break_minutes': totalBreak.toString(),
    };

    switch (current.breakType) {
      case 'lunch':
        updates['lunch_break'] =
            ((int.tryParse(current.lunchBreak ?? '0') ?? 0) + duration)
                .toString();
        break;
      case 'tea':
        updates['tea_break'] =
            ((int.tryParse(current.teaBreak ?? '0') ?? 0) + duration)
                .toString();
        break;
      default:
        updates['other_break'] =
            ((int.tryParse(current.otherBreak ?? '0') ?? 0) + duration)
                .toString();
    }

    await _db.update(updates).eq('user_id', _userId).eq('work_date', _today);
    await NotificationService.onBreakEnd(current.breakType ?? '');
  }
}
