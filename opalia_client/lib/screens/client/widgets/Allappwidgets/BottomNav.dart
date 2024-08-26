import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:opalia_client/screens/client/pages/categorie/CategorieScreen.dart';
import 'package:opalia_client/screens/client/pages/news/NewsScreen.dart';

import '../../pages/HomeScreen.dart';
import '../../pages/agenda/AgendaScreen.dart';
import '../../pages/quiz/QuizScreen.dart';

class BottomNav extends StatefulWidget {
  final token;
  const BottomNav({super.key, this.token});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    return Scaffold(
      bottomNavigationBar: Obx(
        () => CurvedNavigationBar(
          index: controller.selectedIndex.value,
          height: 70.0,
          items: <Widget>[
            Icon(Icons.medical_services_outlined, size: 40, color: Colors.red),
            Icon(Icons.home_outlined, size: 40, color: Colors.red),
            Icon(Icons.date_range_outlined, size: 40, color: Colors.red),
          ],
          color: Colors.white,
          buttonBackgroundColor: Colors.red.shade100,
          backgroundColor: Colors.transparent,
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 600),
          onTap: (index) {
            controller.selectedIndex.value = index;
          },
          letIndexChange: (index) => true,
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 1.obs;
  final screens = [
    HomeScreen(),
    HomeScreenApp(),
    AgendaScreen(),
  ];
}
