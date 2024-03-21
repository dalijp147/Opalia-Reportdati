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
  late Reminder dataR;
  ReminderBloc() : super(ReminderInitial()) {
    on<ReminderInitialFetchEvent>(reminderInitialFetchEvent);

    on<ReminderEvent>((event, emit) async {
      if (event is ReminderAddEvent) {
        emit(ReminderFetchLoadingState());
        await Future.delayed(const Duration(seconds: 3), () async {
          dataR = await ApiService.fetchDetails(
              event.remindertitre, event.nombrederappelparjour);
          emit(ReminderLoaded(dataR));
        });
      }
    });
    // on<ReminderEvent>
  }
  var client = http.Client();
  FutureOr<void> reminderInitialFetchEvent(
      ReminderInitialFetchEvent event, Emitter<ReminderState> emit) async {
    emit(ReminderFetchLoadingState());
    Map<String, String> requestHandler = {'Content-Type': 'application/json'};
    List<Reminder> reminder = [];
    var url = Uri.http(Config.apiUrl, Config.reminderAPI);
    var response = await client.get(url, headers: requestHandler);
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);

      for (int i = 0; i < data.length; i++) {
        Reminder remind = Reminder.fromMap(data[i] as Map<String, dynamic>);
        reminder.add(remind);
      }
      print(data);
      emit(ReminderFetchSucess(reminder: reminder));
    } else {
      emit(ReminderFetchErrorState());
      throw Exception('Failed to load data reminder');
    }
  }
}
