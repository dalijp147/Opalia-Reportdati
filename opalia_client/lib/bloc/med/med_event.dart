part of 'med_bloc.dart';

@immutable
sealed class MedEvent {}

class MedInitialFetchEvent extends MedEvent {
  final String userID;

  MedInitialFetchEvent(this.userID);
}
