part of 'score_bloc.dart';

sealed class ScoreState extends Equatable {
  const ScoreState();

  @override
  List<Object> get props => [];
}

final class ScoreInitial extends ScoreState {}

sealed class ScoreActionState extends ScoreState {}

class ScoreAddSuccessState extends ScoreActionState {}

class ScoreAddErrorState extends ScoreActionState {}

final class ScoreFetchLoadingState extends ScoreState {}

final class ScoreFetchErrorState extends ScoreState {}
