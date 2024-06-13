import 'package:flutter/material.dart';
import 'package:opalia_client/services/local/sharedprefutils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../services/remote/apiService.dart';
import '../../widgets/Allappwidgets/constant.dart';

class UpdateUser extends StatefulWidget {
  const UpdateUser({super.key});

  @override
  State<UpdateUser> createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  final _formKey = GlobalKey<FormState>();
  late FocusNode nameFocus;
  late FocusNode familynameFocus;
  late FocusNode searchBtnFocus;
  late FocusNode emailFocus;
  late FocusNode passwordFocus;

  late TextEditingController familynameController;
  late TextEditingController nameController;
  late TextEditingController emailController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameFocus = FocusNode();
    familynameFocus = FocusNode();
    searchBtnFocus = FocusNode();
    passwordFocus = FocusNode();
    emailFocus = FocusNode();
    familynameController =
        TextEditingController(text: PreferenceUtils.getuserFamilyname());
    nameController = TextEditingController(text: PreferenceUtils.getuserName());
    emailController =
        TextEditingController(text: PreferenceUtils.getuserEmail());
  }

  @override
  void dispose() {
    nameFocus.dispose();
    familynameFocus.dispose();
    passwordFocus.dispose();
    emailFocus.dispose();
    nameController.dispose();
    familynameController.dispose();
    emailController.dispose();
    super.dispose();
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
        title: Text('Modifier profil utilisateur'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Text(
                  "Prénom :",
                  style: TextStyle(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "veullez saisire votre prénom";
                    } else {
                      return null;
                    }
                  },
                  focusNode: nameFocus,
                  controller: nameController,
                  autofocus: false,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.red,
                        ),
                        borderRadius: kBorderRadius),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.red,
                      ),
                      borderRadius: kBorderRadius,
                    ),
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                    ),
                    filled: true,
                    hintText: "ecrire votre prénom",
                    fillColor: Colors.transparent,
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Text(
                  "Nom :",
                  style: TextStyle(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "veullez saisire votre Nom";
                    } else {
                      return null;
                    }
                  },
                  focusNode: familynameFocus,
                  controller: familynameController,
                  autofocus: false,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.red,
                        ),
                        borderRadius: kBorderRadius),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.red,
                      ),
                      borderRadius: kBorderRadius,
                    ),
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                    ),
                    filled: true,
                    hintText: "ecrire votre nom",
                    fillColor: Colors.transparent,
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Text(
                  "Email:",
                  style: TextStyle(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "veullez saisire votre Nom";
                    } else {
                      return null;
                    }
                  },
                  focusNode: emailFocus,
                  controller: emailController,
                  autofocus: false,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.red,
                        ),
                        borderRadius: kBorderRadius),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.red,
                      ),
                      borderRadius: kBorderRadius,
                    ),
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                    ),
                    filled: true,
                    hintText: "ecrire votre email",
                    fillColor: Colors.transparent,
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    onPrimary: Colors.red,
                    primary: Colors.red,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: kBorderRadius,
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      print(PreferenceUtils.getuserid());

                      /// PreferenceUtils.setString('passowrd', value)
                      await ApiService.updateUser(
                        PreferenceUtils.getuserid(),
                        nameController.text,
                        familynameController.text,
                        emailController.text,
                      );
                    }
                  },
                  child: Text(
                    "Modifier Profil",
                    style: TextStyle(color: Colors.white, fontSize: kfontSize),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
