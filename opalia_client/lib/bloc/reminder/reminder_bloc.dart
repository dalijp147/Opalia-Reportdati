import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:opalia_client/models/reminder.dart';
import 'package:http/http.dart' as http;
import 'package:opalia_client/services/apiService.dart';

import '../../config/config.dart';
part 'reminder_event.dart';
part 'reminder_state.dart';

class ReminderBloc extends Bloc<ReminderEvent, ReminderState> {
  ReminderBloc() : super(ReminderInitial()) {
    on<ReminderInitialFetchEvent>(reminderInitialFetchEvent);
    on<ReminderAddEvent>(reminderAddEvent);
    // on<ReminderEvent>
  }
  var client = http.Client();
  FutureOr<void> reminderInitialFetchEvent(
      ReminderInitialFetchEvent event, Emitter<ReminderState> emit) async {
    emit(ReminderFetchLoadingState());
    List<Reminder> reminder = await ApiService.fetchReminder(event.userID);
    print('here');
    print(event.userID);
    emit(ReminderFetchSucess(reminder: reminder));
  }

  FutureOr<void> reminderAddEvent(
      ReminderAddEvent event, Emitter<ReminderState> emit) async {
    bool success = await ApiService.postReminder(
      event.remindertitre,
      event.nombrederappelparjour,
      event.userID,
      event.debutReminder,
      event.finReminder,
      event.color,
      event.time,
      event.description,
      event.notifid,
    );
    if (success) {
      emit(
        ReminderAddSuccessState(),
      );
    } else {
      emit(
        ReminderFetchErrorState(),
      );
    }
  }
}
