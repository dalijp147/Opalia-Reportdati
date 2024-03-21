import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/reminder.dart';

class AgendaItem extends StatefulWidget {
  final Reminder reminder;
  const AgendaItem({super.key, required this.reminder});

  @override
  State<AgendaItem> createState() => _AgendaItemState();
}

class _AgendaItemState extends State<AgendaItem> {
  var dateFormat = new DateFormat('dd-MM-yyyy hh:mm');
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0, bottom: 10.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              DateFormat('MMMMEEEEd')
                  .format(widget.reminder.datedebutReminder!),
            ),
          ),
        ),
        Container(
          height: 100,
          width: 360,
          decoration: BoxDecoration(
              border: Border.all(
                  width: 1, color: const Color.fromARGB(255, 216, 86, 77)),
              borderRadius: BorderRadius.circular(20),
              color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: [
              const SizedBox(
                width: 20,
              ),
              Text(widget.reminder.nombrederappelparjour.toString()),
              const SizedBox(
                width: 100,
              ),
              Text(widget.reminder.remindertitre!),
            ]),
          ),
        ),
      ],
    );
  }
}
