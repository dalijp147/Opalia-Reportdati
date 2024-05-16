import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:lottie/lottie.dart';
import 'package:opalia_client/models/mediacment.dart';
import 'package:opalia_client/screens/auth/signin.dart';
import 'package:opalia_client/screens/pages/agenda/Detailagenda.dart';
import 'package:opalia_client/screens/pages/agenda/FormReminderScreen.dart';
import 'package:opalia_client/screens/pages/chatbot/GemniScreen.dart';
import 'package:opalia_client/services/apiService.dart';
import 'package:opalia_client/services/sharedprefutils.dart';
import 'package:opalia_client/widegts/Agenda/AgendaItem.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'dart:ui' as ui;

import 'package:iconsax/iconsax.dart';
import '../../../bloc/reminder/reminder_bloc.dart';
import '../../../models/reminder.dart';
import '../../../services/notif_service.dart';
import '../MedicalRepo/MedicalReportForm.dart';
import '../menu/MenuScreen.dart';
import '../menu/SettingsScreen.dart';

class AgendaScreen extends StatefulWidget {
  const AgendaScreen({super.key});

  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  List calender = [
    'Janvier',
    'Février',
    'Mars',
    'Avril',
    'Mail',
    'Juin',
    'Juillet'
  ];
  final ReminderBloc reminderBloc = ReminderBloc();
  DateTime? _selectedDate;
  List<Reminder>? remind = [];
  List<Reminder>? deletedrem = [];
  late List<Appointment?> appointments;
  Future<void> _fetchEvents() async {
    try {
      final events =
          await ApiService.getAllReminder(PreferenceUtils.getuserid());
      setState(() {
        remind = events!;
      });
    } catch (e) {
      print('Failed to fetch events: $e');
    }
  }

  @override
  void initState() {
    reminderBloc.add(ReminderInitialFetchEvent(PreferenceUtils.getuserid()));
    appointments = [];
    _fetchEvents();
    deletereminderafterdate();
    super.initState();
  }

  Future<void> deletereminderafterdate() async {
    try {
      DateTime currentDate = DateTime.now();
      List<Reminder> eventss =
          await ApiService.getAllReminder(PreferenceUtils.getuserid());

      eventss.forEach((reminder) {
        if (reminder.datefinReminder!.isBefore(currentDate)) {
          ApiService.deleteReminder(reminder.reminderId);
        }
      });
    } catch (e) {
      print('Failed to delete reminder: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  stops: [1, 0.1],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.red.shade50, Colors.white])),
        ),
        leading: Text(''),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Get.to(MenuScreen());
              },
              icon: const Icon(
                Icons.person,
                color: Colors.red,
              ))
        ],
        title: const Text(
          'OPALIA RECORDATI',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Icon(
                      Iconsax.calendar_1,
                      color: Colors.red,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      'Calendrier',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontSize: 25),
                    ),
                    const SizedBox(
                      width: 40,
                    ),
                  ],
                ),
              ),
              remind!.isEmpty
                  ? Stack(
                      children: <Widget>[
                        Container(
                          height: 490,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SfCalendar(
                              view: CalendarView.month,
                              monthViewSettings: MonthViewSettings(
                                  appointmentDisplayMode:
                                      MonthAppointmentDisplayMode.appointment),
                              dataSource: _CalendarDataSource(remind),
                              firstDayOfWeek: 1,
                              allowedViews: const [
                                CalendarView.day,
                                CalendarView.timelineWeek,
                                CalendarView.month,
                              ],
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: BackdropFilter(
                            filter: ui.ImageFilter.blur(
                              sigmaX: 5.0,
                              sigmaY: 5.0,
                            ),
                            child: Container(
                              color: Colors.transparent,
                            ),
                          ),
                        )
                      ],
                    )
                  : Container(
                      height: 490,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SfCalendar(
                          view: CalendarView.month,
                          monthViewSettings: MonthViewSettings(
                              appointmentDisplayMode:
                                  MonthAppointmentDisplayMode.appointment),
                          dataSource: _CalendarDataSource(remind),
                          firstDayOfWeek: 1,
                          allowedViews: const [
                            CalendarView.day,
                            CalendarView.timelineWeek,
                            CalendarView.month,
                          ],
                        ),
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Icon(
                      Iconsax.add,
                      color: Colors.red,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      'Tous les Rappels',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontSize: 25),
                    ),
                    const SizedBox(
                      width: 40,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await ApiService.getDossierUserId(
                                PreferenceUtils.getuserid())
                            ? Get.to(FormReminderScreen())
                            : Get.to(MedicalReport());
                      },
                      child: const Text(
                        'Rappel',
                        style: TextStyle(color: Colors.red),
                      ),
                      style: ElevatedButton.styleFrom(
                          side: BorderSide(width: 1, color: Colors.red),
                          backgroundColor: Colors.white),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              remind!.isEmpty
                  ? Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'votre liste de rappel est vide veillez ajouter un rappel',
                              style: TextStyle(
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    )
                  : BlocConsumer<ReminderBloc, ReminderState>(
                      bloc: reminderBloc,
                      listenWhen: (previous, current) =>
                          current is ReminderActionState,
                      buildWhen: (previous, current) =>
                          current is! ReminderActionState,
                      listener: (context, state) {},
                      builder: (context, state) {
                        switch (state.runtimeType) {
                          case ReminderFetchLoadingState:
                            return Lottie.asset(
                                'assets/animation/heartrate.json',
                                height: 210,
                                width: 210);

                          case ReminderFetchSucess:
                            final sucessState = state as ReminderFetchSucess;

                            return Container(
                              height: 300,
                              width: 500,
                              padding: const EdgeInsets.all(8.0),
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: sucessState.reminder.length,
                                itemBuilder: (context, index) {
                                  final reminder = sucessState.reminder![index];
                                  return
                                      //  remind! == null
                                      //     ? Text(
                                      //         'votre liste de rappel est vide',
                                      //         style: TextStyle(color: Colors.red),
                                      //       )
                                      //     :
                                      Dismissible(
                                    key: Key(
                                      reminder.toString(),
                                    ),
                                    onDismissed: (direction) async {
                                      // Remove the item from the data source.
                                      await ApiService.deleteReminder(
                                          reminder.reminderId);
                                      await NotifiactionService.cancelnotif(
                                        id: reminder.notifiid!,
                                      );
                                      // Then show a snackbar.
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(' dismissed'),
                                        ),
                                      );
                                    },
                                    child: GestureDetector(
                                      onTap: () {
                                        Get.to(DetailAgenda(
                                          remind: reminder,
                                        ));
                                      },
                                      child: AgendaItem(
                                        reminder: reminder,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          default:
                            return Lottie.asset(
                                'assets/animation/heartrate.json',
                                height: 210,
                                width: 210);
                        }
                      },
                    ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(ChatBot());
        },
        child: Icon(
          Icons.chat,
        ),
      ),
    );
  }
}

class _CalendarDataSource extends CalendarDataSource {
  _CalendarDataSource(List<Reminder>? events) {
    appointments = events!.map((event) {
      return Appointment(
        startTime: event.datedebutReminder!,
        endTime: event.datefinReminder!,
        subject: event.remindertitre!,
        color: Color(event.color!),
      );
    }).toList();
  }
}
