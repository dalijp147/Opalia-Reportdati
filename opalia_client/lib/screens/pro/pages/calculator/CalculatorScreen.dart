import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opalia_client/screens/pro/pages/calculator/calcul/MMRCcalculator.dart';
import 'package:opalia_client/screens/pro/pages/calculator/calcul/PANSScalculator.dart';
import 'package:opalia_client/screens/pro/pages/calculator/calcul/Rac.dart';

import 'calcul/ACT.dart';
import 'calcul/Bodysurfacearea.dart';
import 'calcul/CardioGloboriskCalculator.dart';
import 'calcul/CombinedCalculator.dart';
import 'calcul/CreatinineCockcroftGault.dart';
import 'calcul/MDRDPage.dart';
import 'calcul/hba1c_eag_calculator.dart';
import 'calcul/srr_calculator.dart';
import 'categorie/Psychiatrie.dart';
import 'categorie/Respiratoire.dart';
import 'categorie/cardio.dart';
import 'categorie/nephroScreen.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final List<Map<String, dynamic>> calculators = [
    {
      'title': 'Cardio',
      'widget': CArdioScreen(),
      'backgroundImage': 'assets/images/coeur.png', // Add your image path here
    },
    {
      'title': 'Nephro',
      'widget': NephroScreen(),
      'backgroundImage':
          'assets/images/Group486.png', // Add your image path here
    },
    {
      'title': 'Respiratoire',
      'widget': RespiratoireScreen(),
      'backgroundImage':
          'assets/images/poumons.png', // Add your image path here
    },
    {
      'title': 'Psychiatrie',
      'widget': PsychiatrieScreen(),
      'backgroundImage': 'assets/images/Vector.png', // Add your image path here
    },
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
                'Nos calculateurs médicaux',
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
                  childAspectRatio: 3 / 3, // Aspect ratio for each grid item
                ),
                itemCount: calculators.length,
                itemBuilder: (context, index) {
                  final calculator = calculators[index];
                  return Card(
                    elevation: 3,
                    // Make the card's background transparent
                    child: InkWell(
                      onTap: () {
                        Get.to(calculator['widget']);
                      },
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Transform.scale(
                            scale: 0.7, // Adjust the scale as needed
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image:
                                      AssetImage(calculator['backgroundImage']),
                                  fit: BoxFit.fill,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 160),
                              child: Text(
                                calculator['title'],
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors
                                      .black, // Change text color to stand out against the background
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
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
