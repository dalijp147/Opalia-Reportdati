import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opalia_client/screens/client/pages/menu/LanguageScreen.dart';
import 'package:opalia_client/services/local/sharedprefutils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../pro/pages/Aprops.dart';
import '../../../pro/pages/ConcatScrenn.dart';
import '../auth/signin.dart';
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
              Image.network(
                PreferenceUtils.getUserImage() == null ||
                        PreferenceUtils.getUserImage().isEmpty
                    ? "https://static.vecteezy.com/system/resources/previews/005/337/799/non_2x/icon-image-not-found-free-vector.jpg"
                    : PreferenceUtils.getUserImage(),
                width: 70,
                height: 70,
                fit: BoxFit.scaleDown,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 100,
                    width: double.infinity,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
                errorBuilder: (BuildContext context, Object error,
                    StackTrace? stackTrace) {
                  print('Error loading image: $error');
                  return Image.network(
                    "https://static.vecteezy.com/system/resources/previews/005/337/799/non_2x/icon-image-not-found-free-vector.jpg",
                    width: 70,
                    height: 70,
                  );
                },
              ),
              // Image.asset(
              //   "assets/images/daly.png",
              //   width: 70,
              //   height: 70,
              // ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        PreferenceUtils.getuserName(),
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        PreferenceUtils.getuserFamilyname(),
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ],
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
          SizedBox(
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
                    Icons.arrow_drop_down_circle_sharp,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                const Text(
                  "Évalué l'application",
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
            height: 10,
          ),
          const Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Autre",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(
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
                    Icons.description_sharp,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                const Text(
                  "À Propos de nous",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Get.to(ApropsScreen());
                  },
                  child: Container(
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
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15,
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
                    Icons.phone,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                const Text(
                  "Contacter Nous",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Get.to(ContactUsScreen());
                  },
                  child: Container(
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
