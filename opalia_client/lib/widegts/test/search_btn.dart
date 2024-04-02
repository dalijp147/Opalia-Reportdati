import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:opalia_client/bloc/reminder/reminder_bloc.dart';
import 'package:opalia_client/services/apiService.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constant.dart';

class SearchButtonBuilder extends StatefulWidget {
  SearchButtonBuilder(
      {Key? key,
      required this.focusNode,
      required this.name,
      required this.job,
      required this.userID})
      : super(key: key);
  final String userID;
  final FocusNode focusNode;
  final TextEditingController name;
  final TextEditingController job;

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
          reminderBloc.add(
            ReminderAddEvent(widget.name.text, widget.job.text, widget.userID),
          );
          // Get.back();
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
