import 'package:flutter/material.dart';
import 'dart:math'; // Import dart:math for pow function

class Bodysurfacearea extends StatefulWidget {
  @override
  _BodysurfaceareaState createState() => _BodysurfaceareaState();
}

class _BodysurfaceareaState extends State<Bodysurfacearea> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  String _result = '';
  String _message = '';
  String _imageAsset = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
        title: Text(
          'BSA Calculator',
          style: TextStyle(
            color: Color.fromARGB(252, 2, 38, 68),
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Bienvenue dans le calculateur de Surface Corporelle (BSA)!\n\n'
              'Le BSA est une mesure de la surface totale externe du corps. '
              'Il est utilisé en médecine pour calculer les dosages des médicaments et évaluer '
              'les fonctions métaboliques. Veuillez saisir votre taille et votre poids pour calculer votre BSA.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _heightController,
                    decoration: InputDecoration(labelText: 'Height (cm)'),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your height';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _weightController,
                    decoration: InputDecoration(labelText: 'Weight (kg)'),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your weight';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _calculateBsa,
                    child: Text('Calculate BSA'),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _clearFields,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: Text('Clear'),
                  ),
                  SizedBox(height: 20),
                  _result.isNotEmpty
                      ? Column(
                          children: [
                            Text(
                              'Your Body Surface Area (BSA): $_result sqm',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10),
                            Text(
                              _message,
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10),
                            if (_imageAsset.isNotEmpty)
                              Image.asset(
                                _imageAsset,
                                height: 150,
                              ),
                          ],
                        )
                      : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _calculateBsa() {
    if (_formKey.currentState!.validate()) {
      double height = double.parse(_heightController.text);
      double weight = double.parse(_weightController.text);

      // Calculate BSA using Du Bois formula
      double bsa = 0.007184 * pow(height, 0.725) * pow(weight, 0.425);

      setState(() {
        _result = bsa.toStringAsFixed(2);
        _setMessageAndImage(bsa);
      });
    }
  }

  void _setMessageAndImage(double bsa) {
    if (bsa < 1.6) {
      _message = 'Small body size';
      _imageAsset = 'assets/small_body.png';
    } else if (bsa >= 1.6 && bsa < 1.8) {
      _message = 'Medium body size';
      _imageAsset = 'assets/medium_body.png';
    } else {
      _message = 'Large body size';
      _imageAsset = 'assets/large_body.png';
    }
  }

  void _clearFields() {
    _heightController.clear();
    _weightController.clear();
    setState(() {
      _result = '';
      _message = '';
      _imageAsset = '';
    });
  }
}
