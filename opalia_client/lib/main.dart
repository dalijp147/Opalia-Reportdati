import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:opalia_client/screens/auth/signin.dart';
import 'package:get/get.dart';
import 'package:opalia_client/services/sharedprefutils.dart';
import 'package:opalia_client/widegts/BottomNav.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferenceUtils.init();

  runApp(MyApp(
    token: PreferenceUtils.getString('token'),
  ));
}

class MyApp extends StatelessWidget {
  final token;

  const MyApp({super.key, this.token});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 255, 1, 1)),
        useMaterial3: true,
      ),
      home: (token != null && JwtDecoder.isExpired(token) == false)
          ? BottomNav(token: token)
          : SigninScreen(),
    );
  }
}
