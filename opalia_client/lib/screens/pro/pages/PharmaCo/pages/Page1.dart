import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../client/widgets/Allappwidgets/constant.dart';
import '../../../widgets/Farma/FormText.dart';
import 'Page2.dart';

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController prenomController;
  late TextEditingController nameController;
  late TextEditingController villeController;
  late TextEditingController codepostalController;
  late TextEditingController ageController;
  late TextEditingController dateController;
  @override
  void initState() {
    prenomController = TextEditingController();
    nameController = TextEditingController();
    villeController = TextEditingController();
    codepostalController = TextEditingController();
    _isChecked = List<bool>.filled(text.length, false);
    _isCheckeda = List<bool>.filled(textproduits.length, false);
    _isCheckedb = List<bool>.filled(textNaa.length, false);
    _isCheckedc = List<bool>.filled(
        textTimestre.length, false); // Initialize the list of booleans
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    prenomController.dispose();
    villeController.dispose();
    codepostalController.dispose();
    dateController.dispose();
    ageController.dispose();
    super.dispose();
  }

  late List<bool> _isChecked;
  late List<bool> _isCheckeda;
  late List<bool> _isCheckedb;
  late List<bool> _isCheckedc;
  String _currText = '';

  List<String> text = [
    "Homme",
    "Femme",
  ];
  List<String> textNaa = [
    "oui",
    "non",
  ];
  List<String> textproduits = [
    "Par la mère durant sa grossesse",
    "Par le nouveau né",
    "Lors de l'allaitement",
  ];
  List<String> textTimestre = [
    "1",
    "2",
    "3",
  ];
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Text('PATIENT TRAITÉ'),
            Row(
              children: <Widget>[
                FormText(
                  nameController: prenomController,
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
                  nameController: codepostalController,
                  hintText: 'Code postal',
                ),
              ],
            ),
            Row(
              children: <Widget>[
                FormText(
                  nameController: prenomController,
                  hintText: 'Age',
                ),
                FormText(
                  nameController: prenomController,
                  hintText: 'Data de Naissance',
                ),
              ],
            ),
            Row(
              children: <Widget>[
                FormText(
                  nameController: prenomController,
                  hintText: 'Poids',
                ),
                FormText(
                  nameController: prenomController,
                  hintText: 'Taille',
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: [
                      Text('Sexe'),
                      Container(
                        height: 150,
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
                Expanded(
                  child: Column(children: [
                    Text('S agit t-il d un nouvenau néé'),
                    Container(
                      height: 150,
                      child: ListView.builder(
                        itemCount: textNaa.length,
                        itemBuilder: (context, index) {
                          return CheckboxListTile(
                            value: _isCheckedb[index],
                            title: Text(textNaa[index]),
                            onChanged: (val) {
                              setState(() {
                                _isCheckedb[index] = val!;
                              });
                            },
                          );
                        },
                      ),
                    )
                  ]),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Column(children: [
                    Text('Les produits ont été pris :'),
                    Container(
                      height: 200,
                      child: ListView.builder(
                        itemCount: textproduits.length,
                        itemBuilder: (context, index) {
                          return CheckboxListTile(
                            value: _isCheckeda[index],
                            title: Text(textproduits[index]),
                            onChanged: (val) {
                              setState(() {
                                _isCheckeda[index] = val!;
                              });
                            },
                          );
                        },
                      ),
                    )
                  ]),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Column(children: [
                    Text('Trimestre de grossesse'),
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
                  ]),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                Get.to(Page2());
              },
              child: Text('Suivant'),
            ),
          ],
        ),
      ),
    );
  }
}
