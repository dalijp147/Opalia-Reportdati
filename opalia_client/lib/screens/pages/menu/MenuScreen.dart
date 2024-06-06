import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opalia_client/services/local/sharedprefutils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/signin.dart';
import '../dossiermedical/DossiermedScreen.dart';
import '../user/updateScreenUser.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
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
        title: Text(
          'Menu',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Compte",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
          ),
          Row(
            children: [
              Image.asset(
                "assets/images/daly.png",
                width: 70,
                height: 70,
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    PreferenceUtils.getuserName(),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    PreferenceUtils.getuserFamilyname(),
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          const Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Modifier profil",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            width: double.infinity,
            child: Row(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  margin: EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red.shade100,
                  ),
                  child: Icon(
                    Icons.person,
                    color: Colors.red,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  'Modifier',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Get.to(UpdateUser());
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    margin: EdgeInsets.only(right: 5),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.navigate_next_rounded,
                      color: Colors.black,
                      size: 50,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          const Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Paramétre",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(
            height: 9,
          ),
          Container(
            width: double.infinity,
            child: Row(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  margin: EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red.shade100,
                  ),
                  child: const Icon(
                    Icons.speaker_notes,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                const Text(
                  'Langue',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                Container(
                  height: 50,
                  width: 50,
                  margin: EdgeInsets.only(right: 5),
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20)),
                  child: const Icon(
                    Icons.navigate_next_rounded,
                    color: Colors.black,
                    size: 50,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            width: double.infinity,
            child: Row(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  margin: EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red.shade100,
                  ),
                  child: const Icon(
                    Icons.notification_add,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                const Text(
                  'Notification',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                Container(
                  height: 50,
                  width: 50,
                  margin: EdgeInsets.only(right: 5),
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20)),
                  child: const Icon(
                    Icons.navigate_next_rounded,
                    color: Colors.black,
                    size: 50,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: double.infinity,
            child: Row(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  margin: EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red.shade100,
                  ),
                  child: const Icon(
                    Icons.arrow_drop_down_circle_sharp,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                const Text(
                  'Mode sombre',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                Container(
                  height: 50,
                  width: 50,
                  margin: EdgeInsets.only(right: 5),
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20)),
                  child: const Icon(
                    Icons.navigate_next_rounded,
                    color: Colors.black,
                    size: 50,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 35,
          ),
          // Expanded(
          //   child: Align(
          //     alignment: FractionalOffset.bottomCenter,
          //     child: ElevatedButton(
          //       style: ElevatedButton.styleFrom(
          //         minimumSize: Size(100, 50),
          //       ),
          //       onPressed: () async {
          //         SharedPreferences pref =
          //             await SharedPreferences.getInstance();
          //         await pref.clear();
          //         Navigator.pushAndRemoveUntil(
          //           context,
          //           MaterialPageRoute(builder: (context) => SigninScreen()),
          //           (Route<dynamic> route) => false,
          //         );
          //       },
          //       child: Text('déconnecter'),
          //     ),
          //   ),
          // ),
          // SizedBox(
          //   height: 10,
          // )
        ],
      ),
    );
  }
}
