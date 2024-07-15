import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opalia_client/screens/pro/pages/PharmaCo/pages/Page3.dart';
import 'package:opalia_client/screens/pro/pages/PharmaCo/pages/Page5.dart';

import '../../../../../models/farma.dart';
import '../../../../../services/remote/apiServicePro.dart';
import '../../../widgets/Farma/FormText.dart';

class Page4 extends StatefulWidget {
  final Farma farma;

  const Page4({super.key, required this.farma});

  @override
  State<Page4> createState() => _Page4State();
}

class _Page4State extends State<Page4> {
  final _formKey = GlobalKey<FormState>();
  List<String> textTimestre = [
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

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      String arret = _isCheckedc.indexWhere((element) => element) >= 0
          ? textTimestre[_isCheckedc.indexWhere((element) => element)]
          : "";
      // Assuming that you're only allowing one selection for each field, otherwise you'll need to handle multiple selections

      Farma newFarma = widget.farma.copyWith(
        medcineclarent: arret, // Replace with actual value
        nomdeclarentmedecoin: nameController.text, // Replace with actual value
        prenomdeclarentmedecoin:
            prenomController.text, // Replace with actual value
        telephonedeclarentmedein: int.tryParse(telephoneController.text) ??
            0, // Replace with actual value
        qualitemedecindeclartent:
            adresseController.text, // Replace with actual value
      );

      Get.to(Page5(
        farma: newFarma,
      ));
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
                'MÉDECIN PRESCIPTEUR',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
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
                    nameController: adresseController,
                    hintText: 'Qualité',
                  ),
                  FormText(
                    nameController: telephoneController,
                    hintText: 'Telephone',
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
