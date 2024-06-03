import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:opalia_client/models/question.dart';
import 'package:http/http.dart' as http;
import '../../services/remote/apiService.dart';
import '../../../config/config.dart';

part 'quiz_event.dart';
part 'quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  QuizBloc() : super(QuizInitial()) {
    on<QuizInitailFetchEvent>(quizInitailfetchEvent);
  }
  var client = http.Client();
  FutureOr<void> quizInitailfetchEvent(
      QuizInitailFetchEvent event, Emitter<QuizState> emit) async {
    emit(QuizFetchLoadingState());
    List<Question> questions = await ApiService.fetchQuestion();
    emit(
      QuizFetchSucess(questions: questions),
    );
  }
}
