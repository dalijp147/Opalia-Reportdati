import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:opalia_client/screens/pages/HomeScreen.dart';
import 'package:opalia_client/screens/pages/news/NewsScreen.dart';

import '../screens/pages/agenda/AgendaScreen.dart';
import '../screens/pages/quiz/QuizScreen.dart';

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
      bottomNavigationBar: Obx(() => Container(
            color: Colors.white,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
              child: GNav(
                selectedIndex: controller.selectedIndex.value,
                onTabChange: (value) => controller.selectedIndex.value = value,
                tabActiveBorder: Border.all(
                    color: Colors.red, width: 1), // tab button border
                gap: 5,
                iconSize: 25,
                color: Colors.red,
                activeColor: Colors.red,

                tabs: const [
                  GButton(
                    icon: Icons.home,
                    text: 'Home',
                  ),
                  GButton(
                    icon: Icons.newspaper,
                    text: 'News',
                  ),
                  GButton(
                    icon: Icons.view_agenda,
                    text: 'Agenda',
                  ),
                  GButton(
                    icon: Icons.quiz_outlined,
                    text: 'quiz',
                  ),
                ],
              ),
            ),
          )),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  final screens = [
    HomeScreen(),
    NewsScreen(),
    AgendaScreen(),
    QuizScreen(),
  ];
}
