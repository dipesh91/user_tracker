import 'package:shared_preferences/shared_preferences.dart';

class SaveInDevice {
  static Future<void> themeMode({required bool themeMode}) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool('theme', themeMode);
  }
}

class GetFromDevice {
  static Future<bool> themeMode() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool('theme') ?? false;
  }
}
