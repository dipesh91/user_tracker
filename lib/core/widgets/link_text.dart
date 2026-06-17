import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_tracker/core/consts/app_colors.dart';

Row linkText(
  BuildContext context, {
  required String title,
  required String link,
  required void Function() onTap,
  MainAxisAlignment alignment = MainAxisAlignment.center,
}) {
  return Row(
    spacing: 4.sp,
    mainAxisAlignment: alignment,
    children: [
      Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
      ),
      GestureDetector(
        onTap: onTap,
        child: Text(
          link,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
        ),
      ),
    ],
  );
}
