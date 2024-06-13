import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:opalia_client/screens/client/pages/categorie/CategorieScreen.dart';
import 'package:opalia_client/screens/client/pages/news/NewsScreen.dart';
import 'package:opalia_client/screens/pro/pages/Events/EventsScreen.dart';

import '../../../client/pages/HomeScreen.dart';
import '../../../client/pages/agenda/AgendaScreen.dart';
import '../../pages/Categorie/CategorieHomePro.dart';

class BottomNavPRo extends StatefulWidget {
  const BottomNavPRo({super.key});

  @override
  State<BottomNavPRo> createState() => _BottomNavPRoState();
}

class _BottomNavPRoState extends State<BottomNavPRo> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    return Scaffold(
      bottomNavigationBar: Obx(
        () => Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
            child: GNav(
              hoverColor: Colors.red.shade100,
              selectedIndex: controller.selectedIndex.value,
              onTabChange: (value) => controller.selectedIndex.value = value,
              tabActiveBorder: Border.all(
                color: Colors.red,
                width: 1,
              ), // tab button border
              gap: 5,
              iconSize: 30,
              color: Colors.red,
              activeColor: Colors.red,

              tabs: const [
                GButton(
                  icon: Icons.home_outlined,
                  text: 'Accueil',
                ),
                GButton(
                  icon: Icons.medical_services_outlined,
                  text: 'Santé',
                ),
                GButton(
                  icon: Icons.event_note_sharp,
                  text: 'évenement',
                ),
              ],
            ),
          ),
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  final screens = [
    HomeScreenApp(),
    CategorieProScreen(),
    EventsScreen(),
  ];
}
