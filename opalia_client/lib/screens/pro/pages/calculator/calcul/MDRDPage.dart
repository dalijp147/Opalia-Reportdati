import 'dart:math';
import 'package:flutter/material.dart';

enum Gender { male, female }

class MDRDPage extends StatefulWidget {
  @override
  _MDRDPageState createState() => _MDRDPageState();
}

class _MDRDPageState extends State<MDRDPage> {
  TextEditingController ageController = TextEditingController();
  TextEditingController creatinineController = TextEditingController();

  Gender selectedGender = Gender.male;
  bool isBlack = false;
  double mdrdResult = 0.0;

  void calculateMDRD() {
    double age = double.tryParse(ageController.text) ?? 0.0;
    double creatinineUmolL = double.tryParse(creatinineController.text) ?? 0.0;

    // Vérifier que les valeurs saisies sont valides
    if (age > 0.0 && creatinineUmolL > 0.0) {
      // Conversion de la créatinine de µmol/L en mg/dL
      double creatinineMgDl = creatinineUmolL / 88.4;

      print('Age: $age');
      print('Créatinine (µmol/L): $creatinineUmolL');
      print('Créatinine (mg/dL): $creatinineMgDl');

      setState(() {
        double raceCorrection = isBlack ? 1.212 : 1.0;
        double genderCorrection = selectedGender == Gender.female ? 0.742 : 1.0;

        mdrdResult = 186.0 *
            pow(creatinineMgDl, -1.154) *
            pow(age, -0.203) *
            genderCorrection *
            raceCorrection;
      });
      _showResultMessage();
    } else {
      setState(() {
        mdrdResult = 0.0;
      });
      _showErrorMessage();
    }
  }

  void _showResultMessage() {
    String message = '';

    if (selectedGender == Gender.male) {
      if (mdrdResult >= 90) {
        message = 'Résultat normal pour un homme.';
      } else if (mdrdResult >= 60 && mdrdResult < 90) {
        message = 'Légèrement diminué pour un homme.';
      } else if (mdrdResult >= 30 && mdrdResult < 60) {
        message = 'Modérément diminué pour un homme.';
      } else if (mdrdResult >= 15 && mdrdResult < 30) {
        message = 'Sévèrement diminué pour un homme.';
      } else if (mdrdResult < 15) {
        message = 'Insuffisance rénale terminale pour un homme.';
      }
    } else {
      if (mdrdResult >= 90) {
        message = 'Résultat normal pour une femme.';
      } else if (mdrdResult >= 60 && mdrdResult < 90) {
        message = 'Légèrement diminué pour une femme.';
      } else if (mdrdResult >= 30 && mdrdResult < 60) {
        message = 'Modérément diminué pour une femme.';
      } else if (mdrdResult >= 15 && mdrdResult < 30) {
        message = 'Sévèrement diminué pour une femme.';
      } else if (mdrdResult < 15) {
        message = 'Insuffisance rénale terminale pour une femme.';
      }
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Résultat du Calcul MDRD'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Le calcul MDRD estime le taux de filtration glomérulaire (GFR) en ml/min/1.73m².',
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 10),
            Text('Résultat du MDRD : ${mdrdResult.toStringAsFixed(2)}'),
            SizedBox(height: 10),
            Text('Interprétation : $message'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorMessage() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Erreur'),
        content: Text(
            'Veuillez entrer des valeurs valides pour l\'âge et la créatinine.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

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
          'MDRD Calculator',
          style: TextStyle(
            color: Color.fromARGB(252, 2, 38, 68),
            fontSize: 30,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 10),
            Text(
              'L\'équation MDRD estime le taux de filtration glomérulaire (GFR) en ml/min/1.73m².',
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<Gender>(
              value: selectedGender,
              onChanged: (Gender? value) {
                setState(() {
                  selectedGender =
                      value ?? Gender.male; // Default to male if null
                });
              },
              items: Gender.values.map((Gender gender) {
                return DropdownMenuItem<Gender>(
                  value: gender,
                  child: Text(gender == Gender.male ? 'Homme' : 'Femme'),
                );
              }).toList(),
              decoration: InputDecoration(labelText: 'Sexe'),
            ),
            SizedBox(height: 10),
            CheckboxListTile(
              title: Text('Sujets noirs'),
              value: isBlack,
              onChanged: (bool? value) {
                setState(() {
                  isBlack = value ?? false;
                });
              },
            ),
            TextField(
              controller: ageController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: 'Age'),
            ),
            TextField(
              controller: creatinineController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration:
                  InputDecoration(labelText: 'Créatinine sérique (µmol/L)'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: calculateMDRD,
              child: Text('Calculer le MDRD'),
            ),
            SizedBox(height: 20.0),
            Text(
              'Résultat du MDRD : ${mdrdResult.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
