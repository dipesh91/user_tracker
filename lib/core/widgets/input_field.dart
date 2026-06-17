// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:user_tracker/core/consts/app_colors.dart';
import 'package:user_tracker/core/consts/app_string.dart';
import 'package:user_tracker/core/utils/input_validations.dart';
import 'package:user_tracker/providers/ui_provider.dart';

class InputField extends ConsumerWidget {
  TextEditingController controller;
  String hint;
  IconData? icon;
  bool eyeIcon, readOnly, needCalender;
  TextInputType? keyboardInputType;

  InputField({
    super.key,
    required this.controller,
    required this.hint,
    this.icon,
    this.eyeIcon = false,
    this.readOnly = false,
    this.needCalender = false,
    this.keyboardInputType,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isObscure = ref.watch(isObscureProvider);
    return TextFormField(
      onTap: needCalender
          ? () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1999),
                lastDate: DateTime.now(),
              );
              controller.text =
                  '${date!.day} ${AppString.monthsList[date.month - 1]} ${date.year}';
            }
          : null,
      readOnly: readOnly,
      controller: controller,
      obscureText: eyeIcon ? isObscure : false,
      cursorColor: AppColors.black,
      keyboardType: keyboardInputType,
      style: TextStyle(fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        visualDensity: icon == null ? VisualDensity.compact : null,
        enabledBorder: _buildOutlineInputBorder(
          readOnly ? AppColors.primaryColor : AppColors.grey,
        ),
        errorBorder: _buildOutlineInputBorder(Colors.red.shade400),
        focusedBorder: _buildOutlineInputBorder(
          readOnly ? AppColors.primaryColor : AppColors.black,
        ),
        focusedErrorBorder: _buildOutlineInputBorder(Colors.red.shade900),
        prefixIcon: icon != null ? Icon(icon) : null,
        hintText: hint,
        hintStyle: TextStyle(color: AppColors.grey),
        suffixIcon: eyeIcon
            ? IconButton(
                onPressed: () =>
                    ref.read(isObscureProvider.notifier).state = !isObscure,
                icon: Icon(
                  isObscure
                      ? CupertinoIcons.eye_slash_fill
                      : CupertinoIcons.eye_fill,
                ),
              )
            : null,
      ),
      validator: (value) => validator(label: hint, value: value),
    );
  }

  OutlineInputBorder _buildOutlineInputBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: color, width: 2),
    );
  }
}
