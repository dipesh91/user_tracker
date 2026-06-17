import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:user_tracker/core/consts/app_colors.dart';
import 'package:user_tracker/core/themes/app_box_decorations.dart';
import 'package:user_tracker/core/utils/app_date_time.dart';
import 'package:user_tracker/data/models/attendance_model.dart';
import 'package:user_tracker/data/models/break_model.dart';

class BreaksBox extends StatelessWidget {
  final AttendanceModel data;

  const BreaksBox({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final breaks = [
      BreakModel(
        name: 'Lunch Break',
        icon: FontAwesomeIcons.utensils,
        color: AppColors.lunchBreak,
        time: '30 min allowed',
        taken: data.lunchBreak,
        type: 'lunch',
      ),
      BreakModel(
        name: 'Tea Break',
        icon: FontAwesomeIcons.mugHot,
        color: AppColors.teaBreak,
        time: '15 min allowed',
        taken: data.teaBreak,
        type: 'tea',
      ),
      if (data.otherBreak != null)
        BreakModel(
          name: 'Other Break',
          icon: FontAwesomeIcons.personWalking,
          color: AppColors.grey,
          time: 'No Specific limit',
          taken: data.otherBreak,
          type: 'other',
        ),
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 12.sp),
      decoration: AppBoxDecorations.simple(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: 'Break ',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
              children: [
                TextSpan(
                  text: '(Today)',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(color: AppColors.grey),
                ),
              ],
            ),
          ),
          SizedBox(
            height: data.otherBreak == null ? 130.h : 200.h,
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: breaks.length,
              itemBuilder: (context, i) {
                final b = breaks[i];
                final takenMins = int.tryParse(b.taken ?? '0') ?? 0;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: EdgeInsets.all(8.sp),
                    decoration: BoxDecoration(
                      color: b.color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: FaIcon(b.icon, color: b.color),
                  ),
                  title: Text(b.name),
                  subtitle: Text(
                    b.time,
                    style: TextStyle(color: AppColors.grey, fontSize: 12.sp),
                  ),
                  trailing: Text(
                    takenMins > 0
                        ? AppDateTime.minutesToFormatted(b.taken)
                        : 'Not taken yet',
                    style: TextStyle(
                      color: takenMins > 0 ? b.color : AppColors.grey,
                      fontWeight: takenMins > 0
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
