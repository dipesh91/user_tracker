import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_tracker/core/consts/app_colors.dart';
import 'package:user_tracker/core/consts/app_enums.dart';

Container statusBadge({required CurrentStatus status}) {
  Color statusColor;
  String statusText;
  switch (status) {
    case CurrentStatus.checkedIn:
      statusColor = AppColors.getStatusColor(.checkedIn);
      statusText = 'Checked In';
    case CurrentStatus.inBreak:
      statusColor = AppColors.getStatusColor(.inBreak);
      statusText = 'In Break';
    case CurrentStatus.checkedOut:
      statusColor = AppColors.getStatusColor(.checkedOut);
      statusText = 'Checked Out';
    case CurrentStatus.notCheckedIn:
      statusColor = AppColors.getStatusColor(.notCheckedIn);
      statusText = 'Not Checked In';
  }

  return Container(
    padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 4.sp),
    decoration: BoxDecoration(
      color: statusColor.withOpacity(0.3),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(backgroundColor: statusColor, radius: 8.sp),
        5.horizontalSpace,
        Text(statusText),
      ],
    ),
  );
}
