import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:opalia_client/bloc/reminder/reminder_bloc.dart';
import 'package:opalia_client/services/apiService.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/notif_service.dart';
import '../../services/sharedprefutils.dart';
import 'constant.dart';

class SearchButtonBuilder extends StatefulWidget {
  SearchButtonBuilder({
    Key? key,
    required this.focusNode,
    required this.name,
    required this.job,
    required this.datedebut,
    required this.datefin,
    required this.color,
    required this.time,
    required this.desc,
  }) : super(key: key);

  final TextEditingController datedebut;
  final TextEditingController datefin;
  final FocusNode focusNode;
  final TextEditingController name;
  final TextEditingController job;
  final String color;
  final TextEditingController time;
  final TextEditingController desc;
  @override
  State<SearchButtonBuilder> createState() => _SearchButtonBuilderState();
}

class _SearchButtonBuilderState extends State<SearchButtonBuilder> {
  final ReminderBloc reminderBloc = ReminderBloc();

  @override
  Widget build(BuildContext context) {
    return Padding(
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
          print(PreferenceUtils.getuserid());
          reminderBloc.add(
            ReminderAddEvent(
              widget.name.text,
              widget.job.text,
              PreferenceUtils.getuserid(),
              widget.datedebut.text,
              widget.datefin.text,
              widget.color,
              widget.time.text,
              widget.desc.text,
            ),
          );
          // await NotifiactionService.createScheduleNotification(
          //   title: widget.name.text,
          //   body: widget.desc.text,
          //   // date: ,
          // );
          Get.back();
          // await ApiService.postReminder();
        },
        child: Text(
          "Ajoute reminder",
          style: TextStyle(color: Colors.white, fontSize: kfontSize),
        ),
      ),
    );
  }
}
