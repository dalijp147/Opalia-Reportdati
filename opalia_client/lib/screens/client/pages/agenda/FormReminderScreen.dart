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
import '../../../../bloc/reminder/reminder_bloc.dart';
import '../../../../models/categories.dart';
import '../../../../models/mediacment.dart';
import '../../../../services/local/notif_service.dart';
import '../../../../services/local/sharedprefutils.dart';
import '../../widgets/Allappwidgets/constant.dart';

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
    for (int i = 0; i < 6; i++) {
      notes.add(TextEditingController());
    }
  }

  @override
  void initState() {
    super.initState();
    //_fetchCategories();
    _fetchMedicament();
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
  List<Medicament>? allMedicament = [];
  Future<void> _fetchMedicament() async {
    try {
      final medicament = await ApiService.getAllMedicament();
      setState(() {
        allMedicament = medicament;
      });
    } catch (e) {
      print('Failed to fetch medicament: $e');
    }
  }

  Random random = new Random();
  int selectednumber = 0; // Variable to hold the selected category
  List<String> categoryNames = [];
  List<int> nombrederappel = [0, 1, 2, 3, 4, 5, 6];

  List list = [
    'Choisire une categorie de medicament',
    'Choisire un rappel',
  ];
  // List of reminder types
  List<String> reminderTypes = [
    'rappel boire aux',
    'medicament',
    'rendez vous',
    'ecrire un rappel'
  ];
  String selectedReminderType = 'rappel boire aux'; // Default selection
  bool selctedcategorie = false;
  String selString = '';
  String? selectedMedicament;

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
                  'Nom du rappel :',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),

              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: TextFormField(
              //     validator: (value) {
              //       if (value!.isEmpty) {
              //         return "veullez saisire un titre du medicament ";
              //       } else {
              //         return null;
              //       }
              //     },
              //     controller: nameController,
              //     autofocus: false,
              //     decoration: InputDecoration(
              //       enabledBorder: OutlineInputBorder(
              //           borderSide: const BorderSide(
              //             color: Colors.red,
              //           ),
              //           borderRadius: kBorderRadius),
              //       focusedBorder: OutlineInputBorder(
              //         borderSide: const BorderSide(
              //           color: Colors.red,
              //         ),
              //         borderRadius: kBorderRadius,
              //       ),
              //       hintStyle: const TextStyle(
              //         color: Colors.grey,
              //       ),
              //       filled: true,
              //       hintText: "ecrire un titre",
              //       fillColor: Colors.transparent,
              //     ),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  value: selectedReminderType,
                  icon: Icon(Icons.arrow_downward),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.red,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.red,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                  ),
                  items: reminderTypes.map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedReminderType = newValue!;
                      nameController.text = selectedReminderType;
                    });
                  },
                ),
              ),
              if (selectedReminderType == 'medicament')
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonFormField<String>(
                    value: selectedMedicament,
                    icon: Icon(Icons.arrow_downward),
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.red,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.red,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.transparent,
                    ),
                    items: allMedicament?.map((Medicament medicament) {
                      return DropdownMenuItem<String>(
                        value: medicament
                            .mediname, // Assuming Medicament has a `name` property
                        child: Text(medicament.mediname!),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedMedicament = newValue!;
                        nameController.text = selectedMedicament!;
                      });
                    },
                  ),
                ),
              if (selectedReminderType == 'ecrire un rappel')
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "veullez saisire un rappel";
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
                          borderRadius: kBorderRadius),
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                      ),
                      filled: true,
                      hintText: "ecrire rappel",
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
                  'Description :',
                  style: TextStyle(fontWeight: FontWeight.w600),
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
                  'Nombre de rappel :',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButton<int>(
                  iconSize: 30,
                  //style: const TextStyle(color: Colors.blue),
                  underline: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.red,
                    ),
                    height: 2,
                  ),
                  value: selectednumber,
                  isExpanded: true, // Expand dropdown to full width
                  items: nombrederappel.map((name) {
                    return DropdownMenuItem<int>(
                      value: name,
                      child: Text(name.toString()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(
                      () {
                        attemps = int.parse(value.toString()) ?? 1;

                        selectednumber = value!;
                        jobController.text = value
                            .toString(); // Update the text controller with the selected value
                      },
                    );
                  },
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
                      'Pour selectioner une date de debut et de fin appuyer ici:',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
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
                  'Date :',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
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
                  'Heure :',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
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
                      'Couleur :',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
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
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
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
                      style:
                          TextStyle(color: Colors.white, fontSize: kfontSize),
                    ),
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
