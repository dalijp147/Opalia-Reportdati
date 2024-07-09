import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opalia_client/screens/pro/pages/PharmaCo/pages/Page5.dart';
import 'package:opalia_client/screens/pro/pages/PharmaCo/pages/Page7.dart';

import '../../../widgets/Farma/FormText.dart';

class Page6 extends StatefulWidget {
  const Page6({super.key});

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
            FormText(
              nameController: nameController,
              hintText: 'Date de décés',
            ),
            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                      //  Get.to(Page5());
                      },
                      child: Text('Précedent'),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Get.to(Page7());
                      },
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
