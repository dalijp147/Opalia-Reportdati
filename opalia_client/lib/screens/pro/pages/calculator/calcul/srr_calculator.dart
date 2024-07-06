import 'package:flutter/material.dart';

class KFRECalculator extends StatefulWidget {
  @override
  _KFRECalculatorState createState() => _KFRECalculatorState();
}

class _KFRECalculatorState extends State<KFRECalculator> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final TextEditingController _ageController = TextEditingController();

  // Dropdown values for inputs
  String _sex = 'Male'; // Default value
  String _eGFR = '10-14';
  String _uacr = '<30';
  String _age = '<30';
  String _albumin = '≤2.5';
  String _phosphorus = '<3.5';
  String _bicarbonate = '<18';
  String _calcium = '≤8.5';

  // Points mapping for each variable
  Map<String, Map<String, int>> _pointsMap = {
    'eGFR': {
      '10-14': -35,
      '15-19': -30,
      '20-24': -25,
      '25-29': -20,
      '30-34': -15,
      '35-39': -10,
      '40-44': -5,
      '45-49': 0,
      '50-54': 5,
      '55-59': 10,
    },
    'sex': {
      'Female': 0,
      'Male': -2,
    },
    'uacr': {
      '<30': 0,
      '30-300': -14,
      '>300': -22,
    },
    'age': {
      '<30': -4,
      '30-39': -2,
      '40-49': 0,
      '50-59': 2,
      '60-69': 4,
      '70-79': 6,
      '80-89': 8,
      '≥90': 10,
    },
    'albumin': {
      '≤2.5': -5,
      '2.6-3.0': 0,
      '3.1-3.5': 2,
      '≥3.6': 4,
    },
    'phosphorus': {
      '<3.5': 3,
      '3.5-4.5': 0,
      '4.6-5.5': -3,
      '>5.5': -5,
    },
    'bicarbonate': {
      '<18': -7,
      '18-22': -4,
      '23-25': -1,
      '>25': 0,
    },
    'calcium': {
      '≤8.5': -3,
      '8.6-9.5': 0,
      '≥9.6': 2,
    },
  };

  int _riskScore = 0;
  double _riskProbability = 0.0;

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
          'KFRE Calculator',
          style: TextStyle(
            color: Color.fromARGB(252, 2, 38, 68),
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                value: _eGFR,
                decoration: InputDecoration(labelText: 'eGFR (mL/min/1.73m²)'),
                items: _pointsMap['eGFR']?.keys.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    })?.toList() ??
                    [],
                onChanged: (value) {
                  setState(() {
                    _eGFR = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select eGFR';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _sex,
                decoration: InputDecoration(labelText: 'Sex'),
                items: _pointsMap['sex']?.keys.map((String sex) {
                      return DropdownMenuItem<String>(
                        value: sex,
                        child: Text(sex),
                      );
                    })?.toList() ??
                    [],
                onChanged: (value) {
                  setState(() {
                    _sex = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select sex';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _uacr,
                decoration: InputDecoration(
                    labelText: 'Urine Albumin-to-Creatinine Ratio (mg/g)'),
                items: _pointsMap['uacr']?.keys.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    })?.toList() ??
                    [],
                onChanged: (value) {
                  setState(() {
                    _uacr = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select UACR';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _age,
                decoration: InputDecoration(labelText: 'Age (years)'),
                items: _pointsMap['age']?.keys.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    })?.toList() ??
                    [],
                onChanged: (value) {
                  setState(() {
                    _age = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select age';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _albumin,
                decoration: InputDecoration(labelText: 'Serum Albumin (g/dL)'),
                items: _pointsMap['albumin']?.keys.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    })?.toList() ??
                    [],
                onChanged: (value) {
                  setState(() {
                    _albumin = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select albumin';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _phosphorus,
                decoration:
                    InputDecoration(labelText: 'Serum Phosphorus (mg/dL)'),
                items: _pointsMap['phosphorus']?.keys.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    })?.toList() ??
                    [],
                onChanged: (value) {
                  setState(() {
                    _phosphorus = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select phosphorus';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _bicarbonate,
                decoration:
                    InputDecoration(labelText: 'Serum Bicarbonate (mEq/L)'),
                items: _pointsMap['bicarbonate']?.keys.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    })?.toList() ??
                    [],
                onChanged: (value) {
                  setState(() {
                    _bicarbonate = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select bicarbonate';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _calcium,
                decoration: InputDecoration(labelText: 'Serum Calcium (mg/dL)'),
                items: _pointsMap['calcium']?.keys.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    })?.toList() ??
                    [],
                onChanged: (value) {
                  setState(() {
                    _calcium = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select calcium';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _calculateRiskScore,
                child: Text('Calculate Risk'),
              ),
              SizedBox(height: 20.0),
              Text('Risk Score: $_riskScore'),
              Text(
                  'Probability of kidney failure at 5 years: ${_riskProbability.toStringAsFixed(2)}%'),
            ],
          ),
        ),
      ),
    );
  }

  void _calculateRiskScore() {
    int riskScore = 0;

    // Validate inputs before calculating risk score
    if (_formKey.currentState!.validate()) {
      // Mapping input values to their corresponding keys in _pointsMap
      Map<String, String> inputs = {
        'eGFR': _eGFR,
        'sex': _sex,
        'uacr': _uacr,
        'age': _age,
        'albumin': _albumin,
        'phosphorus': _phosphorus,
        'bicarbonate': _bicarbonate,
        'calcium': _calcium,
      };

      // Calculate risk score
      inputs.forEach((key, value) {
        riskScore += _pointsMap[key]?[value] ?? 0;
      });

      // Calculate probability based on risk score
      setState(() {
        _riskScore = riskScore;
        _riskProbability = _calculateProbability(riskScore);
      });
    }
  }

  double _calculateProbability(int riskScore) {
    if (riskScore <= -41) {
      return 90.0;
    } else if (riskScore == -40) {
      return 86.9;
    } else if (riskScore == -39) {
      return 84.1;
    } else if (riskScore == -38) {
      return 81.0;
    } else if (riskScore == -37) {
      return 81.0;
    } else if (riskScore == -36) {
      return 74.4;
    } else if (riskScore == -35) {
      return 70.9;
    } else if (riskScore == -34) {
      return 67.3;
    } else if (riskScore == -33) {
      return 63.6;
    } else if (riskScore == -32) {
      return 59.9;
    } else if (riskScore == -31) {
      return 56.3;
    } else if (riskScore == -30) {
      return 52.8;
    } else if (riskScore == -29) {
      return 49.3;
    } else if (riskScore == -28) {
      return 45.9;
    } else if (riskScore == -27) {
      return 42.7;
    } else if (riskScore == -26) {
      return 39.6;
    } else if (riskScore == -25) {
      return 36.6;
    } else if (riskScore == -24) {
      return 33.8;
    } else if (riskScore == -23) {
      return 31.2;
    } else if (riskScore == -22) {
      return 28.7;
    } else if (riskScore == -21) {
      return 26.4;
    } else if (riskScore == -20) {
      return 24.2;
    } else if (riskScore == -19) {
      return 22.2;
    } else if (riskScore == -18) {
      return 20.3;
    } else if (riskScore == -17) {
      return 18.6;
    } else if (riskScore == -16) {
      return 17.0;
    } else if (riskScore == -15) {
      return 15.5;
    } else if (riskScore == -14) {
      return 14.1;
    } else if (riskScore == -13) {
      return 12.9;
    } else if (riskScore == -12) {
      return 11.7;
    } else if (riskScore == -11) {
      return 10.7;
    } else if (riskScore == -10) {
      return 9.7;
    } else if (riskScore == -9) {
      return 8.8;
    } else if (riskScore == -8) {
      return 8.0;
    } else if (riskScore == -7) {
      return 7.3;
    } else if (riskScore == -6) {
      return 6.6;
    } else if (riskScore == -5) {
      return 6.0;
    } else if (riskScore == -4) {
      return 5.5;
    } else {
      return 5.0;
    }
  }

  @override
  void dispose() {
    // Clean up controllers
    _ageController.dispose();
    super.dispose();
  }
}

void main() {
  runApp(MaterialApp(
    home: KFRECalculator(),
  ));
}
