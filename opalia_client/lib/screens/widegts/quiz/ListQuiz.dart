import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:opalia_client/models/question.dart';
import 'package:opalia_client/screens/pages/quiz/QuizScreen.dart';
import 'package:opalia_client/screens/pages/quiz/SpinScreen.dart';

import '../../../bloc/quiz/quiz_bloc.dart';
import '../../../bloc/reminder/reminder_bloc.dart';
import '../../../bloc/score/score_bloc.dart';
import '../../../services/local/sharedprefutils.dart';
import '../../../services/remote/apiService.dart';
import 'RectangularButton.dart';
import 'anwserCard.dart';
import '../../pages/quiz/ScoreScreen.dart';

class ListQuizScreen extends StatefulWidget {
  const ListQuizScreen({super.key});

  @override
  State<ListQuizScreen> createState() => _ListQuizScreenState();
}

class _ListQuizScreenState extends State<ListQuizScreen> {
  late int index;
  final QuizBloc quizbloc = QuizBloc();
  List<Question> ques = [];
  late PageController _controller;
  int questionNumber = 0;
  @override
  void initState() {
    quizbloc.add(QuizInitailFetchEvent());
    _fetchQuestion();
    super.initState();
    _controller = PageController(initialPage: 0);
  }

  void pickAnswer(int value) {
    selectedAnswerIndex = value;
    final question = ques![questionIndex];
    if (selectedAnswerIndex == question.answer) {
      score++;
    }
    setState(() {});
  }

  void goToNextQuestion() {
    if (questionIndex < ques.length - 1) {
      questionIndex++;
      selectedAnswerIndex = null;
    }
    setState(() {});
  }

  Future<void> _fetchQuestion() async {
    try {
      final events = await ApiService.fetchQuestion();
      setState(() {
        ques = events!;
      });
    } catch (e) {
      print('Failed to fetch events: $e');
    }
  }

  int? selectedAnswerIndex;
  int questionIndex = 0;
  int score = 0;
  final ScoreBloc scoreBloc = ScoreBloc();
  @override
  Widget build(BuildContext context) {
    List<Question> questions = [];
    final question = ques[questionIndex];
    bool isLastQuestion = questionIndex == ques.length - 1;
    return Scaffold(
      body: PageView.builder(
        controller: _controller,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: question.question?.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 100,
                ),
                Text(
                  question.question!,
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 32,
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: question.options!.length,
                    itemBuilder: ((context, index) {
                      return GestureDetector(
                        onTap: selectedAnswerIndex == null
                            ? () => pickAnswer(index)
                            : null,
                        child: AnswerCard(
                          currentIndex: index,
                          question: question.options![index],
                          isSelected: selectedAnswerIndex == index,
                          selectedAnswerIndex: selectedAnswerIndex,
                          correctAnswerIndex: question.answer!,
                        ),
                      );
                    }),
                  ),
                ),
                isLastQuestion
                    ? RectangularButton(
                        onPressed: () async {
                          score == 5
                              ? scoreBloc.add(
                                  ScoreAddEvent(
                                    PreferenceUtils.getuserid(),
                                    '1',
                                    score.toString(),
                                    true,
                                  ),
                                )
                              : scoreBloc.add(
                                  ScoreAddEvent(
                                    PreferenceUtils.getuserid(),
                                    '1',
                                    score.toString(),
                                    false,
                                  ),
                                );
                          score == 5
                              ? Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (_) => SpinWheel(
                                      score: score,
                                    ),
                                  ),
                                )
                              : Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (_) => ResultScreen(
                                      score: score,
                                    ),
                                  ),
                                );
                        },
                        label: 'Finish',
                      )
                    : RectangularButton(
                        onPressed: selectedAnswerIndex != null
                            ? goToNextQuestion
                            : null,
                        label: 'Next',
                      ),
              ],
            ),
          );
          ;
        },
      ),
    );
  }
}
