import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../models/reminder.dart';

class AgendaItem extends StatefulWidget {
  final Reminder reminder;
  const AgendaItem({super.key, required this.reminder});

  @override
  State<AgendaItem> createState() => _AgendaItemState();
}

class _AgendaItemState extends State<AgendaItem> {
  var dateFormat = new DateFormat('dd-MM-yyyy hh:mm');

  @override
  void initState() {
    // scheduleNotifications(widget.reminder.time!);
    int startSlice = 0;
    int endSlice = widget.reminder.time!.length;

    if (widget.reminder.time!.startsWith(',')) startSlice = 1;
    if (widget.reminder.time!.endsWith(',')) endSlice -= 3;

    widget.reminder.time =
        widget.reminder.time!.substring(startSlice, endSlice);
    super.initState();
  }

  Widget build(BuildContext context) {
    var formatter = DateFormat('EEEE, d MMMM yyyy', 'fr_FR');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          formatter.format(widget.reminder.datedebutReminder!).capitalizeFirst!,
          style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Color(widget.reminder.color!)),
        ),
        Container(
          height: 100,
          width: double.infinity,
          color: widget.reminder.color! != null
              ? Color(widget.reminder.color!)
              : Colors.red,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.reminder.remindertitre!,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  Row(
                    children: [
                      Text(
                        'Heure:',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        widget.reminder.time.toString()!,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
                ]),
          ),
        ),
      ],
    );
  }
}
