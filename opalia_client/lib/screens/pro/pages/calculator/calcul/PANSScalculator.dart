import 'package:flutter/material.dart';

// void main() {
//   runApp(PANSSApp());
// }

class PANSSApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculateur de Score PANSS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PANSSCalculator(),
    );
  }
}

class PANSSCalculator extends StatefulWidget {
  @override
  _PANSSCalculatorState createState() => _PANSSCalculatorState();
}

class _PANSSCalculatorState extends State<PANSSCalculator> {
  final _formKey = GlobalKey<FormState>();
  final List<int> _positiveScores = List<int>.filled(7, 1);
  final List<int> _negativeScores = List<int>.filled(7, 1);
  final List<int> _generalScores = List<int>.filled(16, 1);

  int _positiveTotal = 0;
  int _negativeTotal = 0;
  int _generalTotal = 0;
  int _overallTotal = 0;

  final List<String> _positiveDescriptions = [
    'Délires : Croyances fausses, fixes et fortement tenues malgré des preuves contraires.',
    'Désorganisation Conceptuelle : Discours ou pensée désordonnée, confuse ou illogique.',
    'Comportement Hallucinatoire : Perceptions sans stimuli externes, comme entendre des voix.',
    'Excitation : Hyperactivité, agitation ou humeur exaltée.',
    'Grandiosité : Opinion exagérée de soi, idées de grandeur.',
    'Méfiance/Persecution : Croyances d\'être harcelé ou persécuté.',
    'Hostilité : Agressivité verbale ou physique, colère ou irritabilité.',
  ];

  final List<String> _negativeDescriptions = [
    'Affect Emoussé : Absence d\'expression émotionnelle, expression faciale inchangée.',
    'Retrait Emotionnel : Manque d\'intérêt ou d\'engagement dans les interactions sociales.',
    'Mauvais Rapport : Difficulté à établir des relations interpersonnelles.',
    'Retrait Social Passif/Appréciatif : Manque général d\'intérêt ou d\'initiative dans les interactions sociales.',
    'Difficulté de Pensée Abstraite : Difficulté à comprendre des concepts abstraits.',
    'Manque de Spontanéité et de Fluidité de la Conversation : Capacité réduite à démarrer ou à maintenir des conversations.',
    'Pensée Stéréotypée : Modèles de pensée répétitifs ou rigides.',
  ];

  final List<String> _generalDescriptions = [
    'Préoccupation Somatique : Préoccupation pour la santé physique ou les fonctions corporelles.',
    'Anxiété : Inquiétude excessive, peur ou nervosité.',
    'Sentiments de Culpabilité : Sentiments persistants de culpabilité ou de remords.',
    'Tension : Nervosité, incapacité à se détendre.',
    'Maniérismes et Postures : Comportements ou mouvements étranges ou inhabituels.',
    'Dépression : Tristesse persistante, perte d\'intérêt ou désespoir.',
    'Ralentissement Moteur : Mouvements physiques et discours ralentis.',
    'Non Coopérativité : Résistance à l\'autorité ou refus de coopérer.',
    'Contenu de Pensée Inhabituel : Idées étranges ou bizarres.',
    'Désorientation : Confusion sur le temps, le lieu ou la personne.',
    'Mauvaise Attention : Difficulté à maintenir la concentration ou l\'attention.',
    'Manque de Jugement et d\'Insight : Mauvaise compréhension de sa situation ou de sa condition.',
    'Trouble de la Volition : Diminution de la motivation ou de l\'élan.',
    'Mauvais Contrôle des Impulsions : Difficulté à contrôler les impulsions ou les envies.',
    'Préoccupation : Pensées ou comportements obsessionnels.',
    'Evitement Social Actif : Evitement délibéré des interactions sociales.',
  ];

  final List<String> _scoreDescriptions = [
    'Absent',
    'Minime',
    'Léger',
    'Modéré',
    'Moyennement sévère',
    'Sévère',
    'Extrêmement sévère'
  ];

  void _calculateScores() {
    setState(() {
      _positiveTotal = _positiveScores.reduce((a, b) => a + b);
      _negativeTotal = _negativeScores.reduce((a, b) => a + b);
      _generalTotal = _generalScores.reduce((a, b) => a + b);
      _overallTotal = _positiveTotal + _negativeTotal + _generalTotal;
    });
  }

  Widget _buildScoreInput(List<int> scores, int index, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(description),
        DropdownButtonFormField<int>(
          value: scores[index],
          decoration:
              InputDecoration(labelText: 'Évaluation de l\'Item ${index + 1}'),
          items: List.generate(7, (i) => i + 1)
              .map((value) => DropdownMenuItem<int>(
                    value: value,
                    child: Text(
                        '${value.toString()} - ${_scoreDescriptions[value - 1]}'),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              scores[index] = value!;
            });
          },
        ),
        SizedBox(height: 10),
      ],
    );
  }

  String _getScoreMessage(int score, String type) {
    if (score <= 21) {
      return '$type Score: $score\nTout va bien 😊';
    } else if (score <= 35) {
      return '$type Score: $score\nSymptômes légers 🤔';
    } else if (score <= 49) {
      return '$type Score: $score\nSymptômes modérés 😐';
    } else if (score <= 63) {
      return '$type Score: $score\nSymptômes sévères 😟';
    } else {
      return '$type Score: $score\nSymptômes très sévères 😢';
    }
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
          'Calculateur de Score PANSS',
          style: TextStyle(
            color: Color.fromARGB(252, 2, 38, 68),
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                'Le PANSS (Positive and Negative Syndrome Scale) est une échelle utilisée pour mesurer la gravité des symptômes chez les patients atteints de schizophrénie. Elle comprend 30 items répartis en trois sous-échelles : Positive, Négative et Psychopathologie Générale.',
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
              SizedBox(height: 20),
              Text('Échelle Positive',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ...List.generate(
                  7,
                  (index) => _buildScoreInput(
                      _positiveScores, index, _positiveDescriptions[index])),
              SizedBox(height: 20),
              Text('Échelle Négative',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ...List.generate(
                  7,
                  (index) => _buildScoreInput(
                      _negativeScores, index, _negativeDescriptions[index])),
              SizedBox(height: 20),
              Text('Échelle de Psychopathologie Générale',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ...List.generate(
                  16,
                  (index) => _buildScoreInput(
                      _generalScores, index, _generalDescriptions[index])),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _calculateScores,
                child: Text('Calculer les Scores'),
              ),
              SizedBox(height: 20),
              Text(_getScoreMessage(_positiveTotal, 'Score Positif')),
              Text(_getScoreMessage(_negativeTotal, 'Score Négatif')),
              Text(_getScoreMessage(
                  _generalTotal, 'Score de Psychopathologie Générale')),
              Text('Score PANSS Total: $_overallTotal'),
            ],
          ),
        ),
      ),
    );
  }
}
