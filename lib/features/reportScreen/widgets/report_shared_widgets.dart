import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_tracker/core/consts/app_colors.dart';
import 'package:user_tracker/core/themes/app_box_decorations.dart';

class SummaryBoxRow extends StatelessWidget {
  final String leftLabel;
  final String leftValue;
  final String rightLabel;
  final String rightValue;

  const SummaryBoxRow({
    super.key,
    required this.leftLabel,
    required this.leftValue,
    required this.rightLabel,
    required this.rightValue,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80.h,
      child: Row(
        children: [
          _box(context, leftLabel, leftValue),
          10.horizontalSpace,
          _box(context, rightLabel, rightValue),
        ],
      ),
    );
  }

  Expanded _box(BuildContext context, String label, String value) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12.sp),
        decoration: AppBoxDecorations.simple(context),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(color: AppColors.grey),
              textAlign: TextAlign.center,
            ),
            4.verticalSpace,
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

class PeriodHeader extends StatelessWidget {
  final String label;
  final VoidCallback onPrevious;
  final VoidCallback? onNext;
  final VoidCallback? onTap;

  const PeriodHeader({
    super.key,
    required this.label,
    required this.onPrevious,
    this.onNext,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: onPrevious,
          child: const Icon(CupertinoIcons.left_chevron),
        ),
        InkWell(
          onTap: onTap,
          child: Text(label, style: Theme.of(context).textTheme.titleMedium),
        ),
        InkWell(
          onTap: onNext,
          child: Icon(
            CupertinoIcons.right_chevron,
            color: onNext == null ? AppColors.grey.withOpacity(0.3) : null,
          ),
        ),
      ],
    );
  }
}

class DetailRow extends StatelessWidget {
  final String title;
  final String data;
  final Color? color;

  const DetailRow({
    super.key,
    required this.title,
    required this.data,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          Text(
            data,
            style: TextStyle(
              fontSize: 16.sp,
              color: color ?? Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class DetailCard extends StatelessWidget {
  final String title;
  final List<Widget> rows;

  const DetailCard({super.key, required this.title, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppBoxDecorations.simple(context),
      padding: EdgeInsets.all(12.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          8.verticalSpace,
          ...rows,
        ],
      ),
    );
  }
}
