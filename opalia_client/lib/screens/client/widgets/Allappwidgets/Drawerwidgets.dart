import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../services/local/sharedprefutils.dart';
import '../../pages/auth/signin.dart';
import '../../pages/discussion/DiscussionScreen.dart';
import '../../pages/menu/MenuScreen.dart';
import '../../pages/news/FavoriteScreen.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  String userImage = '';
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
  void initState() {
    super.initState();
    _loadUserImage();
  }

  Future<void> _loadUserImage() async {
    String image = await PreferenceUtils.getUserImage();
    setState(() {
      userImage = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountEmail: Text(
              PreferenceUtils.getuserName().capitalizeFirst! +
                  ' ' +
                  PreferenceUtils.getuserFamilyname().capitalizeFirst!,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            accountName: Text(""),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.network(
                  PreferenceUtils.getUserImage(),
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 241, 159, 159),
            ),
          ), //UserAccountDrawerHeader

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
            leading: const Icon(Icons.mark_unread_chat_alt_outlined),
            title: const Text(
              'Demander un conseil',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () {
              Get.to(const DicusssionDoc());
            },
          ),
          SizedBox(
            height: 10,
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text(
              'Vos Actualités favorites',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () {
              Get.to(const FavoriteScreen());
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
