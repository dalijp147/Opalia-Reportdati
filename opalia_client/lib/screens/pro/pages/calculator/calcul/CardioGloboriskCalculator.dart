import 'package:flutter/material.dart';
import 'dart:math';

// void main() {
//   runApp(CardioGloboriskCalculator());
// }

// class CardioGloboriskCalculator extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'CardioGloboriskCalculator',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: RiskCalculatorScreen(),
//     );
//   }
// }

class RiskCalculatorScreen extends StatefulWidget {
  @override
  _RiskCalculatorScreenState createState() => _RiskCalculatorScreenState();
}

class _RiskCalculatorScreenState extends State<RiskCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();

  int age = 0;
  String gender = 'Homme';
  double cholesterol = 0;
  double hdl = 0;
  double systolicBP = 0;
  bool isSmoker = false;
  bool isTreatedForBP = false; // New variable for blood pressure treatment

  double _risk = 0;

  void calculateRisk() {
    setState(() {
      double coefficientAge;
      double coefficientCholesterol;
      double coefficientHDL;
      double coefficientPA;
      double coefficientTreatedBP;
      double coefficientFumeur;
      double coefficientAgeCholesterol;
      double coefficientAgeSmoker;
      double coefficientAgeAge = 0; // Only for men

      double lnAge = log(age.toDouble());
      double lnCholesterol = log(cholesterol);
      double lnHDL = log(hdl);
      double lnSystolicBP = log(systolicBP);

      if (gender == 'Homme') {
        coefficientAge = 52.00961;
        coefficientCholesterol = 20.014077;
        coefficientHDL = -0.905964;
        coefficientPA = 1.305784;
        coefficientTreatedBP = 0.241549;
        coefficientFumeur = 12.096316;
        coefficientAgeCholesterol = -4.605038;
        coefficientAgeSmoker = -2.84367;
        coefficientAgeAge = -2.93323;
      } else {
        coefficientAge = 31.764001;
        coefficientCholesterol = 22.465206;
        coefficientHDL = -1.187731;
        coefficientPA = 2.552905;
        coefficientTreatedBP = 0.420251;
        coefficientFumeur = 13.07543;
        coefficientAgeCholesterol = -5.060998;
        coefficientAgeSmoker = -2.996945;
      }

      // Adjust age limits for calculation
      if (gender == 'Homme' && age > 70) {
        lnAge = log(70);
      } else if (gender == 'Femme' && age > 78) {
        lnAge = log(78);
      }

      double lValue = coefficientAge * lnAge +
          coefficientCholesterol * lnCholesterol +
          coefficientHDL * lnHDL +
          coefficientPA * lnSystolicBP +
          (isTreatedForBP ? coefficientTreatedBP : 0) +
          (isSmoker ? coefficientFumeur : 0) +
          coefficientAgeCholesterol * lnAge * lnCholesterol +
          (isSmoker ? coefficientAgeSmoker * lnAge : 0);

      if (gender == 'Homme') {
        lValue += coefficientAgeAge * lnAge * lnAge;
      }

      if (gender == 'Homme') {
        lValue -= 172.300168;
      } else {
        lValue -= 146.5933061;
      }

      num pValue;
      if (gender == 'Homme') {
        pValue = 1 - pow(0.9402, exp(lValue));
      } else {
        pValue = 1 - pow(0.98767, exp(lValue));
      }

      _risk = pValue * 100;
    });
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
        title: Text('CardioGloboriskCalculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Âge'),
                keyboardType: TextInputType.number,
                onSaved: (value) => age = int.parse(value!),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre âge';
                  }
                  int age = int.parse(value);
                  if (age < 30 || age > 79) {
                    return 'Âge doit être entre 30 et 79 ans';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: gender,
                decoration: InputDecoration(labelText: 'Sexe'),
                items: ['Homme', 'Femme'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    gender = value!;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Cholestérol (mg/dL)'),
                keyboardType: TextInputType.number,
                onSaved: (value) => cholesterol = double.parse(value!),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre niveau de cholestérol';
                  }
                  double chol = double.parse(value);
                  if (chol < 100 || chol > 400) {
                    return 'Le cholestérol doit être entre 100 et 400 mg/dL';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration:
                    InputDecoration(labelText: 'Cholestérol HDL (mg/dL)'),
                keyboardType: TextInputType.number,
                onSaved: (value) => hdl = double.parse(value!),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre niveau de cholestérol HDL';
                  }
                  double hdlValue = double.parse(value);
                  if (hdlValue < 20 || hdlValue > 100) {
                    return 'Le cholestérol HDL doit être entre 20 et 100 mg/dL';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Pression artérielle systolique (mm Hg)'),
                keyboardType: TextInputType.number,
                onSaved: (value) => systolicBP = double.parse(value!),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre pression artérielle';
                  }
                  double bp = double.parse(value);
                  if (bp < 90 || bp > 200) {
                    return 'La pression artérielle doit être entre 90 et 200 mm Hg';
                  }
                  return null;
                },
              ),
              SwitchListTile(
                title: Text('Fumeur'),
                value: isSmoker,
                onChanged: (value) {
                  setState(() {
                    isSmoker = value;
                  });
                },
              ),
              SwitchListTile(
                title: Text('Traitement pour hypertension'),
                value: isTreatedForBP,
                onChanged: (value) {
                  setState(() {
                    isTreatedForBP = value;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    calculateRisk();
                  }
                },
                child: Text('Calculer le Risque'),
              ),
              SizedBox(height: 20),
              Text(
                "Risque Cardiovasculaire: ${_risk.toStringAsFixed(1)}%   Risque d'IM ou de décès sur 10 ans pour ce patient",
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
