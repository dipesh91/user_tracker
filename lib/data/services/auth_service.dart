// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  static final _auth = Supabase.instance.client.auth;

  static Future<void> signupWithEmailPassword(
    BuildContext context, {
    required String name,
    required String phone,
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signUp(
        email: email,
        password: password,
        data: {'name': name, 'phone': phone},
      );
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  static Future<void> loginWithEmailAndPassword(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithPassword(email: email, password: password);
    } on AuthApiException catch (e) {
      print('---------------->>    $e');
      if (e.code == 'invalid_credentials') {
        message(context, 'Invalid Email or password');
      }
    }
  }

  static void message(BuildContext context, String text) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: Container(
          padding: EdgeInsets.all(4.sp),
          margin: EdgeInsets.all(10.sp).copyWith(bottom: 20.sp),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: Colors.red),
          ),
          child: ListTile(
            title: Text(
              text,
              style: Theme.of(
                context,
              ).textTheme.titleMedium!.copyWith(color: Colors.red.shade900),
            ),
            leading: Icon(Icons.error_outline, size: 30.sp, color: Colors.red),
            subtitle: Text(
              'please try again',
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
        ),
      ),
      snackBarAnimationStyle: AnimationStyle(
        curve: Curves.bounceIn,
        duration: Duration(milliseconds: 500),
      ),
    );
  }

  static Future<void> logOut() => _auth.signOut();

  static Future<void> forgotPassword({required String email}) =>
      _auth.resetPasswordForEmail(email);
}
