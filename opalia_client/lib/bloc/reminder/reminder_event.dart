part of 'reminder_bloc.dart';

@immutable
sealed class ReminderEvent {}

class ReminderInitialFetchEvent extends ReminderEvent {
  final String userID;

  ReminderInitialFetchEvent(this.userID);
}

class ReminderAddEvent extends ReminderEvent {
  final String remindertitre;
  final String nombrederappelparjour;
  final String userID;
  final String debutReminder;
  final String finReminder;
  final String color;
  final List<dynamic> time;
  final String description;
  final String notifid;
  ReminderAddEvent(
    this.remindertitre,
    this.nombrederappelparjour,
    this.userID,
    this.debutReminder,
    this.finReminder,
    this.color,
    this.time,
    this.description,
    this.notifid,
  );
}
