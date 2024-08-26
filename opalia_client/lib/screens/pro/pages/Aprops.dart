import 'package:flutter/material.dart';

class ApropsScreen extends StatelessWidget {
  const ApropsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notre Histoire',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
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
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'OPALIA PHARMA, l’histoire d’une réussite :',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "OPALIA PHARMA a démarré avec 25 personnes, compte aujourd’hui 27 ans après, près de 400 femmes et hommes qui œuvrent dans le même sens : hisser le niveau de la technologie et de la recherche pharmaceutique en Tunisie et la faire rayonner dans son secteur, à l’international.\n\n"
                "Opalia Pharma est parvenue, aujourd’hui, à se positionner comme futur leader dans tous les genres de produits, avec des médicaments couvrant toutes les spécialités et les classes pharmaceutiques, allant de la pédiatrie jusqu’à la cardiologie, la neurologie, l’urologie et la néphrologie.\n\n"
                "Premier exportateur tunisien de médicaments et 4ème en termes de production dans l’industrie pharmaceutique, Opalia Pharma qui devint filiale RECORDATI à part entière restera au service de la médecine et de la santé publique avec des valeurs sociétales.\n\n"
                "Opalia Pharma, un joyau pour RECORDATI GROUP.\n\n"
                "Un pôle de compétitivité et d’excellence, une forte présence à l’international, avec un rayonnement dans la région Afrique-MENA. Ces forts atouts conjugués au choix d’OPALIA PHARMA de fonder sa stratégie sur l’accessibilité de ses produits au plus grand nombre, sont autant de raisons qui ont motivé le choix de RECORDATI GROUP d’intégrer OPALIA PHARMA à son réseau international : OPALIA PHARMA est devenue OPALIA PHARMA RECORDATI GROUP, filiale RECORDATI à part entière, en juillet 2013.\n\n"
                "Ce choix stratégique de RECORDATI permet désormais au Groupe de renforcer sa présence et d’accroître ses activités à l’international via sa nouvelle filiale qui rayonne dans cette région.",
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
