import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:user_tracker/core/consts/app_colors.dart';
import 'package:user_tracker/core/utils/app_date_time.dart';
import 'package:user_tracker/core/widgets/app_layout.dart';
import 'package:user_tracker/core/widgets/app_loading.dart';
import 'package:user_tracker/data/models/attendance_model.dart';
import 'package:user_tracker/features/historyScreen/logic/history_notifier.dart';
import 'package:user_tracker/features/historyScreen/widgets/day_block.dart';
import 'package:user_tracker/providers/service_providers.dart';
import 'package:user_tracker/providers/ui_provider.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(historyNotifierProvider);
    final notifier = ref.read(historyNotifierProvider.notifier);
    final selectedMonth = ref.watch(selectedMonthProvider);

    return AppLayout(
      child: Column(
        children: [
          10.verticalSpace,
          _monthHeader(context, ref, notifier, selectedDate, selectedMonth),
          Expanded(
            child: ref
                .watch(monthlyStatusProvider(selectedMonth))
                .when(
                  data: (data) => data.isEmpty
                      ? _emptyState(context)
                      : _list(_sorted(data)),
                  error: (e, _) => Center(child: Text('Error: $e')),
                  loading: () => appLoading(),
                ),
          ),
        ],
      ),
    );
  }

  Widget _monthHeader(
    BuildContext context,
    WidgetRef ref,
    HistoryNotifier notifier,
    DateTime selectedDate,
    String selectedMonth,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: notifier.previousMonth,
          child: const Icon(CupertinoIcons.left_chevron),
        ),
        InkWell(
          onTap: () async {
            final picked = await showMonthYearPicker(
              context: context,
              initialDate: selectedDate,
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
            );
            if (picked != null) notifier.selectMonth(picked);
          },
          child: Text(
            selectedMonth,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        InkWell(
          onTap: notifier.canGoNext ? notifier.nextMonth : null,
          child: Icon(
            CupertinoIcons.right_chevron,
            color: notifier.canGoNext ? null : AppColors.grey.withOpacity(0.3),
          ),
        ),
      ],
    );
  }

  List<AttendanceModel> _sorted(List<AttendanceModel> data) {
    return List<AttendanceModel>.from(data)..sort((a, b) {
      final da = AppDateTime.parseDateStr(a.workDate);
      final db = AppDateTime.parseDateStr(b.workDate);
      if (da == null || db == null) return 0;
      return db.compareTo(da);
    });
  }

  Widget _list(List<AttendanceModel> data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (_, i) => DayBlock(day: data[i]),
    );
  }

  Widget _emptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 130.h,
            width: 130.w,
            child: Image.asset('assets/images/checklist.png'),
          ),
          10.verticalSpace,
          Text(
            'No history found',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          6.verticalSpace,
          Text(
            "You don't have any punch records\nfor this month.",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.grey,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
