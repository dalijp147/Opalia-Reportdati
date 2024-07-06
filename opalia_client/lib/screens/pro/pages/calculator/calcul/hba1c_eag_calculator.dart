import 'package:flutter/material.dart';

class HbA1cCalculator extends StatefulWidget {
  @override
  _HbA1cCalculatorState createState() => _HbA1cCalculatorState();
}

class _HbA1cCalculatorState extends State<HbA1cCalculator> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _hba1cController = TextEditingController();
  String _message = '';

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
          'HbA1c Calculator',
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
              'HbA1c (hémoglobine glyquée) est une mesure importante pour '
              'surveiller la glycémie chez les personnes atteintes de diabète.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _hba1cController,
                    decoration: InputDecoration(labelText: 'HbA1c (%)'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your HbA1c level';
                      }
                      try {
                        double.parse(value);
                      } catch (e) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _calculateHbA1c,
                    child: Text('Calculate'),
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
                  Center(
                    child: Text(
                      _message,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _calculateHbA1c() {
    if (_formKey.currentState!.validate()) {
      double hba1c = double.parse(_hba1cController.text);

      String message;
      if (hba1c < 5.7) {
        message = 'Normal';
      } else if (hba1c >= 5.7 && hba1c < 6.5) {
        message = 'Prediabetes';
      } else {
        message = 'Diabetes';
      }

      setState(() {
        _message = 'Your HbA1c level is $hba1c%. $message';
      });
    }
  }

  void _clearFields() {
    _hba1cController.clear();
    setState(() {
      _message = '';
    });
  }

  @override
  void dispose() {
    _hba1cController.dispose();
    super.dispose();
  }
}

void main() {
  runApp(MaterialApp(
    home: HbA1cCalculator(),
  ));
}
