import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:user_tracker/core/consts/app_colors.dart';

Widget appLoading({String? text}) {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LoadingAnimationWidget.stretchedDots(
          color: AppColors.primaryColor,
          size: 50.sp,
        ),
        Text(text ?? ''),
      ],
    ),
  );
}
