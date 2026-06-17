import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_tracker/core/consts/app_colors.dart';
import 'package:user_tracker/core/consts/app_enums.dart';
import 'package:user_tracker/core/themes/app_box_decorations.dart';
import 'package:user_tracker/core/utils/compute_overview.dart';
import 'package:user_tracker/data/models/attendance_model.dart';
import 'package:user_tracker/providers/ui_provider.dart';

class TodayOverview extends ConsumerWidget {
  final AttendanceModel data;

  const TodayOverview({super.key, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Today Overview',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            GestureDetector(
              onTap: () => ref.read(currentPageIndexProvider.notifier).state =
                  Screens.reportScreen.index,
              child: Text(
                'View Details',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: AppColors.textLink),
              ),
            ),
          ],
        ),
        6.verticalSpace,
        StreamBuilder(
          stream: Stream.periodic(const Duration(minutes: 1)),
          builder: (context, _) {
            final ov = computeOverview(data);
            final items = {
              'Working Time': ov.workingTime,
              'Break Time': ov.breakTime,
              'Remaining': ov.remaining,
            };
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: items.entries
                  .map((e) => _tile(context, e.key, e.value))
                  .toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _tile(BuildContext context, String label, String value) {
    return Container(
      decoration: AppBoxDecorations.simple(context),
      padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 12.sp),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(color: AppColors.grey),
          ),
          4.verticalSpace,
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
