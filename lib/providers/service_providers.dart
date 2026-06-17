import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:user_tracker/core/utils/check_in_validation.dart';
import 'package:user_tracker/data/models/attendance_model.dart';
import 'package:user_tracker/data/models/profile_model.dart';
import 'package:user_tracker/data/services/attendance_services.dart';
import 'package:user_tracker/data/services/profile_service.dart';

// Profile
final profileProvider = Provider<ProfileService>((_) => ProfileService());

final getProfileProvider = StreamProvider(
  (ref) => ref.read(profileProvider).getProfile(),
);

final setProfileProvider = FutureProvider.family(
  (ref, ProfileModel data) => ref.read(profileProvider).setProfile(data),
);

final uploadProfilePicProvider = FutureProvider.family(
  (ref, File file) => ref.read(profileProvider).uploadProfileImage(file),
);

// Attendance
final attendanceProvider = Provider((_) => AttendanceServices());

final dayStatusProvider = StreamProvider.autoDispose
    .family<List<AttendanceModel>, String>((ref, String day) {
      return ref.read(attendanceProvider).getDayStatusInfo(day: day);
    });

final monthlyStatusProvider = StreamProvider.autoDispose
    .family<List<AttendanceModel>, String>(
      (ref, String month) =>
          ref.read(attendanceProvider).getMonthlyStatusInfo(month),
    );

final officeAccessProvider = FutureProvider(
  (ref) async => await checkInValidation(),
);
