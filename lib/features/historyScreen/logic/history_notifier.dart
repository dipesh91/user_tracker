import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:user_tracker/core/utils/app_date_time.dart';
import 'package:user_tracker/providers/ui_provider.dart';

class HistoryNotifier extends StateNotifier<DateTime> {
  final Ref _ref;

  HistoryNotifier(this._ref) : super(DateTime.now());

  void previousMonth() {
    state = DateTime(state.year, state.month - 1);
    _syncMonthProvider();
  }

  void nextMonth() {
    final now = DateTime.now();
    final isCurrentMonth = state.year == now.year && state.month == now.month;
    if (!isCurrentMonth) {
      state = DateTime(state.year, state.month + 1);
      _syncMonthProvider();
    }
  }

  void selectMonth(DateTime picked) {
    state = picked;
    _syncMonthProvider();
  }

  void _syncMonthProvider() {
    _ref.read(selectedMonthProvider.notifier).state = AppDateTime.monthYear(
      dateTime: state,
    );
  }

  bool get canGoNext {
    final now = DateTime.now();
    return !(state.year == now.year && state.month == now.month);
  }
}

final historyNotifierProvider =
    StateNotifierProvider<HistoryNotifier, DateTime>(HistoryNotifier.new);
