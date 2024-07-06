import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: MMRCalculator(),
  ));
}

class MMRCalculator extends StatefulWidget {
  @override
  _MMRCalculatorState createState() => _MMRCalculatorState();
}

class _MMRCalculatorState extends State<MMRCalculator> {
  int selectedGrade = 0; // Default selected grade

  // Data for mMRC scale
  Map<int, String> mMRCData = {
    0: "Dyspnea only with strenuous exercise",
    1: "Dyspnea when hurrying on level ground or walking up a slight hill",
    2: "Walks slower than people of the same age because of dyspnea or has to stop for breath when walking at own pace on level ground",
    3: "Stops for breath after walking 100 yards (91 m) or after a few minutes on level ground",
    4: "Too dyspneic to leave house or breathless when dressing",
  };

  // Interpretations for each grade
  Map<int, String> mMRCInterpretations = {
    0: "Minimal dyspnea only with strenuous exercise",
    1: "Mild dyspnea when hurrying or walking up a slight hill",
    2: "Moderate dyspnea, walking slower than others of same age or stopping for breath",
    3: "Severe dyspnea, stopping for breath after walking 100 yards or a few minutes",
    4: "Very severe dyspnea, too breathless to leave house or breathless when dressing",
  };

  // Function to show grade information
  void showGradeInformation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Grade ${selectedGrade.toString()}'),
        content: Text(
          'Interpretation: ${mMRCInterpretations[selectedGrade]}',
          style: TextStyle(fontWeight: FontWeight.bold),
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
          'mMRC Dyspnea Scale',
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Symptom severity - Walking should be assessed on level ground',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: mMRCData.length,
                itemBuilder: (context, index) {
                  int grade = mMRCData.keys.elementAt(index);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RadioListTile<int>(
                        title: Text(mMRCData[grade]!),
                        value: grade,
                        groupValue: selectedGrade,
                        onChanged: (value) {
                          setState(() {
                            selectedGrade = value!;
                          });
                          showGradeInformation(); // Display information on selection
                        },
                      ),
                      Divider(),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
