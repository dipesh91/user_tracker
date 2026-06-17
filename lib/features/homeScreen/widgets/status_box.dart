import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_tracker/core/consts/app_colors.dart';
import 'package:user_tracker/core/consts/app_enums.dart';
import 'package:user_tracker/core/themes/app_box_decorations.dart';
import 'package:user_tracker/core/widgets/current_status_details.dart';
import 'package:user_tracker/core/widgets/show_break_picker.dart';
import 'package:user_tracker/core/widgets/status_badge.dart';
import 'package:user_tracker/data/models/attendance_model.dart';
import 'package:user_tracker/providers/service_providers.dart';

class StatusBox extends ConsumerWidget {
  final AttendanceModel data;

  const StatusBox({super.key, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedContainer(
      padding: EdgeInsets.all(14.sp),
      decoration: AppBoxDecorations.statusBox(data.currentStatus),
      duration: const Duration(milliseconds: 400),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Current Status',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500),
              ),
              statusBadge(status: data.currentStatus),
            ],
          ),
          20.verticalSpace,
          switch (data.currentStatus) {
            // if not checked in
            CurrentStatus.notCheckedIn => CurrentStatusDetails.notCheckedIn(
              context,
              onPunchIn: () async =>
                  await ref.read(attendanceProvider).punchIn(),
            ),

            // if checked in
            CurrentStatus.checkedIn => CurrentStatusDetails.checkedIn(
              context,
              punchInAt: data.punchInAt ?? '--:--',
              onPunchOut: () async {
                if (DateTime.now().isAfter(
                  DateTime.now().copyWith(hour: 18, minute: 0, second: 0),
                )) {
                  await ref.read(attendanceProvider).punchOut();
                } else {
                  _punchBeforeTimeDialog(context, ref);
                }
              },
              onTakeBreak: () => showBreakPicker(context, ref),
            ),

            // if in break
            CurrentStatus.inBreak => CurrentStatusDetails.inBreak(
              context,
              breakStartedAt: data.breakStartedAt,
              breakType: data.breakType,
              onEndBreak: () async =>
                  await ref.read(attendanceProvider).endBreak(data),
            ),

            // if checked out
            CurrentStatus.checkedOut => CurrentStatusDetails.checkedOut(
              context,
              punchOutAt: data.punchOutAt ?? '--:--',
              punchInAt: data.punchInAt,
              breakMinutes: data.breakMinutes,
              onPunchInAgain: () async =>
                  await ref.read(attendanceProvider).punchInAgain(data),
            ),
          },
        ],
      ),
    );
  }

  void _punchBeforeTimeDialog(BuildContext context, WidgetRef ref) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.8),
      builder: (context) {
        return CupertinoAlertDialog(
          content: Text(
            'You are trying to punch out before 6:00 PM.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          actions: [
            CupertinoButton.filled(
              onPressed: () async {
                Navigator.pop(context);
                await ref.read(attendanceProvider).punchOut();
              },
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.zero,
              child: Text('Punch Out'),
            ),
            CupertinoButton.filled(
              onPressed: () {
                Navigator.pop(context);
                showBreakPicker(context, ref);
              },
              borderRadius: BorderRadius.zero,
              color: Colors.deepOrange.withOpacity(0.8),
              child: Text('Take Break'),
            ),
          ],
        );
      },
    );
  }
}
