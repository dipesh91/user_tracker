import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:user_tracker/core/consts/app_colors.dart';
import 'package:user_tracker/core/themes/app_box_decorations.dart';
import 'package:user_tracker/providers/service_providers.dart';

void showBreakPicker(BuildContext context, WidgetRef ref) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
    ),
    builder: (_) => Padding(
      padding: EdgeInsets.all(20.sp),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Break Type',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          16.verticalSpace,
          _breakOption(
            context,
            icon: FontAwesomeIcons.utensils,
            color: AppColors.lunchBreak,
            label: 'Lunch Break',
            subtitle: '30 min',
            onTap: () async {
              Navigator.pop(context);
              await ref.read(attendanceProvider).startBreak('lunch');
            },
          ),
          12.verticalSpace,
          _breakOption(
            context,
            icon: FontAwesomeIcons.mugHot,
            color: AppColors.teaBreak,
            label: 'Tea Break',
            subtitle: '15 min',
            onTap: () async {
              Navigator.pop(context);
              await ref.read(attendanceProvider).startBreak('tea');
            },
          ),
          12.verticalSpace,
          _breakOption(
            context,
            icon: FontAwesomeIcons.personWalking,
            color: AppColors.grey,
            label: 'Other Break',
            subtitle: '',
            onTap: () async {
              Navigator.pop(context);
              await ref.read(attendanceProvider).startBreak('other');
            },
          ),
          20.verticalSpace,
        ],
      ),
    ),
  );
}

Widget _breakOption(
  BuildContext context, {
  required FaIconData icon,
  required Color color,
  required String label,
  required String subtitle,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(10.r),
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 12.sp),
      decoration: AppBoxDecorations.breakBox(color),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.sp),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: FaIcon(icon, color: color, size: 18.sp),
          ),
          12.horizontalSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),
              ),
              if (subtitle.isNotEmpty)
                Text(
                  subtitle,
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall?.copyWith(color: AppColors.grey),
                ),
            ],
          ),
        ],
      ),
    ),
  );
}
