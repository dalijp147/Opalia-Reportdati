import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';
import 'package:opalia_client/screens/pages/auth/signup.dart';
import 'package:opalia_client/screens/widegts/Allappwidgets/BottomNav.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../config/config.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late SharedPreferences prefs;
  late FocusNode passwordFocus;
  bool _obscured = true;
  late FocusNode emailFocus;
  @override
  void initState() {
    passwordFocus = FocusNode();
    emailFocus = FocusNode();

    super.initState();
    initSharedPref();
  }

  @override
  void dispose() {
    emailFocus.dispose();
    passwordFocus.dispose();
    super.dispose();
  }

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
      if (passwordFocus.hasPrimaryFocus)
        return; // If focus is on text field, dont unfocus
      passwordFocus.canRequestFocus = false; // Prevents focus if tap on eye
    });
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  bool isNotValide = false;
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

  final _formKey = GlobalKey<FormState>();
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
            key: _formKey,
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
                TextFormField(
                  focusNode: emailFocus,
                  controller: emailController,
                  keyboardType: TextInputType.text,
                  autofocus: false,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "veullez saisire email ";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    // ignore: dead_code

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
                SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Password',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                TextFormField(
                  focusNode: passwordFocus,
                  obscureText: _obscured,
                  controller: passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "veullez saisire password ";
                    } else {
                      return null;
                    }
                  },
                  autofocus: true,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "password",
                    suffixIcon: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                      child: GestureDetector(
                        onTap: _toggleObscured,
                        child: Icon(
                          _obscured
                              ? Icons.visibility_off_rounded
                              : Icons.visibility_rounded,
                          size: 24,
                        ),
                      ),
                    ),
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
                  height: 15,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      loginUser();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: Text(
                    'login',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'mot de passe oublier ? ',
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(
                  height: 10,
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
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(width: 3, color: Colors.grey),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: AssetImage(
                              'assets/images/icongoogle.png',
                            ), //NetworkImage
                            radius: 20,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Se connecter avec votre compte Google',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      )),
    );
  }
}
