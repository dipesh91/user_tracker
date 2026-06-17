import 'package:flutter/material.dart';
import 'package:user_tracker/core/consts/app_enums.dart';

class AppColors {
  static const Color primaryColor = Color(0xff429108);
  static const Color profileBackground = Color(0xff68c1ff);
  static const Color textLink = Color(0xff4a9e13);
  static const Color lunchBreak = Color(0xffda712f);
  static const Color teaBreak = Color(0xff4083ba);

  static Color white = Color(0xffffffff);
  static Color black = Color(0xFF191919);
  static Color grey = Colors.grey.shade700;
  static Color cardColor = Color(0xffffffff);
  static Color borderColor = Color(0xffE0E0E0);
  static Color inputFill = Color(0xfff5f5f5);

  static void setTheme(bool isDark) {
    if (isDark) {
      white = Color(0xff121212);
      black = Color(0xffF0F0F0);
      grey = Colors.grey.shade400;
      cardColor = Color(0xff1E1E1E);
      borderColor = Color(0xff333333);
      inputFill = Color(0xff2a2a2a);
    } else {
      white = Color(0xffffffff);
      black = Color(0xFF191919);
      grey = Colors.grey.shade700;
      cardColor = Color(0xffffffff);
      borderColor = Color(0xffE0E0E0);
      inputFill = Color(0xfff5f5f5);
    }
  }

  static ColorSwatch<int> getStatusColor(CurrentStatus status) {
    switch (status) {
      case CurrentStatus.checkedIn:
        return Colors.green;
      case CurrentStatus.inBreak:
        return Colors.orange;
      case CurrentStatus.checkedOut:
        return Colors.red;
      case CurrentStatus.notCheckedIn:
        return Colors.grey;
    }
  }
}
