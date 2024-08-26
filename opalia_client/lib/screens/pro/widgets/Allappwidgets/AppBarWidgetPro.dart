import 'package:flutter/material.dart';

import 'BadgSocket.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(350),
      child: AppBar(
        backgroundColor: const Color.fromARGB(
            0, 255, 255, 255), // Set the background to transparent
        elevation: 3, // Remove the shadow/elevation

        centerTitle: true,
        title: const Text(
          'My OPALIA PRO',
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.density_medium_outlined,
            color: Colors.red,
          ),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        actions: [BadgesSocket()],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
