import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_tracker/core/widgets/app_layout.dart';
import 'package:user_tracker/features/reportScreen/logic/report_notifier.dart';
import 'package:user_tracker/features/reportScreen/screens/daily_report.dart';
import 'package:user_tracker/features/reportScreen/screens/monthly_report.dart';
import 'package:user_tracker/features/reportScreen/screens/weekly_report.dart';
import 'package:user_tracker/features/reportScreen/widgets/tab_button.dart';
import 'package:user_tracker/providers/ui_provider.dart';

class ReportScreen extends ConsumerWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedTabProvider);

    return AppLayout(
      child: Column(
        children: [
          20.verticalSpace,
          SizedBox(
            height: 50.h,
            child: Row(
              children: [
                ReportTabButton(
                  title: 'Daily',
                  isSelected: selected == ReportOf.day,
                  onTap: () => ref.read(selectedTabProvider.notifier).state =
                      ReportOf.day,
                ),
                10.horizontalSpace,
                ReportTabButton(
                  title: 'Weekly',
                  isSelected: selected == ReportOf.week,
                  onTap: () => ref.read(selectedTabProvider.notifier).state =
                      ReportOf.week,
                ),
                10.horizontalSpace,
                ReportTabButton(
                  title: 'Monthly',
                  isSelected: selected == ReportOf.month,
                  onTap: () => ref.read(selectedTabProvider.notifier).state =
                      ReportOf.month,
                ),
              ],
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: selected.index,
              children: const [DailyReport(), WeeklyReport(), MonthlyReport()],
            ),
          ),
        ],
      ),
    );
  }
}
