import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';
import 'package:opalia_client/screens/auth/signup.dart';

import '../../widegts/TextForm.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Container(
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
              TextForm(
                labelText: 'Email',
              ),
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
              ),
              SizedBox(
                height: 50,
              ),
              ElevatedButton(
                onPressed: () {
                  Get.to(SignupScreen());
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
              Text(
                'Créer  un nouveau compte ',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ],
          )),
        ),
      )),
    );
  }
}
