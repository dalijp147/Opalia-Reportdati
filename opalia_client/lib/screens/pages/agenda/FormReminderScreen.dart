import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
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

  TimeOfDay _timeOfDay = TimeOfDay(hour: 8, minute: 30);

  Future<void> _showTimePicker() async {
    TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.inputOnly,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (timeOfDay != null) {
      setState(() {
        var replacingTime = timeOfDay!
            .replacing(hour: timeOfDay!.hour, minute: timeOfDay!.minute);

        String formattedTime = replacingTime.hour.toString() +
            ":" +
            replacingTime.minute.toString();
        timeController.text = formattedTime;
        print(formattedTime);
      });
    }
  }

  List colors = [0xffFF0000, 0xffb74094, 0xff006bce, 0xff32F935];
  int selceted = 0;
  bool _validate = false;
  final _formKey = GlobalKey<FormState>();
  late final FocusNode focusNode;
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
              InputField(
                focusNode: nameFocus,
                textController: nameController,
                label: "ecrire rappel",
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
              InputField(
                focusNode: descriptionFocus,
                textController: descriptionController,
                label: "ecrire votre description",
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
              InputField(
                focusNode: jobFocus,
                textController: jobController,
                label: "ecrire nombre de rappel",
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
                  focusNode: dateFocus,
                  controller: dateController,
                  onFieldSubmitted: (value) {
                    FocusScope.of(context).requestFocus(focusNode);
                  },
                  decoration: InputDecoration(
                    errorText: _validate ? "erreur" : null,
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
                child: TextField(
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
                child: TextField(
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
                    prefixIcon: const Icon(Icons.watch_later_outlined,
                        color: Colors.red),
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
                    // Row(
                    //   children: [
                    //     Wrap(
                    //       children: List<Widget>.generate(3, (int index) {
                    //         return Padding(
                    //             padding: const EdgeInsets.only(right: 8.0),
                    //             child: CircleAvatar(
                    //               radius: 14,
                    //               backgroundColor: colors,
                    //             ));
                    //       }),
                    //     )
                    //   ],
                    // ),
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
                          }),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              SearchButtonBuilder(
                desc: descriptionController,
                datedebut: dateController,
                datefin: dateFinController,
                focusNode: searchBtnFocus,
                name: nameController,
                job: jobController,
                color: selceted.toString(),
                time: timeController,
              ),
            ],
          ),
        ),
      ),
    );
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
}
