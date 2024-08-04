import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:opalia_client/screens/client/pages/auth/signin.dart';
import 'package:opalia_client/screens/client/widgets/Allappwidgets/AppbarWidegts.dart';
import 'package:opalia_client/screens/pro/pages/auth/signinpro.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<void> _setUserProfile(String profile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userProfile', profile);
    print('User profile set to: $profile');
    if (profile == 'patient') {
      Get.offAll(() => SigninScreen());
    } else if (profile == 'doctor') {
      Get.offAll(() => SigninproScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              stops: [1, 0.1],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.red.shade50, Colors.white],
            ),
          ),
        ),
        centerTitle: true,
        title: const Text(
          'OPALIA RECORDATI',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Bienvenue',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.black,
                fontSize: 30,
              ),
            ),
            SizedBox(height: 30),
            Text(
              'Choisissez votre Profil',
              style: TextStyle(
                  fontWeight: FontWeight.w400, color: Colors.red, fontSize: 35),
            ),
            SizedBox(height: 50),
            Container(
              height: 300,
              width: 380,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  stops: [
                    0.1,
                    0.4,
                    0.6,
                    0.9,
                  ],
                  colors: [
                    Color.fromARGB(255, 251, 202, 202),
                    Color.fromARGB(255, 255, 229, 229),
                    Color.fromARGB(255, 249, 234, 234),
                    const Color.fromARGB(255, 255, 255, 255),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(width: 2, color: Colors.red),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () => _setUserProfile('patient'),
                      child: Container(
                        width: 330,
                        height: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(width: 2, color: Colors.red),
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.person_2_sharp,
                                color: Colors.red,
                                size: 50,
                              ),
                              SizedBox(height: 20),
                              Text(
                                "Patient",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () => _setUserProfile('doctor'),
                      child: Container(
                        width: 330,
                        height: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(width: 2, color: Colors.red),
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.health_and_safety_rounded,
                                color: Colors.red,
                                size: 50,
                              ),
                              SizedBox(height: 20),
                              Text(
                                "Docteur",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
