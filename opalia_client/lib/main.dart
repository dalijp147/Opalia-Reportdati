import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:get/get.dart';
import 'package:opalia_client/Widget/profileScreen.dart';
import 'package:opalia_client/screens/client/pages/auth/signin.dart';
import 'package:opalia_client/screens/client/widgets/Allappwidgets/BottomNav.dart';
import 'package:opalia_client/screens/pro/widgets/Reusiblewidgets/BottomNavPro.dart';
import 'package:opalia_client/services/local/notif_service.dart';
import 'package:opalia_client/services/local/sharedprefutils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await NotifiactionService.initializeNotification();
  await PreferenceUtils.init();

  await Hive.openBox('favoriteBox');
  String? token = PreferenceUtils.getString('token');

  // Debugging token retrieval
  if (token == null) {
    print('No token found!');
  } else {
    print('Retrieved token: $token');
  }
  runApp(
    MyApp(
        //  token: token,
        ),
  );
}

class MyApp extends StatelessWidget {
  final token;

  const MyApp({super.key, this.token});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    bool isTokenValid = token != null && !JwtDecoder.isExpired(token!);
    if (token != null) {
      print('Token is expired: ${JwtDecoder.isExpired(token!)}');
    }

    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 255, 1, 1)),
        useMaterial3: true,
      ),
      home:
          // isTokenValid ? BottomNav(token: token!) : SigninScreen(),
          BottomNavPRo(),
    );
  }
}
