import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_tracker/core/consts/app_colors.dart';
import 'package:user_tracker/core/themes/app_box_decorations.dart';
import 'package:user_tracker/features/homeScreen/widgets/greeting_header.dart';
import 'package:user_tracker/providers/service_providers.dart';

class FailedValidationCard extends ConsumerWidget {
  const FailedValidationCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                Text('🚫', style: TextStyle(fontSize: 56.sp)),
                16.verticalSpace,
                Text(
                  'Office Access Required',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
                10.verticalSpace,
                Text(
                  'You are currently outside the office network and location range.\n\nPlease connect to the office WiFi or move closer to the office to continue.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.grey,
                    fontWeight: FontWeight.w500,
                    height: 1.6,
                  ),
                ),
                8.verticalSpace,
                CupertinoButton.tinted(
                  onPressed: () => ref.refresh(officeAccessProvider),
                  color: AppColors.primaryColor,
                  sizeStyle: CupertinoButtonSize.medium,
                  child: Text(' Refresh'),
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
