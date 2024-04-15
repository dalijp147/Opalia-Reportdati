import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:opalia_client/bloc/quiz/bloc/quiz_bloc.dart';
import 'package:opalia_client/models/question.dart';

import '../../../bloc/reminder/reminder_bloc.dart';

class ListQuizScreen extends StatefulWidget {
  const ListQuizScreen({super.key});

  @override
  State<ListQuizScreen> createState() => _ListQuizScreenState();
}

class _ListQuizScreenState extends State<ListQuizScreen> {
  late int index;
  final QuizBloc quizbloc = QuizBloc();
  late PageController _controller;
  int questionNumber = 1;
  @override
  void initState() {
    quizbloc.add(QuizInitailFetchEvent());
    super.initState();
    _controller = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<QuizBloc, QuizState>(
        bloc: quizbloc,
        listenWhen: (previous, current) => current is QuizActionState,
        buildWhen: (previous, current) => current is! QuizActionState,
        listener: (context, state) {},
        builder: (context, state) {
          switch (state.runtimeType) {
            case QuizFetchLoadingState:
              return Lottie.asset('assets/animation/heartrate.json',
                  height: 210, width: 210);

            case QuizFetchSucess:
              final sucessState = state as QuizFetchSucess;
              return PageView.builder(
                controller: _controller,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: sucessState.questions.length,
                itemBuilder: (context, index) {
                  final questions = sucessState.questions[index];
                  return buildQuestion(questions, index);
                },
              );
            default:
              return Lottie.asset('assets/animation/heartrate.json',
                  height: 210, width: 210);
          }
        },
      ),
    );
  }

  Widget buildQuestion(Question questions, int index) {
    Color changecolor = Colors.black;
    int coutzr = 0;
    void onClickOptions(int index) {
      setState(() {
        if (questions.answer == questions.options![index]) {
          print(questions.answer == questions.options![index]);
          changecolor = Colors.green;
        } else {
          changecolor = Colors.red;
        }
      });
    }

    void increment() {
      setState(() {
        coutzr++;
      });
      print(coutzr);
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 32,
          ),
          Text(
            questions.question!,
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(
            height: 32,
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: questions.options!.length,
              itemBuilder: ((context, index) {
                return GestureDetector(
                  onTap: () {
                    onClickOptions(index);
                    print(changecolor);
                    increment();
                  },
                  child: Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: changecolor)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            questions.options![index].toString(),
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      )),
                );
              }),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                if (questionNumber <= questions.question!.length) {
                  _controller.nextPage(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInExpo,
                  );
                  setState(() {
                    questionNumber++;
                  });
                } else {}
              },
              child: Text(questionNumber <= questions.question!.length
                  ? "Next Question"
                  : "see the result"))
        ],
      ),
    );
  }
}
