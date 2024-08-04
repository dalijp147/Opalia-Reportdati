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

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
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
      body: ListView(children: [
        Card(
          borderOnForeground: true,
          child: ListTile(
            textColor: Colors.red,
            trailing: Icon(Icons.navigate_next),
            visualDensity: VisualDensity(vertical: 4),
            onTap: () {
              Get.to(ACTCalculator());
            },
            title: Text(
              'ACT score',
              textScaleFactor: 1.5,
            ),
          ),
        ),
        Card(
          borderOnForeground: true,
          child: ListTile(
            textColor: Colors.red,
            trailing: Icon(Icons.navigate_next),
            visualDensity: VisualDensity(vertical: 4),
            onTap: () {
              Get.to(RiskCalculatorScreen());
            },
            title: Text(
              'Cardio',
              textScaleFactor: 1.5,
            ),
          ),
        ),
        Card(
          borderOnForeground: true,
          child: ListTile(
            textColor: Colors.red,
            trailing: Icon(Icons.navigate_next),
            visualDensity: VisualDensity(vertical: 4),
            onTap: () {
              Get.to(CockcroftGaultCalculator());
            },
            title: Text(
              'Clairance de la créatinine Formule de Cockcroft et Gault',
              textScaleFactor: 1.5,
            ),
          ),
        ),
        Card(
          borderOnForeground: true,
          child: ListTile(
            textColor: Colors.red,
            trailing: Icon(Icons.navigate_next),
            visualDensity: VisualDensity(vertical: 4),
            onTap: () {
              Get.to(RACCalculator());
            },
            title: Text(
              'Calculateur de rapport albuminurie/créatininurie (RAC)',
              textScaleFactor: 1.5,
            ),
          ),
        ),
        Card(
          borderOnForeground: true,
          child: ListTile(
            textColor: Colors.red,
            trailing: Icon(Icons.navigate_next),
            visualDensity: VisualDensity(vertical: 4),
            onTap: () {
              Get.to(PANSSCalculator());
            },
            title: Text(
              'PANSS score',
              textScaleFactor: 1.5,
            ),
          ),
        ),
        Card(
          borderOnForeground: true,
          child: ListTile(
            textColor: Colors.red,
            trailing: Icon(Icons.navigate_next),
            visualDensity: VisualDensity(vertical: 4),
            onTap: () {
              Get.to(MMRCalculator());
            },
            title: Text(
              'mMRC',
              textScaleFactor: 1.5,
            ),
          ),
        ),
        Card(
          borderOnForeground: true,
          child: ListTile(
            textColor: Colors.red,
            trailing: Icon(Icons.navigate_next),
            visualDensity: VisualDensity(vertical: 4),
            onTap: () {
              Get.to(MDRDPage());
            },
            title: Text(
              'Creatinine Clearance MDRD GFR Equation',
              textScaleFactor: 1.5,
            ),
          ),
        ),
        Card(
          borderOnForeground: true,
          child: ListTile(
            textColor: Colors.red,
            trailing: Icon(Icons.navigate_next),
            visualDensity: VisualDensity(vertical: 4),
            onTap: () {
              Get.to(KFRECalculator());
            },
            title: Text(
              'Score de Risque Rénal (SRR S2R KFRE)',
              textScaleFactor: 1.5,
            ),
          ),
        ),
      ]),
    );
  }
}
