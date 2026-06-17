import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:user_tracker/core/consts/app_enums.dart';
import 'package:user_tracker/core/utils/current_status_conversion.dart';

class AttendanceModel {
  String? workDate,
      punchInAt,
      punchOutAt,
      breakMinutes,
      lunchBreak,
      teaBreak,
      otherBreak,
      breakStartedAt,
      breakType;
  CurrentStatus currentStatus;

  AttendanceModel({
    required this.workDate,
    this.punchInAt,
    this.punchOutAt,
    this.breakMinutes,
    this.currentStatus = CurrentStatus.notCheckedIn,
    this.lunchBreak,
    this.teaBreak,
    this.otherBreak,
    this.breakStartedAt,
    this.breakType,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) =>
      AttendanceModel(
        workDate: json['work_date'] ?? '',
        punchInAt: json['punch_in_at'],
        punchOutAt: json['punch_out_at'],
        breakMinutes: json['break_minutes'],
        lunchBreak: json['lunch_break'],
        teaBreak: json['tea_break'],
        otherBreak: json['other_break'],
        breakStartedAt: json['break_started_at'],
        breakType: json['break_type'],
        currentStatus: CurrentStatusConversion.fetchStatusFromText(
          json['current_status'] ?? '',
        ),
      );

  Map<String, dynamic> toMap() => {
    'user_id': Supabase.instance.client.auth.currentUser!.id,
    'work_date': workDate,
    'punch_in_at': punchInAt,
    'punch_out_at': punchOutAt,
    'break_minutes': breakMinutes,
    'lunch_break': lunchBreak,
    'tea_break': teaBreak,
    'other_break': otherBreak,
    'break_started_at': breakStartedAt,
    'break_type': breakType,
    'current_status': CurrentStatusConversion.fetchTextFromStatus(
      currentStatus,
    ),
  };
}
