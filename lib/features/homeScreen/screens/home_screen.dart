import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_tracker/core/utils/app_date_time.dart';
import 'package:user_tracker/core/widgets/app_layout.dart';
import 'package:user_tracker/core/widgets/app_loading.dart';
import 'package:user_tracker/data/models/attendance_model.dart';
import 'package:user_tracker/features/homeScreen/widgets/breaks_box.dart';
import 'package:user_tracker/features/homeScreen/widgets/failed_validation_card.dart';
import 'package:user_tracker/features/homeScreen/widgets/greeting_header.dart';
import 'package:user_tracker/features/homeScreen/widgets/holiday_card.dart';
import 'package:user_tracker/features/homeScreen/widgets/status_box.dart';
import 'package:user_tracker/features/homeScreen/widgets/today_overview.dart';
import 'package:user_tracker/providers/service_providers.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final bool _isSunday = DateTime.now().weekday == DateTime.sunday;
  bool _isCreatingRecord = false;

  @override
  Widget build(BuildContext context) {
    if (_isSunday) {
      return AppLayout(child: HolidayCard());
    }
    return AppLayout(
      child: ref
          .watch(officeAccessProvider)
          .when(
            loading: () => appLoading(text: 'Verifying office access..'),
            error: (_, _) => FailedValidationCard(),
            data: (hasOfficeAccess) {
              if (!hasOfficeAccess) return FailedValidationCard();
              return ref
                  .watch(
                    dayStatusProvider(AppDateTime.todayDate(withoutWeek: true)),
                  )
                  .when(
                    data: (list) {
                      if (list.isEmpty) {
                        if (!_isCreatingRecord) {
                          _isCreatingRecord = true;
                          ref
                              .read(attendanceProvider)
                              .createStatusInfo(
                                AttendanceModel(
                                  workDate: AppDateTime.todayDate(
                                    withoutWeek: true,
                                  ),
                                ),
                              )
                              .then((_) {
                                if (mounted) {
                                  setState(() => _isCreatingRecord = false);
                                }
                              })
                              .catchError((_) {
                                if (mounted) {
                                  setState(() => _isCreatingRecord = false);
                                }
                              });
                        }
                        return appLoading(text: 'Setting up your day...');
                      }

                      final data = list.first;
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            20.verticalSpace,
                            GreetingHeader(),
                            20.verticalSpace,
                            StatusBox(data: data),
                            20.verticalSpace,
                            TodayOverview(data: data),
                            10.verticalSpace,
                            BreaksBox(data: data),
                            20.verticalSpace,
                          ],
                        ),
                      );
                    },
                    error: (e, _) => Center(child: Text(e.toString())),
                    loading: () => appLoading(),
                  );
            },
          ),
    );
  }
}
