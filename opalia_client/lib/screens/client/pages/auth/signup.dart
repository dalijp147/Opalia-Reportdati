import 'dart:convert';
import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:opalia_client/config/config.dart';
import 'package:opalia_client/screens/client/pages/auth/signin.dart';
import 'package:opalia_client/screens/client/pages/categorie/CategorieScreen.dart';
import 'package:http/http.dart' as http;

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
  late FocusNode emailFocus;
  late FocusNode passwordFocus;
  late FocusNode nomFocus;
  late FocusNode prenomFocus;
  bool _obscured = false;

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
      if (passwordFocus.hasPrimaryFocus)
        return; // If focus is on text field, dont unfocus
      passwordFocus.canRequestFocus = false; // Prevents focus if tap on eye
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailFocus = FocusNode();
    nomFocus = FocusNode();
    passwordFocus = FocusNode();
    prenomFocus = FocusNode();
  }

  @override
  void dispose() {
    passwordFocus.dispose();
    emailFocus.dispose();

    prenomFocus.dispose();
    nomFocus.dispose();
    super.dispose();
  }

  bool isNotValide = false;

  void registerUSer() async {
    if (emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        nomController.text.isNotEmpty &&
        prenomController.text.isNotEmpty &&
        _image != null) {
      var rgBody = {
        "email": emailController.text,
        "password": passwordController.text,
        "username": nomController.text,
        "familyname": prenomController.text,
        "image": _image,
      };
      var url = Uri.http(Config.apiUrl, Config.userApi + "/registration");
      var request = http.MultipartRequest('POST', url);

      request.fields
          .addAll(rgBody.map((key, value) => MapEntry(key, value.toString())));
      request.files
          .add(await http.MultipartFile.fromPath('image', _image!.path));
      // var response = await http.post(url, body: rgBody);
      // print(response.body);
      // var jsonResponse = jsonDecode(response.body);
      // print(url);
      // if (response.statusCode == 200) {
      //   Get.to(SigninScreen());
      // } else {
      //   print('something went wrong in signup');
      // }
      try {
        var response = await request.send();
        var responseBody = await http.Response.fromStream(response);

        if (response.statusCode == 200) {
          Get.to(SigninScreen());
        } else {
          print('Something went wrong in signup: ${responseBody.body}');
        }
      } catch (e) {
        print('Error during registration: $e');
      } finally {
        setState(() {
          //isLoading = false;
        });
      }
    } else {
      setState(() {
        isNotValide = true;
      });
    }
  }

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

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          alignment: Alignment.center,
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
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/opalia-preview.png',
                    height: 200,
                    width: 200,
                  ),
                  Text(
                    'Créer un nouveau compte',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  _image == null
                      ? Text('No image selected.')
                      : Image.file(_image!, height: 100),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    child: Text('Pick Image from Gallery'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Nom :',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                  TextFormField(
                    focusNode: nomFocus,
                    controller: nomController,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "veullez saisire nom ";
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
                  const SizedBox(
                    height: 10,
                  ),
                  const Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Prenom :',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                  TextFormField(
                    focusNode: prenomFocus,
                    controller: prenomController,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "veullez saisire Prenom ";
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
                  const SizedBox(
                    height: 10,
                  ),
                  const Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Email :',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                  TextFormField(
                    focusNode: emailFocus,
                    controller: emailController,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value!.isEmpty ||
                          !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}')
                              .hasMatch(value!)) {
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
                  const Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Mot de passe :',
                        style: TextStyle(color: Colors.red),
                      ),
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
                      } else if (!RegExp(
                              r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$')
                          .hasMatch(value)) {
                        return "Le mot de passe doit contenir au moins 8 caractères, une majuscule, une minuscule, un chiffre et un caractère spécial";
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      filled: true,
                      fillColor: Colors.white,
                      // ignore: dead_code
                      hintText: "Mot de passe",
                      suffixIcon: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                          child: GestureDetector(
                            onTap: _toggleObscured,
                            child: Icon(
                              _obscured
                                  ? Icons.visibility_rounded
                                  : Icons.visibility_off_rounded,
                              size: 24,
                            ),
                          )),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 3,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                            value: false,
                            onChanged: (value) {
                              value = true;
                            }),
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "je suis d'accord avec ",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 10),
                            ),
                            TextSpan(
                              text: "politique de confidentialité",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 11),
                            ),
                            TextSpan(
                              text: "et",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 10),
                            ),
                            TextSpan(
                              text: "termes et conditions",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 11),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 370,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          registerUSer();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.red,
                      ),
                      child: Text(
                        'Créez votre compte',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
