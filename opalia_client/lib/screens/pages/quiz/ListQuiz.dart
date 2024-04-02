import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:opalia_client/bloc/quiz/bloc/quiz_bloc.dart';

import '../../../bloc/reminder/reminder_bloc.dart';

class ListQuizScreen extends StatefulWidget {
  const ListQuizScreen({super.key});

  @override
  State<ListQuizScreen> createState() => _ListQuizScreenState();
}

class _ListQuizScreenState extends State<ListQuizScreen> {
  late int index;
  final QuizBloc quizbloc = QuizBloc();

  @override
  void initState() {
    quizbloc.add(QuizInitailFetchEvent());
    super.initState();
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
              return Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: sucessState.questions.length,
                      itemBuilder: (context, index) {
                        final questions = sucessState.questions[index];
                        return Column(
                          children: [Text(questions.question.toString())],
                        );
                      },
                    ),
                  ],
                ),
              );
            default:
              return Lottie.asset('assets/animation/heartrate.json',
                  height: 210, width: 210);
          }
        },
      ),
    );
  }
}
