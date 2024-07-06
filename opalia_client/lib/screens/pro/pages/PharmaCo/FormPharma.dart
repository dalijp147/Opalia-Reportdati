import 'package:flutter/material.dart';
import 'package:opalia_client/screens/pro/pages/PharmaCo/pages/PAge4.dart';
import 'package:opalia_client/screens/pro/pages/PharmaCo/pages/Page1.dart';
import 'package:opalia_client/screens/pro/pages/PharmaCo/pages/Page2.dart';
import 'package:opalia_client/screens/pro/pages/PharmaCo/pages/Page3.dart';
import 'package:opalia_client/screens/pro/pages/PharmaCo/pages/Page5.dart';

class FarmaFormScreen extends StatefulWidget {
  const FarmaFormScreen({super.key});

  @override
  State<FarmaFormScreen> createState() => _FarmaFormScreenState();
}

class _FarmaFormScreenState extends State<FarmaFormScreen> {
  late PageController _controller;
  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        title: Text('Formulaire'),
        centerTitle: true,
        // bottom:
      ),
      body: Page1(),
    );
  }
}
