import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opalia_client/screens/pro/pages/PharmaCo/pages/Page3.dart';
import 'package:opalia_client/screens/pro/pages/PharmaCo/pages/Page5.dart';

import '../../../widgets/Farma/FormText.dart';

class Page4 extends StatefulWidget {
  const Page4({super.key});

  @override
  State<Page4> createState() => _Page4State();
}

class _Page4State extends State<Page4> {
  final _formKey = GlobalKey<FormState>();
  List<String> textTimestre = [
    "Sans information",
    "oui",
    "non",
  ];
  late List<bool> _isCheckedc;
  late TextEditingController prenomController;
  late TextEditingController nameController;
  late TextEditingController villeController;
  late TextEditingController codepostalController;
  late TextEditingController adresseController;
  late TextEditingController telephoneController;
  @override
  void initState() {
    _isCheckedc = List<bool>.filled(textTimestre.length, false);
    prenomController = TextEditingController();
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
    prenomController.dispose();
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
      body: SingleChildScrollView(  
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Un ou des produits ont-il été arrêtés ?',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Container(
                          height: 150,
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: textTimestre.length,
                            itemBuilder: (context, index) {
                              return CheckboxListTile(
                                value: _isCheckedc[index],
                                title: Text(textTimestre[index]),
                                onChanged: (val) {
                                  setState(() {
                                    _isCheckedc[index] = val!;
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Get.to(Page3());
                    },
                    child: Text('Précedent'),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Get.to(Page5());
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
