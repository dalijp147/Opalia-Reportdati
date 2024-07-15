import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:opalia_client/screens/pro/pages/PharmaCo/pages/Page5.dart';
import 'package:opalia_client/screens/pro/pages/PharmaCo/pages/Page7.dart';

import '../../../../../models/farma.dart';
import '../../../../../services/remote/apiServicePro.dart';
import '../../../../client/widgets/Allappwidgets/constant.dart';
import '../../../widgets/Farma/FormText.dart';

class Page6 extends StatefulWidget {
  final Farma farma;
  const Page6({super.key, required this.farma});

  @override
  State<Page6> createState() => _Page6State();
}

class _Page6State extends State<Page6> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;

  List<String> textTimestre = [
    "Hospitalisation ou prolongation d'hospitalisation",
    "Incapacité ou invalidité permanente",
    "Mise en jeu du pronostic vital",
  ];
  late List<bool> _isCheckedc;
  @override
  void initState() {
    nameController = TextEditingController();
    _isCheckedc = List<bool>.filled(textTimestre.length, false);
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Assuming that you're only allowing one selection for each field, otherwise you'll need to handle multiple selections
      String arret = _isCheckedc.indexWhere((element) => element) >= 0
          ? textTimestre[_isCheckedc.indexWhere((element) => element)]
          : "";
      Farma newFarma = widget.farma.copyWith(
        gravite: arret, // Replace with actual value
        dategravite: DateTime.tryParse(nameController.text) ??
            DateTime.now(), // Replace with actual value
      );

      Get.to(Page7(
        farma: newFarma,
        // farma: newFarma,
      ));
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
        nameController.text = DateFormat('yyyy-MM-dd').format(_picked);
      });
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
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'GRAVITÉ',
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
                        'Quelle est la gravité ?',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Container(
                        height: 200,
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
            SizedBox(
              height: 15,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "veullez saisire une date ";
                    } else {
                      return null;
                    }
                  },
                  controller: nameController,
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
                    hintText: "date de décés",
                  ),
                  readOnly: true,
                  onTap: () {
                    _selectedDate();
                  },
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: Text('Suivant'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
