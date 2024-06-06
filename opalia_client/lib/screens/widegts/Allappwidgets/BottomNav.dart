import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:opalia_client/screens/pages/categorie/CategorieScreen.dart';
import 'package:opalia_client/screens/pages/news/NewsScreen.dart';

import '../../pages/HomeScreen.dart';
import '../../pages/agenda/AgendaScreen.dart';
import '../../pages/quiz/QuizScreen.dart';

class BottomNav extends StatefulWidget {
  final token;
  const BottomNav({super.key, required this.token});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
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
                  icon: Icons.date_range_rounded,
                  text: 'Agenda',
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
    HomeScreen(),
    AgendaScreen(),
  ];
}
