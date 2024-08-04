import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;

import '../../services/remote/apiService.dart';
part 'score_event.dart';
part 'score_state.dart';

class ScoreBloc extends Bloc<ScoreEvent, ScoreState> {
  ScoreBloc() : super(ScoreInitial()) {
    on<ScoreAddEvent>(scoreAddEvent);
    on<ScoreAddEventPro>(scoreAddEventPro);
  }
  var client = http.Client();
  FutureOr<void> scoreAddEvent(
      ScoreAddEvent event, Emitter<ScoreState> emit) async {
    bool success = await ApiService.postScore(
      event.userID,
      event.attempts,
      event.points,
      event.gagner,
      event.cadeau,
    );
    if (success) {
      emit(
        ScoreAddSuccessState(),
      );
    } else {
      emit(
        ScoreAddErrorState(),
      );
    }
  }

  FutureOr<void> scoreAddEventPro(
      ScoreAddEventPro event, Emitter<ScoreState> emit) async {
    bool success = await ApiService.postScoreMedecin(
      event.doctorID,
      event.attempts,
      event.points,
      event.gagner,
      event.cadeau,
    );
    if (success) {
      emit(
        ScoreAddSuccessState(),
      );
    } else {
      emit(
        ScoreAddErrorState(),
      );
    }
  }
}
