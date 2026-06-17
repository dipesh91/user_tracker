import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:user_tracker/data/models/profile_model.dart';

class ProfileService {
  static final supabase = Supabase.instance.client;
  static final database = supabase.from('profiles');

  Stream<ProfileModel> getProfile() {
    return database
        .stream(primaryKey: ['id'])
        .map((profiles) => ProfileModel.fromJson(json: profiles.first));
  }

  Future<void> setProfile(ProfileModel profileData) async {
    await database.insert(profileData.toMap());
  }

  static Future<void> updateToken(String token) async {
    try {
      final email = supabase.auth.currentUser?.email;
      await database.update({'token': token}).eq('email', email!).select();
    } on Exception catch (e) {
      print('------------------------>>> $e');
    }
  }

  Future<String> uploadProfileImage(File imageFile) async {
    final userId = supabase.auth.currentUser!.id;
    final path = '$userId/avatar.jpg';

    await supabase.storage
        .from('avatars')
        .upload(path, imageFile, fileOptions: FileOptions(upsert: true));

    final url = supabase.storage.from('avatars').getPublicUrl(path);

    await database.update({'avatar_url': url}).eq('id', userId);

    return url;
  }
}
