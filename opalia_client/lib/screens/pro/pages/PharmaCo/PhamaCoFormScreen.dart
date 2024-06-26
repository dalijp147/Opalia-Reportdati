import 'package:flutter/material.dart';

class PharmaCoVigilanceScreen extends StatefulWidget {
  const PharmaCoVigilanceScreen({super.key});

  @override
  State<PharmaCoVigilanceScreen> createState() =>
      _PharmaCoVigilanceScreenState();
}

class _PharmaCoVigilanceScreenState extends State<PharmaCoVigilanceScreen> {
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
        title: Text('Pharmacovigilance'),
        centerTitle: true,
        // bottom:
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Text(
              'Le rôle de la pharmacovigilance est triple :',
              style: TextStyle(
                  color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text(
                "Détecter, évaluer et surveiller les risques liés à l’utilisation de l’ensemble des médicaments chez Opalia Recordati.Rechercher et mettre en œuvre des mesures permettant de diminuer et de prévenir la survenue d’événements indésirables Promouvoir le bon usage du médicament et en garantir la sécurité d’emploi.Cette mission s’effectue de façon continue avec les autorités compétentes et l’ensemble des professionnels de santé afin d’améliorer la connaissance des produits et d’en maîtriser au mieux les risques dans leurs conditions réelles d’utilisation."),
            SizedBox(
              height: 10,
            ),
            Text(
              'Le résultat de ce travail permet :  ',
              style: TextStyle(
                  color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text("D’optimiser le rapport bénéfice/risque d’un médicament."),
            Text("De déterminer le meilleur traitement pour un patient donné."),
            Text(
                "D’informer les médecins sur les risques éventuels liés au produit."),
            Text(
                "De proposer les conditions de mise sur le marché d’un produit."),
            SizedBox(
              height: 10,
            ),
            Text(
              'Sensibiliser et former à la pharmacovigilance :  ',
              style: TextStyle(
                  color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text(
                "Le département pharmacovigilance / épidémiologie d’Opalia Recordati a l’objectif de mettre en place un nouveau programme de formation pour sensibiliser tous les salariés à l’importance de la pharmacovigilance et à ses procédures."),
            Text(
                "Cette formation aura l’ambition d’être déployée à l’ensemble du Groupe, y compris auprès des visiteurs médicaux et commerciaux. Ce programme de sensibilisation rappellera les règles de base de la sécurité, présentera l’organisation mise en place, et détaillera les outils disponibles ainsi que les procédures à respecter."),
            Text(
                "Des formations spécifiques seront également disponibles pour les responsables dédiés à la pharmacovigilance au sein du groupe, pour assurer une mise à jour régulière de leurs connaissances."),
            Text(
                "Ce programme de formation permettra, entre autres, de respecter les engagements d’Opalia Recordati à se conformer à toutes les obligations de déclarations des événements indésirables dans les délais impartis par la réglementation nationale et internationale."),
            SizedBox(
              height: 10,
            ),
            Text(
              'Appelez notre numéro vert pour toutes vos questions ! : 80 100 070 ',
              style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Un solide environnement réglementaire :',
              style: TextStyle(
                  color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text(
              "La pharmacovigilance est un domaine extrêmement réglementé dans l’industrie pharmaceutique. De nombreuses règlementations, politiques générales et recommandations existent, notamment au niveau Tunisien, Européen, International et Américain. Le respect de ces règles est la garantie du maintien des meilleurs niveaux de pratiques en matière de sécurité des patients. Au sein du département Pharmacovigilance et Épidémiologie, les responsables chargés d’évaluer la sécurité des produits ont pour mission d’analyser et de gérer tous les signaux potentiels émis par chaque produit, ainsi que de les documenter. Et ce, quelle que soit l’origine du signal",
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text(
                'Formulaire',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            )
          ],
        ),
      ),
    );
  }
}
