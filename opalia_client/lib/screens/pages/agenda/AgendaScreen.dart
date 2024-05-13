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
          ApiService.deleteReminder(PreferenceUtils.getuserid());
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
              Padding(
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
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();

                        String? token = prefs.getString('token');

                        Map<String, dynamic> jsonDecoddd =
                            JwtDecoder.decode(token!);
                        var userId = jsonDecoddd['_id'];
                        print(userId);
                        await ApiService.getDossierUserId(userId)
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
              BlocConsumer<ReminderBloc, ReminderState>(
                bloc: reminderBloc,
                listenWhen: (previous, current) =>
                    current is ReminderActionState,
                buildWhen: (previous, current) =>
                    current is! ReminderActionState,
                listener: (context, state) {},
                builder: (context, state) {
                  switch (state.runtimeType) {
                    case ReminderFetchLoadingState:
                      return Lottie.asset('assets/animation/heartrate.json',
                          height: 210, width: 210);

                    case ReminderFetchSucess:
                      final sucessState = state as ReminderFetchSucess;
                      return Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: sucessState.reminder.length,
                          itemBuilder: (context, index) {
                            final reminder = sucessState.reminder![index];

                            return reminder == null
                                ? Center(
                                    child:
                                        Text('votre liste de rappel est vide'))
                                : Dismissible(
                                    key: Key(reminder.toString()),
                                    onDismissed: (direction) async {
                                      // Remove the item from the data source.
                                      await ApiService.deleteReminder(
                                          reminder.reminderId);
                                      // Then show a snackbar.
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(' dismissed')));
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
                      return Lottie.asset('assets/animation/heartrate.json',
                          height: 210, width: 210);
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
