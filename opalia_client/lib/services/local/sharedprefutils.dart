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

    return userId;
  }

  // static String getuserImage() {
  //   String? token = _prefsInstance!.getString('token');
  //   Map<String, dynamic> jsonDecoddd = JwtDecoder.decode(token!);
  //   var userId = jsonDecoddd['image'];

  //   return userId;
  // }

  static Future<String> getUserImage() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null && token.isNotEmpty) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      var userImage = decodedToken[
          'image']; // Adjust the key based on your token's structure

      return userImage;
    }

    return '';
  }

  static String getuserFamilyname() {
    String? token = _prefsInstance!.getString('token');
    Map<String, dynamic> jsonDecoddd = JwtDecoder.decode(token!);
    var userId = jsonDecoddd['familyname'];

    return userId;
  }

  static String getuserEmail() {
    String? token = _prefsInstance!.getString('token');
    Map<String, dynamic> jsonDecoddd = JwtDecoder.decode(token!);
    var userId = jsonDecoddd['email'];

    return userId;
  }

  static Future<bool> setString(String key, String value) async {
    var prefs = await _instance;
    return prefs?.setString(key, value) ?? Future.value(false);
  }
}
