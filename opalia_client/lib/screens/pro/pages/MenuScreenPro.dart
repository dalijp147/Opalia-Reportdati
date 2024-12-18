import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opalia_client/screens/client/pages/menu/LanguageScreen.dart';
import 'package:opalia_client/services/local/sharedprefutils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../client/pages/user/updateScreenUser.dart';
import 'Aprops.dart';
import 'ConcatScrenn.dart';
import 'medecin/UpdateMedecin.dart';

class MenuScreenPro extends StatefulWidget {
  const MenuScreenPro({super.key});

  @override
  State<MenuScreenPro> createState() => _MenuScreenProState();
}

class _MenuScreenProState extends State<MenuScreenPro> {
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
              "Mon Profil",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
          ),
          Column(
            children: [
              ClipOval(
                child: Image.network(
                  PreferenceUtils.getUserImage() == null ||
                          PreferenceUtils.getUserImage().isEmpty
                      ? "https://static.vecteezy.com/system/resources/previews/005/337/799/non_2x/icon-image-not-found-free-vector.jpg"
                      : PreferenceUtils.getUserImage(),
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 70,
                      width: 70,
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
                    return ClipOval(
                      child: Image.network(
                        "https://static.vecteezy.com/system/resources/previews/005/337/799/non_2x/icon-image-not-found-free-vector.jpg",
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Docteur ${PreferenceUtils.getuserName()}',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
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
                  Text(
                    '${PreferenceUtils.getSpecialite()}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: 15,
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
                    Get.to(UpdateMedecin());
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
