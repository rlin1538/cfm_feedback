import 'package:shared_preferences/shared_preferences.dart';

class SPUtils {
  static saveStringToSP(String key, String value) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }
  static saveStringListToSP(String key, List<String> value) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setStringList(key, value);
  }
}
