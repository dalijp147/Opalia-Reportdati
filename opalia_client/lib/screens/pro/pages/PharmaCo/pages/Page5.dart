import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:opalia_client/screens/pro/pages/PharmaCo/pages/PAge4.dart';
import 'package:opalia_client/screens/pro/pages/PharmaCo/pages/Page6.dart';

import '../../../../../models/farma.dart';
import '../../../../../services/remote/apiServicePro.dart';
import '../../../../client/widgets/Allappwidgets/constant.dart';
import '../../../widgets/Farma/FormText.dart';

class Page5 extends StatefulWidget {
  final Farma farma;

  const Page5({super.key, required this.farma});

  @override
  State<Page5> createState() => _Page5State();
}

class _Page5State extends State<Page5> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController codepostalController;
  late TextEditingController adresseController;
  late TextEditingController telephoneController;
  late TextEditingController villeController;
  @override
  void initState() {
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
    villeController.dispose();
    codepostalController.dispose();
    telephoneController.dispose();
    adresseController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Assuming that you're only allowing one selection for each field, otherwise you'll need to handle multiple selections

      Farma newFarma = widget.farma.copyWith(
        villeeffet: nameController.text, // Replace with actual value
        dateeffet: DateTime.tryParse(codepostalController.text) ??
            DateTime.now(), // Replace with actual value
        duree: int.tryParse(villeController.text) ??
            0, // Replace with actual value
        description: adresseController
            .text, // Replace with actual value// Replace with actual value
      );

      bool result = await ApiServicePro.postFarma(newFarma);
      if (result) {
        Get.to(Page6(
            //    farma: newFarma,
            // farma: newFarma,
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
        codepostalController.text = DateFormat('yyyy-MM-dd').format(_picked);
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
        title: Text('Formulaire '),
        centerTitle: true,
        // bottom:
      ),
      body: Form(
        key: _formKey,
        child: Container(
          height: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'EFFET',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  FormText(
                    nameController: nameController,
                    hintText: 'Ville de surevenu',
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "veullez une date ";
                          } else {
                            return null;
                          }
                        },
                        controller: codepostalController,
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
                          hintText: "date ",
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
              FormText(
                nameController: villeController,
                hintText: "duree de l'effet",
              ),
              FormText(
                nameController: adresseController,
                hintText: 'Déscription de léffet',
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
