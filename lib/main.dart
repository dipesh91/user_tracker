import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:user_tracker/core/consts/app_colors.dart';
import 'package:user_tracker/core/navigation/main_navigation.dart';
import 'package:user_tracker/core/themes/app_theme_data.dart';
import 'package:user_tracker/data/services/notification_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:user_tracker/providers/ui_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'assets/.env');
  await Supabase.initialize(
    url: dotenv.get('supabaseUrl'),
    anonKey: dotenv.get('supabaseAnonKey'),
  );

  await NotificationService.initialize();

  final prefs = await SharedPreferences.getInstance();
  final savedDark = prefs.getBool('isDarkMode') ?? false;
  AppColors.setTheme(savedDark);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeModeProvider).value ?? false;
    AppColors.setTheme(isDark);

    return ScreenUtilInit(
      designSize: Size(400, 888.9),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, _) => MaterialApp(
        title: 'User Tracker',
        debugShowCheckedModeBanner: false,
        theme: AppThemeData.lightTheme(),
        darkTheme: AppThemeData.darkTheme(),
        themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
        localizationsDelegates:
            MonthYearPickerLocalizations.localizationsDelegates,
        home: MainNavigation(),
      ),
    );
  }
}
