import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opalia_client/config/config.dart';
import 'package:opalia_client/screens/auth/signin.dart';
import 'package:opalia_client/screens/pages/HomeScreen.dart';
import 'package:opalia_client/widegts/TextForm.dart';
import 'package:http/http.dart' as http;
import '../../widegts/BottomNav.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nomController = TextEditingController();
  TextEditingController prenomController = TextEditingController();
  bool isNotValide = false;

  void registerUSer() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      var rgBody = {
        "email": emailController.text,
        "password": passwordController.text
      };
      var url = Uri.http(Config.apiUrl, Config.userApi + "/registration");
      var response = await http.post(url, body: rgBody);
      print(response.body);
      var jsonResponse = jsonDecode(response.body);
      print(url);
      if (response.statusCode == 200) {
        Get.to(SigninScreen());
      } else {
        print('something went wrong in signup');
      }
    } else {
      setState(() {
        isNotValide = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
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
                  textcontroller: nomController,
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
                  textcontroller: prenomController,
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
                // TextForm(labelText: "Email", textcontroller: emailController),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    // ignore: dead_code
                    errorText: isNotValide ? "Enter Proper Info" : null,
                    hintText: "email",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.red,
                        width: 3,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Password',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
                // TextForm(
                //     labelText: "Password", textcontroller: passwordController),
                TextField(
                  controller: passwordController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    // ignore: dead_code
                    errorText: isNotValide ? "Enter Proper Info" : null,
                    hintText: "password",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.red,
                        width: 3,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                  onPressed: () {
                    // Get.to(BottomNav());
                    registerUSer();
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
