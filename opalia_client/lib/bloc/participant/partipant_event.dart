part of 'partipant_bloc.dart';

sealed class PartipantEvent extends Equatable {
  const PartipantEvent();

  @override
  List<Object> get props => [];
}

class PartipantInitialFetchEvent extends PartipantEvent {}
