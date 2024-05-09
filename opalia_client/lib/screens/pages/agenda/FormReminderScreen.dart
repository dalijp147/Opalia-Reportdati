import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:opalia_client/Utils.dart';
import '../../../bloc/reminder/reminder_bloc.dart';
import '../../../services/notif_service.dart';
import '../../../services/sharedprefutils.dart';
import '../../../widegts/test/constant.dart';
import '../../../widegts/test/search_btn.dart';
import '../../../widegts/test/textformfield.dart';

class FormReminderScreen extends StatefulWidget {
  const FormReminderScreen({super.key});

  @override
  State<FormReminderScreen> createState() => _FormReminderScreenState();
}

class _FormReminderScreenState extends State<FormReminderScreen> {
  late FocusNode nameFocus;
  late FocusNode jobFocus;
  late FocusNode searchBtnFocus;
  late FocusNode dateFocus;
  late FocusNode dateFinFocus;
  late FocusNode timeFocus;
  late FocusNode descriptionFocus;
  late TextEditingController descriptionController;
  late TextEditingController nameController;
  late TextEditingController jobController;
  late TextEditingController dateController;
  late TextEditingController dateFinController;
  late TextEditingController timeController;
  @override
  void initState() {
    super.initState();
    descriptionFocus = FocusNode();
    timeFocus = FocusNode();
    dateFinFocus = FocusNode();
    dateFocus = FocusNode();
    nameFocus = FocusNode();
    jobFocus = FocusNode();
    searchBtnFocus = FocusNode();
    descriptionController = TextEditingController();
    nameController = TextEditingController();
    jobController = TextEditingController();
    dateController = TextEditingController();
    dateFinController = TextEditingController();
    timeController = TextEditingController();
  }

  @override
  void dispose() {
    descriptionFocus.dispose();
    timeFocus.dispose();
    dateFocus.dispose();
    nameFocus.dispose();
    jobFocus.dispose();
    descriptionController.dispose();
    dateFinController.dispose();
    searchBtnFocus.dispose();
    nameController.dispose();
    jobController.dispose();
    dateController.dispose();
    timeController.dispose();
    super.dispose();
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

    // setState(
    //   () {
    //     final DateTime deadlineDateTime = DateTime(
    //       timeOfDay!.hour,
    //       timeOfDay.minute,
    //     );
    //     _timeOfDay = timeOfDay;
    //     timeController.text =
    //         DateFormat('hh:mm').format(deadlineDateTime).toString();

    //     print(timeController.text);
    //   },
    // );
    // if (timeOfDay != null) {
    //   setState(() {
    //     final DateTime deadlineDateTime = DateTime(
    //       timeOfDay.hour,
    //       timeOfDay.minute,
    //     );
    //     DateTime date = DateTime.now();

    //     timeController.text = Utils.toTime(date);

    //     print(timeController.text);
    //   });
    // }

    setState(() {
      var replacingTime = timeOfDay!
          .replacing(hour: timeOfDay!.hour, minute: timeOfDay!.minute);

      String formattedTime =
          replacingTime.hour.toString() + ":" + replacingTime.minute.toString();
      timeController.text = formattedTime;
      print(formattedTime);
    });
  }

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

  List colors = [0xffFF0000, 0xffb74094, 0xff006bce, 0xff32F935];
  int selceted = 0;
  bool _validate = false;
  final _formKey = GlobalKey<FormState>();
  late final FocusNode focusNode;
  final ReminderBloc reminderBloc = ReminderBloc();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(' Ajouter un rappel'),
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
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Text(
                  'Nombre de rappel',
                  style: TextStyle(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "veullez saisire le nombre de rappel";
                    } else {
                      return null;
                    }
                  },
                  controller: jobController,
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
                    hintText: "ecrire nombre de rappel",
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
                  'Date',
                  style: TextStyle(),
                ),
              ),
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
                  focusNode: dateFocus,
                  controller: dateController,
                  decoration: InputDecoration(
                    errorText: _validate ? "erreur" : null,
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
                  focusNode: dateFinFocus,
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
                    prefixIcon: const Icon(Icons.calendar_month_rounded,
                        color: Colors.red),
                  ),
                  readOnly: true,
                  onTap: () {
                    _selectedDatefin();
                  },
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Text(
                  'heure',
                  style: TextStyle(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "veullez selectionner une heure";
                    } else {
                      return null;
                    }
                  },
                  focusNode: timeFocus,
                  controller: timeController,
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
                    hintText: "choisire une heure",
                    prefixIcon: const Icon(
                      Icons.watch_later_outlined,
                      color: Colors.red,
                    ),
                  ),
                  readOnly: true,
                  onTap: _showTimePicker,
                ),
              ),
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
                    Container(
                      height: 50,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: colors.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selceted = colors[index];
                              });
                              print(selceted);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: CircleAvatar(
                                radius: 14,
                                backgroundColor: Color(colors[index]),
                                child: selceted == colors[index]
                                    ? Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 16,
                                      )
                                    : Container(),
                              ),
                            ),
                          );
                        },
                      ),
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
                      reminderBloc.add(
                        ReminderAddEvent(
                          nameController.text,
                          jobController.text,
                          PreferenceUtils.getuserid(),
                          dateController.text,
                          dateFinController.text,
                          selceted.toString(),
                          timeController.text,
                          descriptionController.text,
                        ),
                      );
                      DateTime tempDate =
                          new DateFormat("hh:mm").parse(timeController.text);
                      await NotifiactionService.createScheduleNotification(
                          title: nameController.text,
                          body: descriptionController.text,
                          date: tempDate);
                      Get.back();
                    }
                  },
                  child: Text(
                    "Ajoute reminder",
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
