import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:opalia_client/models/mediacment.dart';
import 'package:opalia_client/widegts/Agenda/AgendaItem.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:iconsax/iconsax.dart';

import '../../../bloc/reminder/reminder_bloc.dart';

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

  @override
  void initState() {
    reminderBloc.add(ReminderInitialFetchEvent());
    super.initState();
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
              onPressed: () {},
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
              SizedBox(
                height: 30,
                width: double.infinity,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: calender.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 2, left: 10),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(width: 1, color: Colors.red),
                            color: Colors.white),
                        height: 30,
                        width: 80,
                        child: Center(
                            child: Text(
                          calender[index],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TableCalendar(
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  focusedDay: DateTime.now(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(
                      Iconsax.calendar_1,
                      color: Colors.red,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    const Text(
                      'All Reminders',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontSize: 25),
                    ),
                    const SizedBox(
                      width: 40,
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text(
                        'Reminder',
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
                            return GestureDetector(
                                onTap: () {
                                  // Get.to(DetailProduct(
                                  //   medi: medicament,
                                  // ));
                                },
                                child: AgendaItem(
                                  reminder: reminder,
                                ));
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
    );
  }
}
