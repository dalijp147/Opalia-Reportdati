import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../calcul/PANSScalculator.dart';

class PsychiatrieScreen extends StatefulWidget {
  const PsychiatrieScreen({super.key});

  @override
  State<PsychiatrieScreen> createState() => _PsychiatrieScreenState();
}

class _PsychiatrieScreenState extends State<PsychiatrieScreen> {
  final List<Map<String, dynamic>> calculators = [
    {
      'title': 'PANSS score',
      'widget': PANSSCalculator(),
    },
    // {
    //   'title': 'Nephro',
    //   'widget': RiskCalculatorScreen(),
    // },
    // {
    //   'title': 'Respiratoire',
    //   'widget': CockcroftGaultCalculator(),
    // },
    // {
    //   'title': 'Psychiatrie',
    //   'widget': CockcroftGaultCalculator(),
    // },
  ];

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
          'Calculator',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Nos calculateurs de Psychiatrie',
                style: TextStyle(
                    color: Color.fromRGBO(182, 28, 12, 1), fontSize: 20),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height *
                  0.5, // Adjust height as needed
              child: GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of columns in the grid
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                  childAspectRatio: 3 / 2.5, // Aspect ratio for each grid item
                ),
                itemCount: calculators.length,
                itemBuilder: (context, index) {
                  final calculator = calculators[index];
                  return Card(
                    elevation: 4,
                    child: InkWell(
                      onTap: () {
                        Get.to(calculator['widget']);
                      },
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            calculator['title'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
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
