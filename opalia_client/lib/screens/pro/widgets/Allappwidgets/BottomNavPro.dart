import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:opalia_client/screens/client/pages/categorie/CategorieScreen.dart';
import 'package:opalia_client/screens/pro/pages/Events/EventsScreen.dart';

import '../../pages/Categorie/CategorieHomePro.dart';
import '../../pages/HomeScreenPro.dart';

class BottomNavPRo extends StatefulWidget {
  final String? token;

  const BottomNavPRo({super.key, this.token});

  @override
  State<BottomNavPRo> createState() => _BottomNavPRoState();
}

class _BottomNavPRoState extends State<BottomNavPRo> {
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
            Icon(Icons.event_note_sharp, size: 40, color: Colors.red),
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
    CategorieProScreen(),
    HomeScreenAppPRo(),
    EventsScreen(),
  ];
}
