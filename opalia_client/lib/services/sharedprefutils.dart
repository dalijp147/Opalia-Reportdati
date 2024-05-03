import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceUtils {
  static Future<SharedPreferences> get _instance async =>
      _prefsInstance ??= await SharedPreferences.getInstance();

  static SharedPreferences? _prefsInstance;

  // call this method from iniState() function of mainApp().
  static Future<SharedPreferences> init() async {
    _prefsInstance = await _instance;
    return _prefsInstance!;
  }

  static String getString(String key) {
    return _prefsInstance!.getString(key) ?? "";
  }

  static String getuserid() {
    String? token = _prefsInstance!.getString('token');
    Map<String, dynamic> jsonDecoddd = JwtDecoder.decode(token!);
    print(jsonDecoddd);
    var userId = jsonDecoddd['_id'];
    return userId;
  }

  static String getuserName() {
    String? token = _prefsInstance!.getString('token');
    Map<String, dynamic> jsonDecoddd = JwtDecoder.decode(token!);
    var userId = jsonDecoddd['username'];
    print(userId);
    return userId;
  }

  static String getuserFamilyname() {
    String? token = _prefsInstance!.getString('token');
    Map<String, dynamic> jsonDecoddd = JwtDecoder.decode(token!);
    var userId = jsonDecoddd['familyname'];
    print(userId);
    return userId;
  }

  static Future<bool> setString(String key, String value) async {
    var prefs = await _instance;
    return prefs?.setString(key, value) ?? Future.value(false);
  }
}
