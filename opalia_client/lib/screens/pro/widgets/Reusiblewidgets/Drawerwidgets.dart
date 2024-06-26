import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opalia_client/screens/pro/pages/Events/ListeventScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../services/local/sharedprefutils.dart';
import '../../../client/pages/menu/MenuScreen.dart';
import '../../../client/pages/news/FavoriteScreen.dart';
import '../../pages/PharmaCo/PhamaCoFormScreen.dart';
import '../../pages/auth/signinpro.dart';

class DrawerWidgetPro extends StatelessWidget {
  const DrawerWidgetPro({super.key});
  Future<void> logout(BuildContext context) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.remove('token');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SigninproScreen()),
      );
    } catch (error) {
      print('Error during logout: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 241, 159, 159),
            ), //BoxDecoration
            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 241, 159, 159),
              ),
              accountName: Text(
                PreferenceUtils.getuserName().capitalizeFirst!,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: Text(
                PreferenceUtils.getuserFamilyname().capitalizeFirst!,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ), //UserAccountDrawerHeader
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text(
              'Menu',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () {
              Get.to(const MenuScreen());
            },
          ),
          SizedBox(
            height: 10,
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text(
              'Actualités favorite',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () {
              Get.to(const FavoriteScreen());
            },
          ),
          ListTile(
            leading: const Icon(Icons.medical_services),
            title: const Text(
              'Pharmacovigilance',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () {
              Get.to(const PharmaCoVigilanceScreen());
            },
          ),
          ListTile(
            leading: const Icon(Icons.book),
            title: const Text(
              'Liste des Evenements',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () {
              Get.to(const ListEventSceen());
            },
          ),
          SizedBox(
            height: 10,
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text(
              'Déconnecter',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () async {
              await logout(context);
            },
          ),
        ],
      ),
    );
  }
}
