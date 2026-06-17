import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_tracker/core/consts/app_colors.dart';
import 'package:user_tracker/core/widgets/app_button.dart';
import 'package:user_tracker/core/widgets/input_field.dart';
import 'package:user_tracker/core/widgets/link_text.dart';
import 'package:user_tracker/data/services/auth_service.dart';
import 'package:user_tracker/providers/ui_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
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
                  SizedBox(
                    height: 160.h,
                    width: 160.w,
                    child: Image.asset('assets/images/logo.png'),
                  ),
                  10.verticalSpace,
                  Text(
                    'Welcome Back! 👋',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  6.verticalSpace,
                  Text(
                    'Login to continue to your account',
                    style: Theme.of(
                      context,
                    ).textTheme.titleSmall?.copyWith(color: AppColors.grey),
                  ),
                  30.verticalSpace,
                  InputField(
                    controller: emailController,
                    hint: 'Email',
                    icon: Icons.email_outlined,
                  ),
                  10.verticalSpace,
                  InputField(
                    controller: passwordController,
                    hint: 'Password',
                    icon: Icons.lock_outline,
                    eyeIcon: true,
                  ),
                  20.verticalSpace,
                  linkText(
                    context,
                    title: '',
                    link: 'Forgot Password?',
                    alignment: MainAxisAlignment.end,
                    onTap: () {},
                  ),
                  20.verticalSpace,
                  AppButton(
                    title: 'LOGIN',
                    formKey: formKey,
                    onTap: () async => AuthService.loginWithEmailAndPassword(
                      context,
                      email: emailController.text,
                      password: passwordController.text,
                    ),
                    textOnLoading: 'Logging in..',
                  ),
                  30.verticalSpace,
                  linkText(
                    context,
                    title: 'Don\'t have an account? ',
                    link: 'Sign Up',
                    onTap: () =>
                        ref.read(authPageProvider.notifier).state = false,
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
