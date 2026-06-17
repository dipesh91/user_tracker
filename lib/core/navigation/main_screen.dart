import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import 'package:user_tracker/core/consts/app_colors.dart';
import 'package:user_tracker/features/historyScreen/screens/history_screen.dart';
import 'package:user_tracker/features/homeScreen/screens/home_screen.dart';
import 'package:user_tracker/features/profileScreen/screens/profile_screen.dart';
import 'package:user_tracker/features/reportScreen/screens/report_screen.dart';
import 'package:user_tracker/providers/ui_provider.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  final _titles = ['Dashboard', 'History', 'Report', 'Profile'];

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(currentPageIndexProvider);
    final textStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
      color: AppColors.primaryColor,
      fontWeight: FontWeight.bold,
    );
    return Scaffold(
      appBar: AppBar(title: Text(_titles[currentIndex])),
      bottomNavigationBar: StylishBottomBar(
        backgroundColor: AppColors.cardColor,
        currentIndex: currentIndex,
        onTap: (i) => ref.read(currentPageIndexProvider.notifier).state = i,
        items: [
          BottomBarItem(
            icon: Icon(CupertinoIcons.house_fill, size: 24.sp),
            title: Text('Home', style: textStyle),
          ),
          BottomBarItem(
            icon: Icon(Icons.history_edu, size: 24.sp),
            title: Text('History', style: textStyle),
          ),
          BottomBarItem(
            icon: Icon(CupertinoIcons.doc_chart, size: 24.sp),
            title: Text('Report', style: textStyle),
          ),
          BottomBarItem(
            icon: Icon(CupertinoIcons.person, size: 24.sp),
            title: Text('Profile', style: textStyle),
          ),
        ],
        option: DotBarOptions(
          gradient: RadialGradient(
            colors: [AppColors.profileBackground, AppColors.primaryColor],
          ),
        ),
      ),
      body: IndexedStack(
        index: currentIndex,
        children: [
          HomeScreen(),
          HistoryScreen(),
          ReportScreen(),
          ProfileScreen(),
        ],
      ),
    );
  }
}
