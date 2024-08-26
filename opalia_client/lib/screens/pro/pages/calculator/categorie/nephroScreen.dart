import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../calcul/CreatinineCockcroftGault.dart';
import '../calcul/MDRDPage.dart';
import '../calcul/Rac.dart';
import '../calcul/srr_calculator.dart';

class NephroScreen extends StatefulWidget {
  const NephroScreen({super.key});

  @override
  State<NephroScreen> createState() => _NephroScreenState();
}

class _NephroScreenState extends State<NephroScreen> {
  final List<Map<String, dynamic>> calculators = [
    {
      'title': 'Score de Risque Rénal (SRR S2R KFRE)',
      'widget': KFRECalculator(),
    },
    {
      'title': 'Creatinine Clearance MDRD GFR Equation',
      'widget': MDRDPage(),
    },
    {
      'title': 'Clairance de la créatinine Formule de Cockcroft et Gault',
      'widget': CockcroftGaultCalculator(),
    },
    {
      'title': 'Calculateur de rapport albuminurie/créatininurie (RAC)',
      'widget': RACCalculator(),
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
                'Nos calculateurs de Néphro',
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
