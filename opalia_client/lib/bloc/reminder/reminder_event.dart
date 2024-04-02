part of 'reminder_bloc.dart';

@immutable
sealed class ReminderEvent {}

class ReminderInitialFetchEvent extends ReminderEvent {}

class ReminderAddEvent extends ReminderEvent {
  final String remindertitre;
  final String nombrederappelparjour;
  final String userID;

  ReminderAddEvent(this.remindertitre, this.nombrederappelparjour, this.userID);
}
