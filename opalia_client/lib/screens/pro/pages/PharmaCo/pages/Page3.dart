import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opalia_client/screens/pro/pages/PharmaCo/pages/PAge4.dart';
import 'package:opalia_client/screens/pro/pages/PharmaCo/pages/Page2.dart';

import '../../../widgets/Farma/FormText.dart';

class Page3 extends StatefulWidget {
  const Page3({super.key});

  @override
  State<Page3> createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController prenomController;
  late TextEditingController nameController;
  late TextEditingController villeController;
  late TextEditingController codepostalController;
  late TextEditingController adresseController;
  late TextEditingController telephoneController;
  @override
  void initState() {
    _isChecked = List<bool>.filled(text.length, false);
    prenomController = TextEditingController();
    nameController = TextEditingController();
    villeController = TextEditingController();
    codepostalController = TextEditingController();
    adresseController = TextEditingController();
    telephoneController = TextEditingController();
    super.initState();
  }

  List<String> text = [
    "Médecin",
    "Médecin dentiste",
    "Pharmacien",
    "Autre",
  ];
  @override
  void dispose() {
    nameController.dispose();
    prenomController.dispose();
    villeController.dispose();
    codepostalController.dispose();
    telephoneController.dispose();
    adresseController.dispose();
    super.dispose();
  }

  late List<bool> _isChecked;
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
      body: SingleChildScrollView(
        child: Form(
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
                    nameController: prenomController,
                    hintText: 'Prenom',
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  FormText(
                    nameController: villeController,
                    hintText: 'Ville',
                  ),
                  FormText(
                    nameController: adresseController,
                    hintText: 'adresse',
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  FormText(
                    nameController: codepostalController,
                    hintText: 'Code Postal',
                  ),
                  FormText(
                    nameController: telephoneController,
                    hintText: 'Telephone',
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      children: [
                        Text('Qualité'),
                        Container(
                          height: 210,
                          child: ListView.builder(
                            itemCount: text.length,
                            itemBuilder: (context, index) {
                              return CheckboxListTile(
                                value: _isChecked[index],
                                title: Text(text[index]),
                                onChanged: (val) {
                                  setState(() {
                                    _isChecked[index] = val!;
                                  });
                                },
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Get.to(Page2());
                    },
                    child: Text('Précedent'),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Get.to(Page4());
                    },
                    child: Text('Suivant'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
