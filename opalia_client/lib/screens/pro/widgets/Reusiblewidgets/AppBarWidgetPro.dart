import 'package:flutter/material.dart';

import 'BadgSocket.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            stops: [1, 0.1],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.red.shade50, Colors.white],
          ),
        ),
      ),
      centerTitle: true,
      title: const Text(
        'My OPALIA PRO',
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [BadgesSocket()],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
