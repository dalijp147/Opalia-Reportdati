part of 'quiz_bloc.dart';

sealed class QuizState extends Equatable {
  const QuizState();

  @override
  List<Object> get props => [];
}

final class QuizActionState extends QuizState {}

final class QuizFetchLoadingState extends QuizState {}

final class QuizFetchErrorState extends QuizState {}

final class QuizInitial extends QuizState {}

class QuizFetchSucess extends QuizState {
  final List<Question> questions;
  QuizFetchSucess({required this.questions});
}
