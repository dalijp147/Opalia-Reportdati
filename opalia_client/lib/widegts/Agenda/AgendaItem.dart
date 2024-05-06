import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:opalia_client/services/apiService.dart';

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
            border:
                Border.all(width: 1, color: Color.fromARGB(255, 255, 255, 255)),
            borderRadius: BorderRadius.circular(20),
            color: widget.reminder.color! != null
                ? Color(widget.reminder.color!)
                : Colors.red,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.reminder.remindertitre!,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  Text(
                    widget.reminder.time.toString()!,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ]),
          ),
        ),
      ],
    );
  }
}
