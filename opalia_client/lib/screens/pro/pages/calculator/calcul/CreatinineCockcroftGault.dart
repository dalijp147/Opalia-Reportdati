import 'package:flutter/material.dart';

enum Gender { male, female }

class CockcroftGaultCalculator extends StatefulWidget {
  @override
  _CockcroftGaultCalculatorState createState() =>
      _CockcroftGaultCalculatorState();
}

class _CockcroftGaultCalculatorState extends State<CockcroftGaultCalculator> {
  TextEditingController ageController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController creatinineController = TextEditingController();

  Gender selectedGender = Gender.male;
  double clearanceResult = 0.0;

  void calculateClearance() {
    double age = double.tryParse(ageController.text) ?? 0.0;
    double weight = double.tryParse(weightController.text) ?? 0.0;
    double creatinine = double.tryParse(creatinineController.text) ?? 0.0;

    if (age > 0.0 && weight > 0.0 && creatinine > 0.0) {
      setState(() {
        if (selectedGender == Gender.male) {
          clearanceResult = ((140 - age) * weight) / (72 * creatinine);
        } else {
          clearanceResult = ((140 - age) * weight * 0.85) / (72 * creatinine);
        }
      });
      _showResultDialog();
    } else {
      _showErrorDialog();
    }
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Résultat de la Clairance de la Créatinine'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Formule de Cockcroft et Gault',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
                'Clairance de la Créatinine : ${clearanceResult.toStringAsFixed(2)} mL/min'),
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

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Erreur'),
        content: Text(
            'Veuillez entrer des valeurs valides pour l\'âge, le poids et la créatinine.'),
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
          'Calculateur de Clairance de la Créatinine',
          style: TextStyle(
            color: Color.fromARGB(252, 2, 38, 68),
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: ageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Âge'),
            ),
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Poids (kg)'),
            ),
            TextField(
              controller: creatinineController,
              keyboardType: TextInputType.number,
              decoration:
                  InputDecoration(labelText: 'Créatinine sérique (mg/dL)'),
            ),
            SizedBox(height: 10),
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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: calculateClearance,
              child: Text('Calculer la Clairance de la Créatinine'),
            ),
          ],
        ),
      ),
    );
  }
}

// void main() {
//   runApp(MaterialApp(
//     home: CockcroftGaultCalculator(),
//   ));
// }
