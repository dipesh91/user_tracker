import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_tracker/core/consts/app_colors.dart';
import 'package:user_tracker/core/consts/app_enums.dart';
import 'package:user_tracker/core/utils/app_date_time.dart';
import 'package:user_tracker/core/widgets/app_loading.dart';
import 'package:user_tracker/core/widgets/profile_picture.dart';
import 'package:user_tracker/providers/service_providers.dart';
import 'package:user_tracker/providers/ui_provider.dart';

class GreetingHeader extends ConsumerWidget {
  const GreetingHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => ref.read(currentPageIndexProvider.notifier).state =
          Screens.profileScreen.index,
      child: ref
          .watch(getProfileProvider)
          .when(
            data: (user) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppDateTime.greeting(),
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w400),
                    ),
                    Text(
                      '${user.fullName} 👋',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.w500),
                    ),
                    14.verticalSpace,
                    Text(
                      AppDateTime.todayDate(),
                      style: Theme.of(
                        context,
                      ).textTheme.labelLarge?.copyWith(color: AppColors.grey),
                    ),
                  ],
                ),
                profilePicture(size: 80.sp, imageLink: user.avatarUrl),
              ],
            ),
            error: (_, _) => Text('Create Your Profile'),
            loading: () => appLoading(),
          ),
    );
  }
}
