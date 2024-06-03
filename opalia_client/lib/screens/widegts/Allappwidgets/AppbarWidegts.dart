import 'package:flutter/material.dart';

class AppbarWidgets extends StatelessWidget implements PreferredSizeWidget {
  const AppbarWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                stops: [1, 0.1],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.red.shade50, Colors.white])),
      ),
      centerTitle: true,
      title: const Text(
        'My OPALIA',
        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
