import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:user_tracker/core/consts/app_colors.dart';
import 'package:user_tracker/core/widgets/app_button.dart';
import 'package:user_tracker/core/widgets/app_loading.dart';
import 'package:user_tracker/core/widgets/input_field.dart';
import 'package:user_tracker/core/widgets/profile_picture.dart';
import 'package:user_tracker/data/models/profile_model.dart';
import 'package:user_tracker/data/services/auth_service.dart';
import 'package:user_tracker/data/services/profile_service.dart';
import 'package:user_tracker/features/profileScreen/theme_mode_tile.dart';
import 'package:user_tracker/providers/service_providers.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentUser = Supabase.instance.client.auth.currentUser!;
  XFile? _pickedAvatar;

  late final _fullNameCtrl = TextEditingController(
    text: _currentUser.userMetadata?['name'],
  );
  late final _emailCtrl = TextEditingController(text: _currentUser.email);
  late final _phoneCtrl = TextEditingController(
    text: _currentUser.userMetadata?['phone'],
  );
  final _empIdCtrl = TextEditingController();
  final _designationCtrl = TextEditingController();
  final _departmentCtrl = TextEditingController();
  final _joiningCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _empIdCtrl.dispose();
    _designationCtrl.dispose();
    _departmentCtrl.dispose();
    _joiningCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    String avatarUrl = '';
    if (_pickedAvatar != null) {
      avatarUrl = await ProfileService().uploadProfileImage(
        File(_pickedAvatar!.path),
      );
    }
    final profile = ProfileModel(
      fullName: _fullNameCtrl.text,
      email: _emailCtrl.text,
      phone: _phoneCtrl.text,
      employeeId: _empIdCtrl.text,
      designation: _designationCtrl.text,
      department: _departmentCtrl.text,
      workLocation: _locationCtrl.text,
      joiningDate: _joiningCtrl.text,
      avatarUrl: avatarUrl,
    );
    await ref.read(profileProvider).setProfile(profile);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.sizeOf(context).height * 0.35.sp,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
        ),
        Center(
          child: ref
              .watch(getProfileProvider)
              .when(
                data: (user) => _buildUserProfile(user),
                error: (_, _) => _buildCreateProfile(),
                loading: () => appLoading(),
              ),
        ),
      ],
    );
  }

  Widget _buildCreateProfile() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 14.sp,
            children: [
              Text(
                'This information cannot be changed once saved',
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(color: AppColors.primaryColor),
              ),
              _avatarPicker(),
              InputField(
                readOnly: true,
                controller: _fullNameCtrl,
                hint: 'Full Name',
              ),
              InputField(readOnly: true, controller: _emailCtrl, hint: 'Email'),
              InputField(
                readOnly: true,
                controller: _phoneCtrl,
                hint: 'Phone No',
              ),
              InputField(controller: _empIdCtrl, hint: 'Employee Id'),
              InputField(
                controller: _designationCtrl,
                hint: 'Designation or Role',
              ),
              InputField(controller: _departmentCtrl, hint: 'Department'),
              InputField(
                controller: _joiningCtrl,
                hint: 'Joining Date',
                readOnly: true,
                needCalender: true,
              ),
              InputField(controller: _locationCtrl, hint: 'Work Location'),
              AppButton(
                formKey: _formKey,
                textOnLoading: 'Saving..',
                title: 'SAVE',
                onTap: _saveProfile,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _avatarPicker() {
    return GestureDetector(
      onTap: () async {
        final picked = await ImagePicker().pickImage(
          source: ImageSource.gallery,
        );
        if (picked != null) setState(() => _pickedAvatar = picked);
      },
      child: CircleAvatar(
        radius: 50,
        backgroundColor: AppColors.profileBackground,
        backgroundImage: _pickedAvatar != null
            ? FileImage(File(_pickedAvatar!.path))
            : null,
        child: _pickedAvatar == null
            ? const Icon(Icons.add_a_photo, size: 30)
            : null,
      ),
    );
  }

  Widget _buildUserProfile(ProfileModel user) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        20.verticalSpace,
        profilePicture(size: 150.sp, imageLink: user.avatarUrl),
        10.verticalSpace,
        Text(
          user.fullName,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          user.designation,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: Colors.white,
            fontSize: 18.sp,
          ),
        ),
        20.verticalSpace,
        Expanded(
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            padding: EdgeInsets.all(16.sp),
            decoration: BoxDecoration(
              color: AppColors.cardColor,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: SingleChildScrollView(
              child: Column(
                spacing: 14.sp,
                children: [
                  _profileRow('Employee Id', user.employeeId),
                  _profileRow('Email', user.email),
                  _profileRow('Phone', user.phone),
                  _profileRow('Department', user.department),
                  _profileRow('Joining Date', user.joiningDate),
                  _profileRow('Work Location', user.workLocation),
                  Divider(),
                  ThemeModeTile(),
                  _actionTile(
                    icon: CupertinoIcons.lock,
                    title: 'Change Password',
                    onTap: () {},
                  ),
                  _actionTile(
                    icon: Icons.logout,
                    title: 'Log Out',
                    color: Colors.red,
                    onTap: () => _logoutDialog(),
                  ),
                ],
              ),
            ),
          ),
        ),
        20.verticalSpace,
      ],
    );
  }

  void _logoutDialog() {
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.8),
      builder: (context) {
        return CupertinoAlertDialog(
          content: Text(
            'Are you sure to log Out ?',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          actions: [
            CupertinoButton.tinted(
              onPressed: () {
                Navigator.pop(context);
              },
              borderRadius: BorderRadius.zero,
              color: Colors.deepOrange,
              child: const Text('cancel'),
            ),
            CupertinoButton.filled(
              onPressed: () async {
                Navigator.pop(context);
                await AuthService.logOut();
              },
              color: Colors.red,
              borderRadius: BorderRadius.zero,
              child: const Text('Log Out'),
            ),
          ],
        );
      },
    );
  }

  Row _profileRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16.sp, color: AppColors.grey),
        ),
        Text(value, style: TextStyle(fontSize: 15.sp)),
      ],
    );
  }

  Material _actionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        tileColor: Colors.transparent,
        leading: Icon(icon, color: color ?? AppColors.black),
        title: Text(
          title,
          style: TextStyle(
            color: color ?? AppColors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Icon(CupertinoIcons.right_chevron, color: AppColors.black),
        onTap: onTap,
      ),
    );
  }
}
