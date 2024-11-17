import 'dart:convert';
import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';
import 'package:opalia_client/screens/client/pages/auth/signup.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../config/config.dart';
import '../../widgets/Allappwidgets/BottomNav.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  io.File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = io.File(pickedFile.path);
      });
    } else {
      print('No image selected.');
    }
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController ForgotemailController = TextEditingController();

  late SharedPreferences prefs;
  late FocusNode passwordFocus;
  bool _obscured = true;
  late FocusNode emailFocus;
  String errorMessage = '';
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
        setState(() {
          errorMessage =
              jsonResponse['message'] ?? 'Something went wrong in login';
        });
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Erreur'),
              content: Text(errorMessage),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } else {
      setState(() {
        errorMessage = 'Please fill in all fields';
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erreur'),
            content: Text(errorMessage),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void forgotPassword() async {
    if (ForgotemailController.text.isNotEmpty) {
      var rgBody = {
        "email": ForgotemailController.text,
      };
      var url = Uri.http(Config.apiUrl, Config.userApi + "/forgot-password");
      var response = await http.post(url, body: rgBody);
      var jsonResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        setState(() {
          errorMessage = 'Password reset link sent to your email';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        setState(() {
          errorMessage = jsonResponse['message'] ?? 'Something went wrong';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      setState(() {
        errorMessage = 'Please enter your email';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
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
            stops: const [0.3, 0.5],
            begin: Alignment.topCenter,
            end: Alignment.center,
            colors: [Colors.red.shade50, Colors.white],
          ),
        ),
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
                      return "veuillez saisir l'email ";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
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
                SizedBox(height: 20),
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
                      return "veuillez saisir le mot de passe ";
                    } else {
                      return null;
                    }
                  },
                  autofocus: false,
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
                SizedBox(height: 15),
                SizedBox(
                  width: 370,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        loginUser();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.red,
                    ),
                    child: Text(
                      'Se connecter',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                SizedBox(
                  width: 370,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.to(SignupScreen());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: Colors.red,
                        ),
                      ),
                    ),
                    child: Text(
                      'Créer un compte',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: 370,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Mot de passe oublier'),
                            content: TextField(
                              //  controller: ForgotemailController,
                              decoration: InputDecoration(hintText: "Email"),
                            ),
                            actions: [
                              TextButton(
                                child: Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text('Send'),
                                onPressed: () {
                                  forgotPassword();
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: Colors.red,
                        ),
                      ),
                    ),
                    child: Text(
                      'Mot de passe oublier ?',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
