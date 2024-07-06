import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opalia_client/screens/pro/pages/PharmaCo/pages/Page1.dart';
import 'package:opalia_client/screens/pro/pages/PharmaCo/pages/Page3.dart';

class Page2 extends StatefulWidget {
  const Page2({super.key});

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    _isCheckedc = List<bool>.filled(textTimestre.length, false);
    _isCheckedc = List<bool>.filled(textTimestrea.length, false);
    _isCheckedc = List<bool>.filled(textTimestreb.length, false);
    _isCheckedc = List<bool>.filled(textTimestrev.length, false);
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
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Get.to(Page1());
                    },
                    child: Text('Précedent'),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Get.to(Page3());
                    },
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
