import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:user_tracker/core/consts/app_enums.dart';
import 'package:user_tracker/core/utils/app_date_time.dart';
import 'package:user_tracker/core/utils/save_in_device.dart';
import 'package:user_tracker/features/reportScreen/logic/report_notifier.dart';

// for page index
final currentPageIndexProvider = StateProvider((_) => Screens.homeScreen.index);

//for fields (show password , change auth way , loading state)
final isObscureProvider = StateProvider((_) => true);
final authPageProvider = StateProvider((_) => true);
final authLoadingProvider = StateProvider((_) => false);

//for current Status box
final currentStateProvider = StateProvider((_) => CurrentStatus.notCheckedIn);

//for report screen
final selectedMonthProvider = StateProvider((_) => AppDateTime.monthYear());
final selectedTabProvider = StateProvider((_) => ReportOf.day);

//for theme mode
class ThemeModeNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    return await GetFromDevice.themeMode();
  }

  Future<void> set(bool isDark) async {
    await SaveInDevice.themeMode(themeMode: isDark);
    state = AsyncData(isDark);
  }
}

final themeModeProvider = AsyncNotifierProvider<ThemeModeNotifier, bool>(
  ThemeModeNotifier.new,
);
