import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:user_tracker/core/consts/app_colors.dart';
import 'package:user_tracker/providers/ui_provider.dart';

// ignore: must_be_immutable
class AppButton extends ConsumerWidget {
  GlobalKey<FormState> formKey;
  bool clickable;
  String title, textOnLoading;
  Future<void> Function() onTap;

  AppButton({
    super.key,
    required this.formKey,
    this.clickable = true,
    required this.textOnLoading,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authLoadingProvider);
    return CupertinoButton.filled(
      color: AppColors.primaryColor,
      disabledColor: AppColors.primaryColor.withOpacity(0.4),
      minimumSize: Size(double.infinity, 16),
      borderRadius: BorderRadius.circular(8),
      onPressed: clickable && !isLoading
          ? () async {
              try {
                FocusScope.of(context).unfocus();
                ref.read(authLoadingProvider.notifier).state = true;
                await Future.delayed(Duration(seconds: 1));
                if (formKey.currentState!.validate()) {
                  await onTap();
                }
              } finally {
                ref.read(authLoadingProvider.notifier).state = false;
              }
            }
          : null,
      child: clickable && isLoading
          ? Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 10.sp,
              children: [
                LoadingAnimationWidget.fourRotatingDots(
                  color: Colors.white,
                  size: 16.sp,
                ),
                Text(textOnLoading),
              ],
            )
          : Text(
              title,
              style: TextStyle(
                color: clickable ? Colors.white : AppColors.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }
}
