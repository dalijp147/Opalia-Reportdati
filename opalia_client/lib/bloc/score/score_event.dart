part of 'score_bloc.dart';

sealed class ScoreEvent extends Equatable {
  const ScoreEvent();

  @override
  List<Object> get props => [];
}

class ScoreAddEvent extends ScoreEvent {
  final String userID;
  final String attempts;
  final String points;

  final bool gagner;

  ScoreAddEvent(
    this.userID,
    this.attempts,
    this.points,
    this.gagner,
  );
}
