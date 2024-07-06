import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opalia_client/screens/pro/pages/PharmaCo/pages/PAge4.dart';
import 'package:opalia_client/screens/pro/pages/PharmaCo/pages/Page6.dart';

import '../../../widgets/Farma/FormText.dart';

class Page5 extends StatefulWidget {
  const Page5({super.key});

  @override
  State<Page5> createState() => _Page5State();
}

class _Page5State extends State<Page5> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController codepostalController;
  late TextEditingController adresseController;
  late TextEditingController telephoneController;
  late TextEditingController villeController;
  @override
  void initState() {
    nameController = TextEditingController();
    villeController = TextEditingController();
    codepostalController = TextEditingController();
    adresseController = TextEditingController();
    telephoneController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    villeController.dispose();
    codepostalController.dispose();
    telephoneController.dispose();
    adresseController.dispose();
    super.dispose();
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
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: <Widget>[
                FormText(
                  nameController: nameController,
                  hintText: 'Nom',
                ),
                FormText(
                  nameController: codepostalController,
                  hintText: 'Prenom',
                ),
              ],
            ),
            FormText(
              nameController: nameController,
              hintText: 'Nom',
            ),
            FormText(
              nameController: nameController,
              hintText: 'Nom',
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Get.to(Page4());
                  },
                  child: Text('Précedent'),
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    Get.to(Page6());
                  },
                  child: Text('Suivant'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
