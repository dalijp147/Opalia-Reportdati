import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:opalia_client/screens/client/pages/agenda/updateScreen.dart';

import '../../../../models/reminder.dart';

class DetailAgenda extends StatefulWidget {
  final Reminder remind;
  const DetailAgenda({super.key, required this.remind});

  @override
  State<DetailAgenda> createState() => _DetailAgendaState();
}

class _DetailAgendaState extends State<DetailAgenda> {
  var dateFormat = new DateFormat('dd-MM-yyyy hh:mm');
  list(String time) {
    List<String> formattedTimeList =
        time.split(',').map((time) => time.trim()).toList();
    print(time);
    return time;
  }

  @override
  void initState() {
    list(widget.remind.time!);
    int startSlice = 0;
    int endSlice = widget.remind.time!.length;

    if (widget.remind.time!.startsWith(',')) startSlice = 1;
    if (widget.remind.time!.endsWith(',')) endSlice -= 1;

    widget.remind.time = widget.remind.time!.substring(startSlice, endSlice);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(widget.remind.color!),
        title: Text(
          'Détail Rappel',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                widget.remind.remindertitre!,
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Text(
                    "Date de debut:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    DateFormat('EEE, M/d/y')
                        .format(widget.remind.datedebutReminder!),
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    "Date de fin:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    DateFormat('EEE, M/d/y')
                        .format(widget.remind.datefinReminder!),
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Description :",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.remind.description!,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    "Heure du Rappel :",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    widget.remind.time!,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    "Nombre de Rappel :",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    widget.remind.nombrederappelparjour.toString(),
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(widget.remind.color!),
                    ),
                    onPressed: () {
                      Get.to(UpdateScreen(remind: widget.remind));
                    },
                    child: Text(
                      'Modifier Reminder',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}
