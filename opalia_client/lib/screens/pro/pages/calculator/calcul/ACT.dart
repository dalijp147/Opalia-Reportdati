import 'package:flutter/material.dart';

class ACTCalculator extends StatelessWidget {
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
          'Calculateur de score ACT',
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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ACTPage(adult: false),
                  ),
                );
              },
              child: Text('Score ACT - Enfant'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ACTPage(adult: true),
                  ),
                );
              },
              child: Text('Score ACT - Adulte'),
            ),
          ],
        ),
      ),
    );
  }
}

class ACTPage extends StatefulWidget {
  final bool adult;

  const ACTPage({Key? key, required this.adult}) : super(key: key);

  @override
  _ACTPageState createState() => _ACTPageState();
}

class _ACTPageState extends State<ACTPage> {
  // Questions for children
  final List<String> childQuestions = [
    "Comment va ton asthme aujourd’hui?",
    "À quel point ton asthme est-il un problème quand tu cours, ou quand tu fais de l’exercice ou du sport?",
    'Est-ce que tu tousses à cause de ton asthme?',
    'Est-ce que tu te réveilles la nuit à cause de ton asthme?',
    'Au cours des 4 dernières semaines, combien de jours votre enfant a-t-il eu des symptômes d’asthme pendant la journée?',
    'Au cours des 4 dernières semaines, combien de jours votre enfant a-t-il eu une respiration sifflante pendant la journée à cause de l’asthme?',
    'Au cours des 4 dernières semaines, combien de jours votre enfant s’est-il réveillé la nuit à cause de l’asthme?',
  ];

  // Questions for adults
  final List<String> adultQuestions = [
    "Au cours des 4 dernières semaines, votre asthme vous a-t-il nui dans vos activités au travail, à l’école/université ou chez vous?",
    "Au cours des 4 dernières semaines, avez-vous été essoufflé(e)?",
    "Au cours des 4 dernières semaines, les symptômes de l’asthme (sifflements dans la poitrine, toux, essoufflement, oppression ou douleur dans la poitrine) vous ont-ils réveillé(e) la nuit ou plus tôt que d’habitude le matin?",
    "Au cours des 4 dernières semaines, avez-vous utilisé votre inhalateur de secours ou pris un traitement par nébulisation (par exemple Salbutamol)?",
    "Comment évalueriez-vous votre asthme au cours des 4 dernières semaines?",
  ];

  // Response options for each question
  final List<List<String>> childOptions = [
    ['Très mal', 'Mal', 'Bien', 'Très bien'],
    [
      'C’est un gros problème. Je ne peux pas faire ce que je veux.',
      'C’est un problème et je n’aime pas ça.',
      'C’est un petit problème, mais c’est correct.',
      'Ce n’est pas un problème.'
    ],
    [
      'Oui, tout le temps.',
      'Oui, la plupart du temps.',
      'Oui, parfois.',
      'Non, jamais.'
    ],
    [
      'Oui, tout le temps.',
      'Oui, la plupart du temps.',
      'Oui, parfois.',
      'Non, jamais.'
    ],
    [
      'Aucun',
      'De 1 à 3 jours',
      'De 4 à 10 jours',
      'De 11 à 18 jours',
      'De 19 à 24 jours',
      'Tous les jours'
    ],
    [
      'Aucun',
      'De 1 à 3 jours',
      'De 4 à 10 jours',
      'De 11 à 18 jours',
      'De 19 à 24 jours',
      'Tous les jours'
    ],
    [
      'Aucun',
      'De 1 à 3 jours',
      'De 4 à 10 jours',
      'De 11 à 18 jours',
      'De 19 à 24 jours',
      'Tous les jours'
    ],
  ];

