import 'package:flutter/material.dart';

enum Gender { male, female }

enum ActivityLevel {
  sedentary,
  lightlyActive,
  moderatelyActive,
  veryActive,
  superActive
}

class CombinedCalculator extends StatefulWidget {
  @override
  _CombinedCalculatorState createState() => _CombinedCalculatorState();
}

class _CombinedCalculatorState extends State<CombinedCalculator> {
  TextEditingController ageController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  Gender selectedGender = Gender.male;
  ActivityLevel selectedActivityLevel = ActivityLevel.sedentary;

  double bmi = 0.0;
  double bmr = 0.0;
  double calorie = 0.0;
  double creatine = 0.0;

  void calculateValues() {
    double age = double.tryParse(ageController.text) ?? 0.0;
    double weight = double.tryParse(weightController.text) ?? 0.0;
    double height = double.tryParse(heightController.text) ?? 0.0;

    setState(() {
      bmi = calculateBMI(weight, height);
      bmr = calculateBMR(weight, height, age, selectedGender);
      calorie = calculateCalorie(bmr, selectedActivityLevel);
      creatine = calculateCreatine(weight);
    });
  }

  double calculateBMI(double weight, double height) {
    return weight / ((height / 100) * (height / 100));
  }

  double calculateBMR(double weight, double height, double age, Gender gender) {
    double bmr;
    if (gender == Gender.male) {
      bmr = 10 * weight + 6.25 * height - 5 * age + 5;
    } else {
      bmr = 10 * weight + 6.25 * height - 5 * age - 161;
    }
    return bmr;
  }

  double calculateCalorie(double bmr, ActivityLevel activityLevel) {
    double factor;
    switch (activityLevel) {
      case ActivityLevel.sedentary:
        factor = 1.2;
        break;
      case ActivityLevel.lightlyActive:
        factor = 1.375;
        break;
      case ActivityLevel.moderatelyActive:
        factor = 1.55;
        break;
      case ActivityLevel.veryActive:
        factor = 1.725;
        break;
      case ActivityLevel.superActive:
        factor = 1.9;
        break;
    }
    return bmr * factor;
  }

  double calculateCreatine(double weight) {
    return weight * 0.03; // Example calculation
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
          'Combined Calculator',
          style: TextStyle(
            color: Color.fromARGB(252, 2, 38, 68),
            fontSize: 30,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              'BMI (Body Mass Index): Estimates body fat based on weight and height.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
            Text(
              'BMR (Basal Metabolic Rate): Estimates daily calorie expenditure at rest.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
            Text(
              "CALORIES: estime l'apport calorique quotidien nécessaire pour maintenir votre poids actuel",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
            Text(
              "CREATINE: estime sur le poids corporel de l'utilisateu",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Select Gender:   ',
                  style: TextStyle(
                    color: Color.fromARGB(251, 0, 0, 0),
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                DropdownButton<Gender>(
                  value: selectedGender,
                  onChanged: (Gender? newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedGender = newValue;
                      });
                    }
                  },
                  items: <Gender>[
                    Gender.male,
                    Gender.female,
                  ].map<DropdownMenuItem<Gender>>((Gender value) {
                    return DropdownMenuItem<Gender>(
                      value: value,
                      child: Text(
                        value == Gender.male ? 'Male' : 'Female',
                        style: TextStyle(
                          color: Color.fromARGB(252, 2, 38, 68),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Select Activity Level:    ',
                  style: TextStyle(
                    color: Color.fromARGB(251, 0, 0, 0),
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DropdownButton<ActivityLevel>(
                  value: selectedActivityLevel,
                  onChanged: (ActivityLevel? newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedActivityLevel = newValue;
                      });
                    }
                  },
                  items: ActivityLevel.values
                      .map<DropdownMenuItem<ActivityLevel>>(
                          (ActivityLevel value) {
                    return DropdownMenuItem<ActivityLevel>(
                      value: value,
                      child: Text(
                        describeActivityLevel(value),
                        style: TextStyle(
                          color: Color.fromARGB(252, 2, 38, 68),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            SizedBox(height: 20),
            TextField(
              controller: ageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Age',
                labelStyle: TextStyle(color: Colors.blue),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Weight (kg)',
                labelStyle: TextStyle(color: Colors.blue),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: heightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Height (cm)',
                labelStyle: TextStyle(color: Colors.blue),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: calculateValues,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Color.fromARGB(227, 171, 190, 255), // Background color
                // Text color
                padding: EdgeInsets.symmetric(
                    horizontal: 40, vertical: 16), // Button padding
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10), // Button border radius
                ),
              ),
              child: Icon(Icons.calculate),
            ),
            SizedBox(height: 20),
            Text('BMI: ${bmi.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(252, 2, 38, 68),
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                )),
            SizedBox(height: 5),
            Text('BMI Advice: ${getBMIAdvice(bmi)}',
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(252, 2, 38, 68),
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                )),
            SizedBox(height: 20),
            Text('BMR: ${bmr.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(252, 2, 38, 68),
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                )),
            SizedBox(height: 5),
            Text('BMR Advice: ${getBMRAdvice(bmr)}',
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(252, 2, 38, 68),
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                )),
            SizedBox(height: 20),
            Text('Calorie: ${calorie.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(252, 2, 38, 68),
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                )),
            SizedBox(height: 5),
            Text('Calorie Advice: ${getCalorieAdvice(calorie)}',
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(252, 2, 38, 68),
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                )),
            SizedBox(height: 20),
            Text('Creatine: ${creatine.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(252, 2, 38, 68),
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                )),
            SizedBox(height: 5),
            Text('Creatine Advice: ${getCreatineAdvice(creatine)}',
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(252, 2, 38, 68),
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                )),
          ],
        ),
      ),
    );
  }

  String describeActivityLevel(ActivityLevel level) {
    switch (level) {
      case ActivityLevel.sedentary:
        return 'Sedentary';
      case ActivityLevel.lightlyActive:
        return 'Lightly Active';
      case ActivityLevel.moderatelyActive:
        return 'Moderately Active';
      case ActivityLevel.veryActive:
        return 'Very Active';
      case ActivityLevel.superActive:
        return 'Super Active';
      default:
        return '';
    }
  }

  String getBMIAdvice(double bmi) {
    if (bmi < 18.5) {
      return 'Underweight 🤔';
    } else if (bmi >= 18.5 && bmi < 25) {
      return 'Normal weight 😊';
    } else if (bmi >= 25 && bmi < 30) {
      return 'Overweight ⚠️';
    } else {
      return 'Obesity 🚨';
    }
  }

  String getBMRAdvice(double bmr) {
    if (bmr < 1200 || bmr > 3000) {
      return 'Your BMR seems unusual. Please check your input. ⚠️';
    } else {
      return 'Your BMR indicates the calories your body needs at rest. 🍴';
    }
  }

  String getCalorieAdvice(double calorie) {
    if (calorie < 1500) {
      return 'The estimated calorie intake is low. Please consult a dietitian. 🥗';
    } else {
      return 'The estimated calorie intake is within the normal range. 🍽️';
    }
  }

  String getCreatineAdvice(double creatine) {
    if (creatine < 1.0) {
      return 'The calculated creatine intake is low. Consider increasing it if you exercise intensely. 💪';
    } else {
      return 'The calculated creatine intake seems sufficient for most individuals. 🏋️‍♂️';
    }
  }
}
