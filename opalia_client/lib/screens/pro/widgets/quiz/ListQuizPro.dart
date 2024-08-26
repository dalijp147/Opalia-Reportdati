import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:opalia_client/models/question.dart';
import 'package:opalia_client/screens/client/pages/quiz/QuizScreen.dart';
import 'package:opalia_client/screens/client/pages/quiz/SpinScreen.dart';
import 'package:opalia_client/screens/pro/pages/quiz/SpinScreenPro.dart';

import '../../../../bloc/quiz/quiz_bloc.dart';
import '../../../../bloc/reminder/reminder_bloc.dart';
import '../../../../bloc/score/score_bloc.dart';
import '../../../../services/local/sharedprefutils.dart';
import '../../../../services/remote/apiService.dart';
import 'RectangularButton.dart';
import 'anwserCardPro.dart';
import '../../pages/quiz/ScoreScreenPro.dart';

class ListQuizScreenPro extends StatefulWidget {
  const ListQuizScreenPro({super.key});

  @override
  State<ListQuizScreenPro> createState() => _ListQuizScreenProState();
}

class _ListQuizScreenProState extends State<ListQuizScreenPro> {
  late PageController _controller;
  List<Question> ques = [];
  int questionIndex = 0;
  int score = 0;
  int? selectedAnswerIndex;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0);
    _fetchQuestion();
  }

  Future<void> _fetchQuestion() async {
    try {
      final events = await ApiService.fetchQuestion();
      setState(() {
        ques = events;
      });
    } catch (e) {
      print('Failed to fetch events: $e');
    }
  }

  void pickAnswer(int value) {
    selectedAnswerIndex = value;
    final question = ques[questionIndex];
    if (selectedAnswerIndex == question.answer) {
      score++;
    }
    setState(() {});
  }

  void goToNextQuestion() {
    if (questionIndex < ques.length - 1) {
      setState(() {
        questionIndex++;
        selectedAnswerIndex = null;
      });
      _controller.nextPage(
          duration: Duration(milliseconds: 2), curve: Curves.ease);
    }
  }

  final ScoreBloc scoreBloc = ScoreBloc();
  @override
  Widget build(BuildContext context) {
    if (ques.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Niveau 1')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final question = ques[questionIndex];
    bool isLastQuestion = questionIndex == ques.length - 1;

    return Scaffold(
      appBar: AppBar(
        title: Text('Niveau 1'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 2,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/images/Grouhome.png'), // Replace with your image path
            fit: BoxFit.cover, // Adjust the image to cover the entire screen
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                children: [
                  Text(
                    'Bonjour' +
                        " " +
                        "Dr" +
                        " " +
                        PreferenceUtils.getuserName(),
                    style: TextStyle(fontWeight: FontWeight.w300, fontSize: 25),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                'Quiz du jour',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
              ),
            ),
            // Progress Bar
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 15,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.grey[300],
                      ),
                      child: LinearProgressIndicator(
                        value: (questionIndex + 1) / ques.length,
                        backgroundColor: Colors.transparent,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                        minHeight: 20,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    '${questionIndex + 1}/${ques.length}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: ques.length,
                itemBuilder: (context, index) {
                  final question = ques[index];
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 50),
                        Text(
                          question.question!,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 32),
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: question.options!.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: selectedAnswerIndex == null
                                    ? () => pickAnswer(index)
                                    : null,
                                child: AnswerCardPro(
                                  currentIndex: index,
                                  question: question.options![index],
                                  isSelected: selectedAnswerIndex == index,
                                  selectedAnswerIndex: selectedAnswerIndex,
                                  correctAnswerIndex: question.answer!,
                                ),
                              );
                            },
                          ),
                        ),
                        isLastQuestion
                            ? RectangularButton(
                                onPressed: () async {
                                  if (score == 5) {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            SpinWheelPro(score: score),
                                      ),
                                    );
                                  } else {
                                    scoreBloc.add(
                                      ScoreAddEventPro(
                                        PreferenceUtils.getuserid(),
                                        '1',
                                        score.toString(),
                                        false,
                                        "pas de cadeau",
                                      ),
                                    );
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            ResultScreenPro(score: score),
                                      ),
                                    );
                                  }
                                },
                                label: 'Terminer',
                              )
                            : RectangularButton(
                                onPressed: selectedAnswerIndex != null
                                    ? goToNextQuestion
                                    : null,
                                label: 'Suivant',
                              ),
                      ],
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
