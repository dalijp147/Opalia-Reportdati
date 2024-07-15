import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opalia_client/screens/pro/pages/PharmaCo/pages/Page1.dart';
import 'package:opalia_client/screens/pro/pages/PharmaCo/pages/Page3.dart';
import 'package:opalia_client/services/remote/apiServicePro.dart';

import '../../../../../models/farma.dart';

class Page2 extends StatefulWidget {
  final Farma farma;
  const Page2({super.key, required this.farma});

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    _isCheckedc = List<bool>.filled(textTimestre.length, false);
    _isCheckeda = List<bool>.filled(textTimestrea.length, false);
    _isCheckedd = List<bool>.filled(textTimestreb.length, false);
    _isCheckeddd = List<bool>.filled(textTimestrev.length, false);
    super.initState();
  }

  late List<bool> _isCheckedc;
  late List<bool> _isCheckeda;
  late List<bool> _isCheckedd;
  late List<bool> _isCheckeddd;
  List<String> textTimestre = [
    "Sans information",
    "oui",
    "non",
  ];
  List<String> textTimestrea = [
    "Sans information",
    "oui",
    "non",
  ];
  List<String> textTimestreb = [
    "Sans information",
    "oui",
    "non",
  ];
  List<String> textTimestrev = [
    "Sans information",
    "oui",
    "non",
  ];
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Collect data from checkboxes
      String arret = _isCheckedc.indexWhere((element) => element) >= 0
          ? textTimestre[_isCheckedc.indexWhere((element) => element)]
          : "";
      String disparition = _isCheckeda.indexWhere((element) => element) >= 0
          ? textTimestrea[_isCheckeda.indexWhere((element) => element)]
          : "";
      String reintroduits = _isCheckedd.indexWhere((element) => element) >= 0
          ? textTimestreb[_isCheckedd.indexWhere((element) => element)]
          : "";
      String reapparition = _isCheckeddd.indexWhere((element) => element) >= 0
          ? textTimestrev[_isCheckeddd.indexWhere((element) => element)]
          : "";

      Farma updatedFarma = widget.farma.copyWith(
        arret: arret,
        disparition: disparition,
        reintroduits: reintroduits,
        reapparition: reapparition,
      );

     // bool result = await ApiServicePro.postFarma(updatedFarma);

      Get.to(Page3(
        farma: updatedFarma,
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
                'PRODUITS',
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
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(children: [
                      Text(
                        "Disparition de la réaction après arrêt d'un ou des produits ?",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Container(
                        height: 150,
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: textTimestrea.length,
                          itemBuilder: (context, index) {
                            return CheckboxListTile(
                              value: _isCheckeda[index],
                              title: Text(textTimestrea[index]),
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
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(children: [
                      Text(
                        'Un ou des produits ont-ils été réintroduits ?',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Container(
                        height: 150,
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: textTimestreb.length,
                          itemBuilder: (context, index) {
                            return CheckboxListTile(
                              value: _isCheckedd[index],
                              title: Text(textTimestreb[index]),
                              onChanged: (val) {
                                setState(() {
                                  _isCheckedd[index] = val!;
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
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(children: [
                      Text(
                        "Réapparition de la réaction après réintroduction d'un ou des produits ?",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Container(
                        height: 150,
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: textTimestrev.length,
                          itemBuilder: (context, index) {
                            return CheckboxListTile(
                              value: _isCheckeddd[index],
                              title: Text(textTimestrev[index]),
                              onChanged: (val) {
                                setState(() {
                                  _isCheckeddd[index] = val!;
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
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text('Suivant'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
