part of 'reminder_bloc.dart';

@immutable
sealed class ReminderEvent {}

class ReminderInitialFetchEvent extends ReminderEvent {}

class ReminderAddEvent extends ReminderEvent {
  final String remindertitre;
  final num nombrederappelparjour;

  ReminderAddEvent(this.remindertitre, this.nombrederappelparjour);
}
