import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_tracker/core/consts/app_colors.dart';
import 'package:user_tracker/core/widgets/app_button.dart';
import 'package:user_tracker/core/widgets/input_field.dart';
import 'package:user_tracker/core/widgets/link_text.dart';
import 'package:user_tracker/data/services/auth_service.dart';
import 'package:user_tracker/providers/ui_provider.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  bool isChecked = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 20.sp),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Create Account',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  6.verticalSpace,
                  Text(
                    'Join us by creating your account',
                    style: Theme.of(
                      context,
                    ).textTheme.titleSmall?.copyWith(color: AppColors.grey),
                  ),
                  30.verticalSpace,
                  InputField(
                    controller: nameController,
                    hint: 'Full Name',
                    icon: Icons.email_outlined,
                  ),
                  10.verticalSpace,
                  InputField(
                    controller: emailController,
                    hint: 'Email',
                    icon: Icons.lock_outline,
                  ),
                  10.verticalSpace,
                  InputField(
                    controller: phoneController,
                    hint: 'Phone Number',
                    icon: Icons.call_outlined,
                  ),
                  10.verticalSpace,
                  InputField(
                    controller: passwordController,
                    hint: 'Password',
                    icon: Icons.lock_outline,
                    eyeIcon: true,
                  ),
                  10.verticalSpace,
                  Row(
                    spacing: 6.sp,
                    children: [
                      Checkbox(
                        value: isChecked,
                        activeColor: AppColors.primaryColor,
                        onChanged: (value) =>
                            setState(() => isChecked = !isChecked),
                      ),
                      linkText(
                        context,
                        title: 'I agree to the',
                        link: 'Terms & Conditions',
                        onTap: () {},
                      ),
                    ],
                  ),
                  10.verticalSpace,
                  AppButton(
                    clickable: isChecked,
                    title: 'SIGN UP',
                    formKey: formKey,
                    onTap: () async => AuthService.signupWithEmailPassword(
                      context,
                      name: nameController.text,
                      phone: phoneController.text,
                      email: emailController.text,
                      password: passwordController.text,
                    ),
                    textOnLoading: 'Creating account..',
                  ),
                  20.verticalSpace,
                  linkText(
                    context,
                    title: 'Already have an account? ',
                    link: 'Login',
                    onTap: () =>
                        ref.read(authPageProvider.notifier).state = true,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
