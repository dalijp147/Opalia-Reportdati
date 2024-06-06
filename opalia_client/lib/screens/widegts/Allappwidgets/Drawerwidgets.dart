import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../services/local/sharedprefutils.dart';
import '../../pages/auth/signin.dart';
import '../../pages/menu/MenuScreen.dart';
import '../../pages/news/FavoriteScreen.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});
  Future<void> logout(BuildContext context) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.remove('token');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SigninScreen()),
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
                PreferenceUtils.getuserName(),
                style: TextStyle(fontSize: 18),
              ),
              accountEmail: Text(
                PreferenceUtils.getuserFamilyname(),
              ),
            ), //UserAccountDrawerHeader
          ),
          ListTile(
            hoverColor: Colors.grey,
            selectedColor: Colors.grey,
            leading: const Icon(Icons.person),
            title: const Text('Menu'),
            onTap: () {
              Get.to(const MenuScreen());
            },
          ),
          ListTile(
            leading: const Icon(Icons.book),
            title: const Text('Actualités favorite'),
            onTap: () {
              Get.to(const FavoriteScreen());
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Modifier Profile '),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Déconnecter'),
            onTap: () async {
              await logout(context);
            },
          ),
        ],
      ),
    );
  }
}
