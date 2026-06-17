import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_tracker/core/consts/app_colors.dart';
import 'package:user_tracker/core/themes/app_box_decorations.dart';
import 'package:user_tracker/core/utils/app_date_time.dart';
import 'package:user_tracker/features/homeScreen/widgets/greeting_header.dart';

class HolidayCard extends StatelessWidget {
  const HolidayCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          20.verticalSpace,
          GreetingHeader(),
          Spacer(),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 24.sp, vertical: 32.sp),
            decoration: AppBoxDecorations.gradientBox(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('🎉', style: TextStyle(fontSize: 56.sp)),
                16.verticalSpace,
                Text(
                  'Today is a Holiday!',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
                10.verticalSpace,
                Text(
                  'It\'s Sunday — enjoy your day off.\nNo check-in required today.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.grey,
                    fontWeight: FontWeight.w500,
                    height: 1.6,
                  ),
                ),
                24.verticalSpace,
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.sp,
                    vertical: 10.sp,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      8.horizontalSpace,
                      Text(
                        AppDateTime.todayDate(),
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
