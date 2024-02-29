import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opalia_client/screens/page/HomeScreen.dart';
import 'package:opalia_client/widegts/TextForm.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  stops: [
                    0.3,
                    0.5,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.center,
                  colors: [Colors.red.shade50, Colors.white])),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/opalia-preview.png',
                  height: 200,
                  width: 200,
                ),
                Text('Créer un nouveau compte'),
                SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Nom',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
                TextForm(
                  labelText: "nom",
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Prenom',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
                TextForm(
                  labelText: "prenom",
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Email',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
                TextForm(
                  labelText: "Email",
                ),
                SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                  onPressed: () {
                    Get.to(HomeScreen());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: Text(
                    'suivant',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
