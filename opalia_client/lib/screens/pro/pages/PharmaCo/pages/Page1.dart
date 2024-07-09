import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:opalia_client/services/remote/apiServicePro.dart';

import '../../../../../models/farma.dart';
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
  late TextEditingController poifsController;
  late TextEditingController tailleController;
  @override
  void initState() {
    prenomController = TextEditingController();
    nameController = TextEditingController();
    villeController = TextEditingController();
    codepostalController = TextEditingController();
    dateController = TextEditingController();
    poifsController = TextEditingController();
    tailleController = TextEditingController();

    ageController = TextEditingController();
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
    poifsController.dispose();
    ageController.dispose();

    tailleController.dispose();
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

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      String sexe = text[_isChecked.indexWhere((element) => element)];
      String nouveaune = textNaa[_isCheckedb.indexWhere((element) => element)];
      // Assuming that you're only allowing one selection for each field, otherwise you'll need to handle multiple selections

      Farma newFarma = Farma(
        nompatient: nameController.text,
        prenompatient: prenomController.text,
        villepatient: villeController.text,
        codepostal: int.tryParse(codepostalController.text) ?? 0,
        dateNaissance: DateTime.tryParse(dateController.text) ?? DateTime.now(),
        poids: 0, // Replace with actual value
        age: int.tryParse(ageController.text) ?? 0,
        taille: 0, // Replace with actual value
        sexe: sexe,
        nouveaune: nouveaune,
        produit: '', // Replace with actual value
        grosses: '', // Replace with actual value
        arret: '', // Replace with actual value
        disparition: '', // Replace with actual value
        reintroduits: '', // Replace with actual value
        reapparition: '', // Replace with actual value
        nomdeclarent: '', // Replace with actual value
        prenomdeclarent: '', // Replace with actual value
        villedeclarent: '', // Replace with actual value
        codepostaldeclarent: 0, // Replace with actual value
        telephonedeclarent: 0, // Replace with actual value
        qualite: '', // Replace with actual value
        medcineclarent: '', // Replace with actual value
        nomdeclarentmedecoin: '', // Replace with actual value
        prenomdeclarentmedecoin: '', // Replace with actual value
        telephonedeclarentmedein: 0, // Replace with actual value
        qualitemedecindeclartent: '', // Replace with actual value
        villeeffet: '', // Replace with actual value
        dateeffet: DateTime.now(), // Replace with actual value
        duree: 0, // Replace with actual value
        description: '', // Replace with actual value
        gravite: '', // Replace with actual value
        evolution: '', // Replace with actual value
      );

      bool result = await ApiServicePro.postFarma(newFarma);
      if (result) {
        Get.to(Page2(
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

  Future<void> _selectedDate() async {
    DateTime? _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (_picked != null) {
      setState(() {
        dateController.text = DateFormat('yyyy-MM-dd').format(_picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Text(
              'PATIENT TRAITÉ',
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
                  nameController: codepostalController,
                  hintText: 'Code postal',
                ),
              ],
            ),
            Row(
              children: <Widget>[
                FormText(
                  nameController: ageController,
                  hintText: 'Age',
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "veullez une date de debut";
                        } else {
                          return null;
                        }
                      },
                      controller: dateController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.red,
                          ),
                          borderRadius: kBorderRadius,
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.red,
                            ),
                            borderRadius: kBorderRadius),
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                        ),
                        filled: true,
                        fillColor: Colors.transparent,
                        hintText: "date de debut",
                      ),
                      readOnly: true,
                      onTap: () {
                        _selectedDate();
                      },
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                FormText(
                  nameController: poifsController,
                  hintText: 'Poids',
                ),
                FormText(
                  nameController: tailleController,
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
              onPressed: _submitForm,
              child: Text('Suivant'),
            ),
          ],
        ),
      ),
    );
  }
}