  final List<List<String>> adultOptions = [
    ['En permanence', 'Très souvent', 'Quelquefois', 'Rarement', 'Jamais'],
    [
      'Plus d’une fois par jour',
      'Une fois par jour',
      '3 à 6 fois par semaine',
      '1 ou 2 fois par semaine',
      'Jamais'
    ],
    [
      '4 nuits ou plus par semaine',
      '2 à 3 nuits par semaine',
      'Une nuit par semaine',
      '1 ou 2 fois en tout',
      'Jamais'
    ],
    [
      '3 fois par jour ou plus',
      '1 ou 2 fois par jour',
      '2 ou 3 fois par semaine',
      '1 fois par semaine ou moins',
      'Jamais'
    ],
    [
      'Pas maîtrisé du tout',
      'Très peu maîtrisé',
      'Un peu maîtrisé',
      'Bien maîtrisé',
      'Totalement maîtrisé'
    ], // Options for the new question
  ];

  // List to store user responses
  late List<int> questionValues;

  @override
  void initState() {
    super.initState();
    questionValues = widget.adult
        ? List.filled(adultQuestions.length, 1)
        : List.filled(childQuestions.length, 1);
  }

  // Function to calculate the score
  double calculateScore() {
    double totalScore = 0;
    for (int value in questionValues) {
      totalScore += value;
    }
    return totalScore;
  }

  // Function to get the ACT score message
  String getACTScoreMessage(double score) {
    if (score <= 15) {
      return 'Votre asthme pourrait être très mal maîtrisé.\nQuel que soit votre score, continuez de parler à votre fournisseur de soins de santé.';
    } else if (score <= 20) {
      return 'ASTHME MAL MAÎTRISÉ\nLes symptômes associés à votre asthme ne sont peut-être pas aussi bien maîtrisés qu’ils pourraient l’être.';
    } else if (score <= 25) {
      return 'ASTHME BIEN MAÎTRISÉ\nVotre asthme semble bien maîtrisé.';
    } else {
      return 'Votre score indique une très bonne maîtrise de l\'asthme.';
    }
  }

  void showACTScore() {
    double actScore = calculateScore();
    String actScoreMessage = getACTScoreMessage(actScore);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Votre score ACT'),
        content: Text(
            'Votre score ACT est de : ${actScore.toStringAsFixed(2)}\n\n$actScoreMessage'),
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

  // Function to get the icon or label for parent questions
  Widget getParentIndicator(int index) {
    return Row(
      children: [
        Icon(
          Icons.info_outline,
          color: Colors.blue,
        ),
        SizedBox(width: 4),
        Text(
          '(pour parents)',
          style: TextStyle(
            fontStyle: FontStyle.italic,
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Score ACT'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.adult
                    ? adultQuestions.length
                    : childQuestions.length,
                itemBuilder: (context, index) {
                  List<String> currentQuestions =
                      widget.adult ? adultQuestions : childQuestions;
                  List<List<String>> currentOptions =
                      widget.adult ? adultOptions : childOptions;

                  // Check if the current question is one of the parent-specific questions
                  bool isParentQuestion = index == 4 ||
                      index == 5 ||
                      index == 6 ||
                      index == 7 ||
                      index == 8; // Add index for the new adult question

                  // Check if it is the special adult question (index 4)
                  bool isSpecialAdultQuestion = widget.adult && index == 4;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Question ${index + 1}: ${currentQuestions[index]}${isParentQuestion ? ' ' : ''}',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isParentQuestion && !isSpecialAdultQuestion
                              ? Colors.blue
                              : Colors.black, // Adjust text color conditionally
                        ),
                      ),
                      if (isParentQuestion)
                        SizedBox(width: 8), // Adjust spacing as needed
                      if (isParentQuestion && !isSpecialAdultQuestion)
                        getParentIndicator(
                            index), // Show icon or label for parent questions
                      DropdownButton<int>(
                        value: questionValues[index],
                        onChanged: (value) {
                          setState(() {
                            questionValues[index] = value!;
                          });
                        },
                        items: List.generate(
                          currentOptions[index].length,
                          (i) => DropdownMenuItem<int>(
                            value: i + 1,
                            child: Text(currentOptions[index][i]),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                    ],
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: showACTScore,
              child: Text('Calculer le score ACT'),
            ),
          ],
        ),
      ),
    );
  }
}
