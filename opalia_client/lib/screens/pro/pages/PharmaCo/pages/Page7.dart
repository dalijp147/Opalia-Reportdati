import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opalia_client/screens/pro/pages/PharmaCo/PhamaCoFormScreen.dart';
import 'package:opalia_client/screens/pro/pages/PharmaCo/pages/Page6.dart';

import '../../../../../models/farma.dart';
import '../../../../../services/remote/apiServicePro.dart';

class Page7 extends StatefulWidget {
  final Farma farma;
  const Page7({super.key, required this.farma});

  @override
  State<Page7> createState() => _Page7State();
}

class _Page7State extends State<Page7> {
  final _formKey = GlobalKey<FormState>();
  List<String> textTimestre = [
    "Guérison sans séquelle",
    "Guérison avec séquelle",
    "Décès dû à l'effet",
    "Décès auquel l'effet a pu contribuer",
    "Décès sans rapport avec l'effet",
    "Sujet non encore rétabli",
    "Inconnue",
  ];
  late List<bool> _isCheckedc;
  @override
  void initState() {
    _isCheckedc = List<bool>.filled(textTimestre.length, false);
    super.initState();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Assuming that you're only allowing one selection for each field, otherwise you'll need to handle multiple selections
      String arret = _isCheckedc.indexWhere((element) => element) >= 0
          ? textTimestre[_isCheckedc.indexWhere((element) => element)]
          : "";
      Farma newFarma = widget.farma.copyWith(
        gravite: arret, // Replace with actual value
      );

      bool result = await ApiServicePro.postFarma(newFarma);
      if (result) {
        Get.to(PharmaCoVigilanceScreen());
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
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'EVOLUTION',
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
                        "Quelle est l'évolution?",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Container(
                        height: 300,
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
            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Get.to(Page6(farma: null,));
                      },
                      child: Text('Précedent'),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _submitForm();
                        Get.to(PharmaCoVigilanceScreen());
                      },
                      child: Text('envoyer'),
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
