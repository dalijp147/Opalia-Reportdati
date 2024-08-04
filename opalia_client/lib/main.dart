import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:get/get.dart';
import 'package:opalia_client/Widget/profileScreen.dart';
import 'package:opalia_client/screens/client/pages/auth/signin.dart';
import 'package:opalia_client/screens/client/widgets/Allappwidgets/BottomNav.dart';
import 'package:opalia_client/screens/pro/pages/auth/signinpro.dart';
import 'package:opalia_client/screens/pro/widgets/Reusiblewidgets/BottomNavPro.dart';
import 'package:opalia_client/services/local/notif_service.dart';
import 'package:opalia_client/services/local/sharedprefutils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await NotifiactionService.initializeNotification();
  await PreferenceUtils.init();
  await Hive.openBox('favoriteBox');
  await initializeDateFormatting('fr_FR', null);
  String? token = PreferenceUtils.getString('token');
  if (token == null) {
    print('No token found!');
  } else {
    print('Retrieved token: $token');
  }

  runApp(MyApp(token: token));
}

class MyApp extends StatelessWidget {
  final String? token;

  const MyApp({super.key, this.token});

  @override
  Widget build(BuildContext context) {
    bool isTokenValid = false;
    if (token != null) {
      try {
        isTokenValid = !JwtDecoder.isExpired(token!);
        print('Token is expired: ${JwtDecoder.isExpired(token!)}');
      } catch (e) {
        print('Error decoding token: $e');
      }
    }

    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 255, 1, 1)),
        useMaterial3: true,
      ),
      home: FutureBuilder<bool>(
        future: _isFirstTimeUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.data ?? true) {
              print('First time user: showing ProfileScreen');
              return ProfileScreen();
            } else {
              return FutureBuilder<String?>(
                future: _getUserProfile(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    print('User profile: ${snapshot.data}');
                    if (snapshot.data == 'patient') {
                      return isTokenValid
                          ? BottomNav(token: token!)
                          : SigninScreen();
                    } else if (snapshot.data == 'doctor') {
                      return isTokenValid
                          ? BottomNavPRo(token: token!)
                          : SigninproScreen();
                    } else {
                      return ProfileScreen(); // Default case if no profile found
                    }
                  }
                },
              );
            }
          }
        },
      ),
    );
  }

  Future<bool> _isFirstTimeUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTime') ?? true;
    if (isFirstTime) {
      await prefs.setBool('isFirstTime', false);
    }
    return isFirstTime;
  }

  Future<String?> _getUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userProfile = prefs.getString('userProfile');
    print('Retrieved user profile: $userProfile');
    return userProfile;
  }
}
