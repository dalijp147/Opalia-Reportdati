import 'package:flutter/material.dart';

class RACCalculator extends StatefulWidget {
  @override
  _RACCalculatorState createState() => _RACCalculatorState();
}

class _RACCalculatorState extends State<RACCalculator> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _albuminController = TextEditingController();
  TextEditingController _creatinineController = TextEditingController();

  double? _racResult;

  void _calculateRAC() {
    if (_formKey.currentState!.validate()) {
      double albumin = double.parse(_albuminController.text);
      double creatinine = double.parse(_creatinineController.text);

      setState(() {
        // Calculate RAC
        _racResult = albumin / creatinine;
      });

      // Show result message
      _showResultMessage();
    }
  }

  void _showResultMessage() {
    if (_racResult != null) {
      String message;
      if (_racResult! < 30) {
        message = 'RAC Normal. Les reins sont en bonne santé. 👍';
      } else if (_racResult! >= 30 && _racResult! <= 300) {
        message = 'Microalbuminurie détectée. Consultez un médecin. ⚠️';
      } else {
        message =
            "Macroalbuminurie sévère. Besoin d'une attention médicale urgente. 🚨";
      }

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Résultat du Calcul de RAC'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  'Rapport Albuminurie/Créatininurie (RAC): ${_racResult!.toStringAsFixed(2)}'),
              SizedBox(height: 10),
              Text(message),
            ],
          ),
          actions: <Widget>[
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
          'Calculateur de RAC',
          style: TextStyle(
            color: Color.fromARGB(252, 2, 38, 68),
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Calculateur de Rapport Albuminurie/Créatininurie (RAC)\n\n'
                'Entrez les valeurs nécessaires ci-dessous :',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _albuminController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Albumine urinaire (mg/L)',
                  labelStyle: TextStyle(color: Colors.blue),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer la valeur de l\'albumine';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _creatinineController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Créatinine urinaire (mg/L)',
                  labelStyle: TextStyle(color: Colors.blue),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer la valeur de la créatinine';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _calculateRAC,
                style: ElevatedButton.styleFrom(
                  shadowColor: Colors.white,
                  backgroundColor: Colors.black, // Text color
                  padding: EdgeInsets.all(12), // Button padding
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(8), // Button border radius
                  ),
                ),
                child: Center(
                  child: Icon(Icons.calculate),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
