import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:user_tracker/core/consts/app_colors.dart';
import 'package:user_tracker/providers/ui_provider.dart';

class ThemeModeTile extends ConsumerWidget {
  const ThemeModeTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeModeProvider).value ?? false;
    return Material(
      color: Colors.transparent,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(
          isDark ? CupertinoIcons.moon_fill : CupertinoIcons.sun_max_fill,
          color: isDark ? Colors.amber : Colors.orange,
        ),
        title: Text(
          isDark ? 'Dark Mode' : 'Light Mode',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: CupertinoSwitch(
          value: isDark,
          activeTrackColor: AppColors.primaryColor,
          onChanged: (val) => ref.read(themeModeProvider.notifier).set(val),
        ),
      ),
    );
  }
}
