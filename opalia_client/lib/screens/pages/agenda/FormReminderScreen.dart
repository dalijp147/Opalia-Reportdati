import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:opalia_client/config/Utils.dart';
import 'package:opalia_client/services/remote/apiService.dart';
import '../../../bloc/reminder/reminder_bloc.dart';
import '../../../models/categories.dart';
import '../../../services/local/notif_service.dart';
import '../../../services/local/sharedprefutils.dart';
import '../../widegts/Allappwidgets/constant.dart';

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
  List<TextEditingController> notes = [];
  void initializeControllers() {
    // Clear any existing controllers
    notes.clear();
    // Populate the list with new TextEditingController instances
    for (int i = 0; i < 5; i++) {
      notes.add(TextEditingController());
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchCategories();

    initializeControllers();
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
    for (var c in notes) {
      c.dispose();
    }
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

  Future<void> _showTimePicker(int index) async {
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
      //notes[index].text = formattedTime;
      setState(() {
        notes[index].text = formattedTime;
      });
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
  bool select = false;
  final _formKey = GlobalKey<FormState>();
  late final FocusNode focusNode;
  final ReminderBloc reminderBloc = ReminderBloc();
  int attemps = 1;

  Random random = new Random();
  String selectedCategory = ''; // Variable to hold the selected category
  List<String> categoryNames = [];
  Future<void> _fetchCategories() async {
    try {
      var categories = await ApiService.getAllCategory(); // Fetch data

      setState(() {
        categoryNames =
            categories!.map((category) => category.categorienom!).toList();
        if (categoryNames.isNotEmpty) {
          selectedCategory =
              categoryNames.first; // Set initial selected category
        } // Update state
      });
      print('this is a = $categoryNames');
    } catch (e) {
      print('Failed to fetch categories: $e');
    }
  }

  List list = [
    'Choisire une categorie de medicament',
    'Choisire un rappel',
  ];

  bool selctedcategorie = false;
  String selString = '';
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
                  'Type du rappel',
                  style: TextStyle(),
                ),
              ),
              Container(
                width: 1000,
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: list!.length,
                  itemBuilder: (_, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(
                            () {
                              if (index == 0) {
                                selctedcategorie = true;
                                selString = list[index];
                              } else {
                                selctedcategorie = false;
                                selString = list[index];
                              }
                            },
                          );
                        },
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(width: 2, color: Colors.red),
                            color: selString == list[index].toString()
                                ? Colors.red
                                : Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Center(
                              child: Text(
                                list[index],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              selctedcategorie
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButton<String>(
                        value: selectedCategory,
                        isExpanded: true, // Expand dropdown to full width
                        items: categoryNames.map((name) {
                          return DropdownMenuItem<String>(
                            value: name,
                            child: Text(name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value!;
                            nameController.text =
                                value; // Update the text controller with the selected value
                          });
                        },
                      ),
                    )
                  : Padding(
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
              SizedBox(
                height: 5,
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
                  onChanged: (value) {
                    jobController.text = value;
                    setState(() {
                      attemps = int.parse(value) ?? 1;
                    });
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
              SizedBox(
                height: 5,
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
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Text(
                  'heure',
                  style: TextStyle(),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: attemps,
                  itemBuilder: (_, index) {
                    //_controllers!.add(TextEditingController());
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "veullez selectionner une heure";
                          } else {
                            return null;
                          }
                        },
                        // onSaved: (value) {
                        //   notes[index] == value;
                        // },
                        controller: notes[index],
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
                            borderRadius: kBorderRadius,
                          ),
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
                        onTap: () {
                          _showTimePicker(index);
                        },
                      ),
                    );
                  },
                ),
              ),

              ////

              // TextFormField(
              //   validator: (value) {
              //     if (value!.isEmpty) {
              //       return "veullez selectionner une heure";
              //     } else {
              //       return null;
              //     }
              //   },
              //   focusNode: timeFocus,
              //   controller: timeController,
              //   decoration: InputDecoration(
              //     enabledBorder: OutlineInputBorder(
              //         borderSide: const BorderSide(
              //           color: Colors.red,
              //         ),
              //         borderRadius: kBorderRadius),
              //     focusedBorder: OutlineInputBorder(
              //         borderSide: const BorderSide(
              //           color: Colors.red,
              //         ),
              //         borderRadius: kBorderRadius),
              //     hintStyle: const TextStyle(
              //       color: Colors.grey,
              //     ),
              //     filled: true,
              //     fillColor: Colors.transparent,
              //     hintText: "choisire une heure",
              //     prefixIcon: const Icon(
              //       Icons.watch_later_outlined,
              //       color: Colors.red,
              //     ),
              //   ),
              //   readOnly: true,
              //   onTap: _showTimePicker,
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
                    Container(
                      height: 50,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: colors.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(
                                () {
                                  if (selceted != null) {
                                    selceted = colors[index];
                                  } else {
                                    print('veuillez saisire une couleur');
                                  }
                                },
                              );
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
                    List<String> times = [];
                    for (var controller in notes) {
                      times.add(controller.text);
                    }

                    List<String>? notesText =
                        notes?.map((controller) => controller.text).toList();
                    print(notesText);
                    if (_formKey.currentState!.validate()) {
                      int randomNumber = random.nextInt(1000);

                      select
                          // ? reminderBloc.add(
                          //     ReminderAddEvent(
                          //       nameController.text,
                          //       jobController.text,
                          //       PreferenceUtils.getuserid(),
                          //       dateController.text,
                          //       dateFinController.text,
                          //       selceted.toString(),
                          //       notesText!,
                          //       descriptionController.text,
                          //       randomNumber.toString(),
                          //     ),
                          //   )
                          ? reminderBloc.add(
                              ReminderAddEvent(
                                nameController.text,
                                jobController.text,
                                PreferenceUtils.getuserid(),
                                dateController.text,
                                dateFinController.text,
                                selceted.toString(),
                                notesText!,
                                descriptionController.text,
                                randomNumber.toString(),
                              ),
                            )
                          : reminderBloc.add(
                              ReminderAddEvent(
                                nameController.text,
                                jobController.text,
                                PreferenceUtils.getuserid(),
                                dateController.text,
                                dateController.text,
                                selceted.toString(),
                                notesText!,
                                descriptionController.text,
                                randomNumber.toString(),
                              ),
                            );

                      print(notesText.toString());

                      void scheduleNotifications(
                          List<String> timeStrings) async {
                        try {
                          for (int i = 0; i < timeStrings.length; i++) {
                            DateTime tempDate =
                                new DateFormat("hh:mm").parse(timeStrings[i]);

                            DateTime dateday = new DateFormat('yyyy-MM-dd')
                                .parse(dateController.text);
                            select
                                ? await NotifiactionService
                                    .createScheduleNotificationaSchedule(
                                    userid: PreferenceUtils.getuserid(),
                                    badge: randomNumber,
                                    id: randomNumber + i,
                                    title: nameController.text,
                                    body: descriptionController.text,
                                    date: tempDate,
                                  )
                                : await NotifiactionService
                                    .createScheduleNotificationday(
                                    userid: PreferenceUtils.getuserid(),
                                    badge: randomNumber,
                                    id: randomNumber + i,
                                    title: nameController.text,
                                    body: descriptionController.text,
                                    date: tempDate,
                                    day: dateday,
                                  );
                          }
                        } catch (e) {
                          print(e);
                        }
                      }

                      scheduleNotifications(notesText);

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
