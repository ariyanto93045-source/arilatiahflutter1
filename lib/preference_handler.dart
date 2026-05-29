import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHandler {
  static late SharedPreferences _prefs;

  // INIT
  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // SIMPAN LOGIN
  static Future setLogin(bool value) async {
    await _prefs.setBool("login", value);
  }

  // AMBIL STATUS LOGIN
  static bool get isLogin {
    return _prefs.getBool("login") ?? false;
  }
}
