import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../services/local/sharedprefutils.dart';
import '../../../../services/remote/apiService.dart';


import '../../../../models/reminder.dart';
import '../../widgets/Allappwidgets/constant.dart';

class UpdateScreen extends StatefulWidget {
  final Reminder remind;
  const UpdateScreen({super.key, required this.remind});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  late TextEditingController descriptionController;
  late TextEditingController nameController;

  late TextEditingController dateController;
  late TextEditingController dateFinController;
  late TextEditingController timeController;
  final dateFormatter = DateFormat('yMMMMd');
  @override
  void initState() {
    descriptionController =
        TextEditingController(text: widget.remind.description);
    nameController = TextEditingController(text: widget.remind.remindertitre);
    dateController = TextEditingController(
        text:
            dateFormatter.format(widget.remind.datedebutReminder as DateTime));
    dateFinController = TextEditingController(
        text: dateFormatter.format(widget.remind.datefinReminder as DateTime));
    //timeController = TextEditingController(text: widget.remind.time);
    super.initState();
  }

  @override
  void dispose() {
    descriptionController.dispose();
    dateFinController.dispose();

    nameController.dispose();

    dateController.dispose();
    //timeController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  Future<void> _selectedDate() async {
    DateTime? _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (_picked != null) {
      setState(() {
        dateController.text = DateFormat('yyyy-MM-dd').format(_picked);
      });
    }
  }

  TimeOfDay _timeOfDay = TimeOfDay.now();

  Future<void> _showTimePicker() async {
    TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dial,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    setState(() {
      var replacingTime = timeOfDay!
          .replacing(hour: timeOfDay!.hour, minute: timeOfDay!.minute);

      String formattedTime =
          replacingTime.hour.toString() + ":" + replacingTime.minute.toString();
      timeController.text = formattedTime;
      print(formattedTime);
    });
  }

  Future<void> _selectedDatefin() async {
    DateTime? _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (_picked != null) {
      setState(
        () {
          dateFinController.text = DateFormat('yyyy-MM-dd').format(_picked);
        },
      );
    }
  }

  bool select = false;
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
              colors: [Colors.red.shade50, Colors.white],
            ),
          ),
        ),
        centerTitle: true,
        title: Text('Modifier'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Text(
                  'Titre du rappel',
                  style: TextStyle(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "veullez saisire un titre du medicament ";
                    } else {
                      return null;
                    }
                  },
                  controller: nameController,
                  autofocus: false,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.red,
                        ),
                        borderRadius: kBorderRadius),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.red,
                      ),
                      borderRadius: kBorderRadius,
                    ),
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                    ),
                    filled: true,
                    hintText: "ecrire un titre",
                    fillColor: Colors.transparent,
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Text(
                  'Description',
                  style: TextStyle(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "veullez saisire une description";
                    } else {
                      return null;
                    }
                  },
                  controller: descriptionController,
                  autofocus: false,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.red,
                        ),
                        borderRadius: kBorderRadius),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.red,
                        ),
                        borderRadius: kBorderRadius),
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                    ),
                    filled: true,
                    hintText: "ecrire description",
                    fillColor: Colors.transparent,
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text(
                      'pour selectioner une date de debut et de fin',
                      style: TextStyle(),
                    ),
                  ),
                  Switch(
                    value: select,
                    onChanged: (value) {
                      setState(() {
                        select = value;
                      });
                    },
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Text(
                  'Date',
                  style: TextStyle(),
                ),
              ),
              select
                  ? Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "veullez une date de debut";
                              } else {
                                return null;
                              }
                            },
                            controller: dateController,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                ),
                                borderRadius: kBorderRadius,
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                  ),
                                  borderRadius: kBorderRadius),
                              hintStyle: const TextStyle(
                                color: Colors.grey,
                              ),
                              filled: true,
                              fillColor: Colors.transparent,
                              hintText: "date de debut",
                              prefixIcon: const Icon(
                                  Icons.calendar_month_rounded,
                                  color: Colors.red),
                            ),
                            readOnly: true,
                            onTap: () {
                              _selectedDate();
                            },
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "veullez selectionner une date de fin";
                              } else {
                                return null;
                              }
                            },
                            controller: dateFinController,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                  ),
                                  borderRadius: kBorderRadius),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                  ),
                                  borderRadius: kBorderRadius),
                              hintStyle: const TextStyle(
                                color: Colors.grey,
                              ),
                              filled: true,
                              fillColor: Colors.transparent,
                              hintText: "date de fin",
                              prefixIcon: const Icon(
                                  Icons.calendar_month_rounded,
                                  color: Colors.red),
                            ),
                            readOnly: true,
                            onTap: () {
                              _selectedDatefin();
                            },
                          ),
                        ),
                      ],
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "veullez choisire une date";
                          } else {
                            return null;
                          }
                        },
                        controller: dateController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.red,
                            ),
                            borderRadius: kBorderRadius,
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.red,
                              ),
                              borderRadius: kBorderRadius),
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                          ),
                          filled: true,
                          fillColor: Colors.transparent,
                          hintText: "choisire une date",
                          prefixIcon: const Icon(Icons.calendar_month_rounded,
                              color: Colors.red),
                        ),
                        readOnly: true,
                        onTap: () {
                          _selectedDate();
                        },
                      ),
                    ),
              SizedBox(
                height: 5,
              ),
              // Container(
              //   margin: EdgeInsets.only(left: 10),
              //   child: Text(
              //     'heure',
              //     style: TextStyle(),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: TextFormField(
              //     validator: (value) {
              //       if (value!.isEmpty) {
              //         return "veullez selectionner une heure";
              //       } else {
              //         return null;
              //       }
              //     },
              //     controller: timeController,
              //     decoration: InputDecoration(
              //       enabledBorder: OutlineInputBorder(
              //           borderSide: const BorderSide(
              //             color: Colors.red,
              //           ),
              //           borderRadius: kBorderRadius),
              //       focusedBorder: OutlineInputBorder(
              //           borderSide: const BorderSide(
              //             color: Colors.red,
              //           ),
              //           borderRadius: kBorderRadius),
              //       hintStyle: const TextStyle(
              //         color: Colors.grey,
              //       ),
              //       filled: true,
              //       fillColor: Colors.transparent,
              //       hintText: "choisire une heure",
              //       prefixIcon: const Icon(
              //         Icons.watch_later_outlined,
              //         color: Colors.red,
              //       ),
              //     ),
              //     readOnly: true,
              //     onTap: _showTimePicker,
              //   ),
              // ),
              SizedBox(
                height: 5,
              ),
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Couleur',
                      style: TextStyle(),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    onPrimary: Colors.red,
                    primary: Colors.red,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: kBorderRadius,
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      print(PreferenceUtils.getuserid());
                      // select
                      //     ?
                      await ApiService.updateReminder(
                        nameController.text,
                        widget.remind.reminderId,
                        dateController.text,
                        dateFinController.text,
                        //timeController.text,
                        descriptionController.text,
                      );
                      // : await ApiService.updateReminder(
                      //     nameController.text,
                      //     PreferenceUtils.getuserid(),
                      //     dateController.text,
                      //     dateController.text,
                      //     timeController.text,
                      //     descriptionController.text);
                      // DateTime tempDate =
                      //     new DateFormat("hh:mm").parse(timeController.text);
                      // await NotifiactionService.createScheduleNotification(
                      //   title: nameController.text,
                      //   body: descriptionController.text,
                      //   date: tempDate,
                      // );
                      Get.back();
                    }
                  },
                  child: Text(
                    "Modifier reminder",
                    style: TextStyle(color: Colors.white, fontSize: kfontSize),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
