part of 'reminder_bloc.dart';

@immutable
sealed class ReminderState {}

sealed class ReminderActionState extends ReminderState {}

final class ReminderInitial extends ReminderState {}

final class ReminderFetchLoadingState extends ReminderState {}

final class ReminderFetchErrorState extends ReminderState {}

class ReminderFetchSucess extends ReminderState {
  final List<Reminder> reminder;
  ReminderFetchSucess({required this.reminder});
}

class ReminderLoaded extends ReminderState {
  final Reminder data;

  ReminderLoaded(this.data);
}
