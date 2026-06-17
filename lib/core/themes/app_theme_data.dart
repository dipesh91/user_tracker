import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_tracker/core/consts/app_colors.dart';
import 'package:user_tracker/core/themes/app_text_theme.dart';

class AppThemeData {
  static ThemeData lightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primaryColor,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          fontSize: 22.sp,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        toolbarHeight: 20.h,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      iconTheme: IconThemeData(size: 24.sp),
      textTheme: appTextTheme(),
      scaffoldBackgroundColor: AppColors.white,
      cardColor: AppColors.cardColor,
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryColor,
        brightness: Brightness.dark,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primaryColor,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          fontSize: 22.sp,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        toolbarHeight: 20.h,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white, size: 24.sp),
      ),
      textTheme: appTextTheme(),
      scaffoldBackgroundColor: AppColors.white,
      cardColor: AppColors.cardColor,
    );
  }
}
