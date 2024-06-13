import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:opalia_client/models/categories.dart';
import 'package:opalia_client/screens/client/pages/agenda/FormReminderScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../services/local/sharedprefutils.dart';
import '../../../../services/remote/apiService.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../../widgets/Allappwidgets/constant.dart';

class MedicalReport extends StatefulWidget {
  const MedicalReport({super.key});

  @override
  State<MedicalReport> createState() => _MedicalReportState();
}

class _MedicalReportState extends State<MedicalReport> {
  late FocusNode poidsFocus;
  late TextEditingController poidsController;
  late FocusNode ageFocus;
  late TextEditingController ageController;

  List<String> _selectedmaladie = [];
  @override
  void initState() {
    super.initState();
    poidsFocus = FocusNode();
    poidsController = TextEditingController();
    ageFocus = FocusNode();
    ageController = TextEditingController();
  }

  @override
  void dispose() {
    poidsFocus.dispose();
    poidsController.dispose();
    ageFocus.dispose();
    ageController.dispose();
    super.dispose();
  }

  List<String> list = [
    'mot de tete',
    'grippe',
    'diabet',
  ];
  final formkey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now().toLocal();

  var myFormat = DateFormat('d-MM-yyyy');

  String myAge = '';

  Future<void> pickDob() async {
    DateTime? _picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (_picked != null) {
      calculateAge(_picked);
    }
  }

  calculateAge(DateTime birth) {
    DateTime now = DateTime.now();
    Duration age = now.difference(birth);
    int years = age.inDays ~/ 365;
    int months = (age.inDays % 365) ~/ 30;
    int days = ((age.inDays % 365) % 30);
    setState(() {
      ageController.text = '$years';
    });
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Form(
          key: formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Text(
                  'Age',
                  style: TextStyle(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "veullez saisire votre age";
                    } else {
                      return null;
                    }
                  },
                  controller: ageController,
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
                    fillColor: Colors.transparent,
                  ),
                  readOnly: true,
                  onTap: () {
                    pickDob();
                  },
                ),
              ),
              //Text("${DateTime.now().year - _selectedDate.year}"),
              SizedBox(
                height: 5,
              ),
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Text(
                  'Poids',
                  style: TextStyle(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty ||
                        RegExp(r'^[0-9]{2-3}+$').hasMatch(value!)) {
                      return "veullez saisire votre poids";
                    } else if (value.length != 2 && value.length != 3) {
                      return "veullez saisire  un poids vali";
                    } else {
                      return null;
                    }
                  },
                  controller: poidsController,
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
                    fillColor: Colors.transparent,
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              MultiSelectDialogField(
                items: list.map((e) => MultiSelectItem(e, e)).toList(),
                listType: MultiSelectListType.CHIP,
                onConfirm: (values) {
                  _selectedmaladie = values;
                },
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
                    print(_selectedmaladie.toString());
                    print(ageController.text);
                    if (formkey.currentState!.validate()) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('Sucés')));
                      await ApiService.postDossierMedicale(
                        poidsController.text,
                        ageController.text,
                        PreferenceUtils.getuserid(),
                        _selectedmaladie.toString(),
                      );
                    }
                    Get.to(FormReminderScreen());
                    // Get.back();
                    // await ApiService.postReminder();
                  },
                  child: Text(
                    "Ajoute dossier medicale",
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
