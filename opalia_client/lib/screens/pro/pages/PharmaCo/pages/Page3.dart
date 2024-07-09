import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opalia_client/screens/pro/pages/PharmaCo/pages/PAge4.dart';
import 'package:opalia_client/screens/pro/pages/PharmaCo/pages/Page2.dart';

import '../../../../../models/farma.dart';
import '../../../../../services/remote/apiServicePro.dart';
import '../../../widgets/Farma/FormText.dart';
import 'Page5.dart';

class Page3 extends StatefulWidget {
  final Farma farma;
  const Page3({super.key, required this.farma});

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

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      String arret = _isChecked.indexWhere((element) => element) >= 0
          ? text[_isChecked.indexWhere((element) => element)]
          : "";
      // Assuming that you're only allowing one selection for each field, otherwise you'll need to handle multiple selections

      Farma newFarma = widget.farma.copyWith(
        nomdeclarent: nameController.text, // Replace with actual value
        prenomdeclarent: prenomController.text, // Replace with actual value
        villedeclarent: villeController.text, // Replace with actual value
        codepostaldeclarent: int.tryParse(codepostalController.text) ??
            0, // Replace with actual value
        telephonedeclarent: int.tryParse(telephoneController.text) ??
            0, // Replace with actual value
        qualite: arret, // Replace with actual value
      );

      bool result = await ApiServicePro.postFarma(newFarma);
      if (result) {
        Get.to(Page4(
          farma: newFarma,
        ));
      } else {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create Farma')),
        );
      }
    }
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
              Text(
                'PRATICIEN DÉCLARANT',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(
                height: 10,
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
                    onPressed: _submitForm,
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
