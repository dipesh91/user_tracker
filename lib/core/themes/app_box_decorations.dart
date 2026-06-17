import 'package:flutter/material.dart';
import 'package:user_tracker/core/consts/app_colors.dart';
import 'package:user_tracker/core/consts/app_enums.dart';

class AppBoxDecorations {
  static BoxDecoration statusBox(CurrentStatus status) {
    final color = AppColors.getStatusColor(status);
    return BoxDecoration(
      color: color.withOpacity(0.2),
      border: Border.all(color: color),
      borderRadius: BorderRadius.circular(10),
    );
  }

  static BoxDecoration simple(BuildContext context, {Color? color}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BoxDecoration(
      color: color ?? AppColors.cardColor,
      border: Border.all(
        color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
      ),
      borderRadius: BorderRadius.circular(10),
    );
  }

  static BoxDecoration breakBox(Color color) {
    return BoxDecoration(
      color: color.withOpacity(0.05),
      border: Border.all(color: color.withOpacity(0.3)),
      borderRadius: BorderRadius.circular(10),
    );
  }

  static BoxDecoration tabButton() {
    return BoxDecoration(
      color: Colors.green,
      border: Border.all(color: AppColors.grey),
      borderRadius: BorderRadius.circular(10),
    );
  }

  static BoxDecoration gradientBox() {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          AppColors.primaryColor.withOpacity(0.12),
          AppColors.teaBreak.withOpacity(0.18),
          AppColors.lunchBreak.withOpacity(0.12),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      border: Border.all(color: AppColors.primaryColor.withOpacity(0.3)),
      borderRadius: BorderRadius.circular(20),
    );
  }
}
