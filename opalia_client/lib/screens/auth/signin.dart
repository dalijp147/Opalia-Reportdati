import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';
import 'package:opalia_client/screens/auth/signup.dart';
import 'package:opalia_client/widegts/BottomNav.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/config.dart';
import '../../widegts/TextForm.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late SharedPreferences prefs;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    initSharedPref();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  void loginUser() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      var rgBody = {
        "email": emailController.text,
        "password": passwordController.text
      };
      var url = Uri.http(Config.apiUrl, Config.userApi + "/login");
      var response = await http.post(url, body: rgBody);
      var jsonResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        var mytoken = jsonResponse['token'];
        print(jsonResponse['token']);
        prefs.setString('token', mytoken);
        Get.to(BottomNav(
          token: mytoken,
        ));
      } else {
        print('something went wrong in login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                stops: const [
                  0.3,
                  0.5,
                ],
                begin: Alignment.topCenter,
                end: Alignment.center,
                colors: [Colors.red.shade50, Colors.white])),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Form(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/opalia-preview.png',
                height: 200,
                width: 200,
              ),
              Lottie.asset('assets/animation/opa.json',
                  height: 210, width: 210),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Email',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextForm(labelText: 'Email', textcontroller: emailController),
              SizedBox(
                height: 20,
              ),
              Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Password',
                    style: TextStyle(color: Colors.red),
                  )),
              TextForm(
                labelText: 'password',
                textcontroller: passwordController,
              ),
              SizedBox(
                height: 50,
              ),
              ElevatedButton(
                onPressed: () {
                  loginUser();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: Text(
                  'suivant',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'mot de passe oublier ? ',
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Get.to(SignupScreen());
                },
                child: Text(
                  'Créer un nouveau compte ',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          )),
        ),
      )),
    );
  }
}
