import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../services/local/sharedprefutils.dart';
import '../../../client/pages/news/FavoriteScreen.dart';
import '../../pages/PharmaCo/PhamaCoFormScreen.dart';
import '../../pages/answer/DicusssionDocPro.dart';
import '../../pages/auth/signinpro.dart';
import '../../pages/calculator/CalculatorScreen.dart';
import '../../pages/Events/ListeventScreen.dart';
import '../../pages/MenuScreenPro.dart';

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
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 241, 159, 159),
            ),
            accountName: Text(
              PreferenceUtils.getuserName().capitalizeFirst!,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            accountEmail: Text(
              PreferenceUtils.getuserFamilyname().capitalizeFirst!,
              style: TextStyle(fontSize: 20),
            ),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.network(
                  PreferenceUtils.getUserImage(),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ), // UserAccountsDrawerHeader

          ListTile(
            leading: const Icon(Icons.person),
            title: const Text(
              'Menu',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            onTap: () {
              Get.to(MenuScreenPro());
            },
          ),
          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text(
              'Vos actualités favorites',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            onTap: () {
              Get.to(const FavoriteScreen());
            },
          ),
          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Icons.book),
            title: const Text(
              'Vos événements',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            onTap: () {
              Get.to(const ListEventSceen());
            },
          ),

          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Icons.mark_unread_chat_alt_outlined),
            title: const Text(
              'Forum Santé',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            onTap: () {
              Get.to(const DicusssionDocPro());
            },
          ),

          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text(
              'Déconnecter',
              style: TextStyle(fontWeight: FontWeight.w600),
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
