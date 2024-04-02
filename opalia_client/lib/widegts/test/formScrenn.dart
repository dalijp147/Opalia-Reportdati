import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:opalia_client/bloc/reminder/reminder_bloc.dart';
import 'package:opalia_client/models/reminder.dart';
import 'package:opalia_client/widegts/test/constant.dart';
import 'package:opalia_client/widegts/test/search_btn.dart';
import 'package:opalia_client/widegts/test/textformfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late FocusNode nameFocus;
  late FocusNode jobFocus;
  late FocusNode searchBtnFocus;
  late TextEditingController nameController;
  late TextEditingController jobController;
  late String userId = "";
  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('token');

    Map<String, dynamic> jsonDecoddd = JwtDecoder.decode(token!);
    userId = jsonDecoddd['_id'];
    print(userId);
    return userId;
  }

  @override
  void initState() {
    super.initState();

    nameFocus = FocusNode();
    jobFocus = FocusNode();
    searchBtnFocus = FocusNode();
    nameController = TextEditingController();
    jobController = TextEditingController();
  }

  @override
  void dispose() {
    nameFocus.dispose();
    jobFocus.dispose();
    searchBtnFocus.dispose();
    nameController.dispose();
    jobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InputField(
            focusNode: nameFocus,
            textController: nameController,
            label: "reminder title",
            icons: const Icon(
              Icons.person,
              color: Colors.red,
            ),
          ),
          InputField(
            focusNode: jobFocus,
            textController: jobController,
            label: "numero de rappel",
            icons: const Icon(Icons.work, color: Colors.red),
          ),
          SearchButtonBuilder(
            focusNode: searchBtnFocus,
            name: nameController,
            job: jobController,
            userID: userId.toString(),
          ),
        ],
      ),
    );
  }
}
