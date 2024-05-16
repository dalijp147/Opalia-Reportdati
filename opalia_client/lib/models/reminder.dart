import 'dart:convert';
import 'dart:ffi';
import 'dart:ui';

List<Reminder> reminderFromJson(dynamic str) =>
    List<Reminder>.from((str).map((x) => Reminder.fromMap(x)));

class Reminder {
  late String? reminderId;
  late String? userID;
  late String? remindertitre;
  late DateTime? datedebutReminder;
  late DateTime? datefinReminder;
  late int? nombrederappelparjour;
  late int? color;
  late String? time;
  late String? description;
  late int? notifiid;
  Reminder({
    this.reminderId,
    this.userID,
    this.remindertitre,
    this.datedebutReminder,
    this.datefinReminder,
    this.nombrederappelparjour,
    this.color,
    this.time,
    this.description,
    this.notifiid,
  });

  factory Reminder.fromMap(Map<String, dynamic> json) {
    return Reminder(
      reminderId: json['_id'] ?? "",
      userID: json['userId'],
      remindertitre: json['remindertitre'],
      datedebutReminder: DateTime.parse(json['datedebutReminder'].toString()),
      datefinReminder: DateTime.parse(json['datefinReminder'].toString()),
      nombrederappelparjour: json['nombrederappelparjour'] ?? 0,
      color: json['color'] ?? 0,
      time: json['time'] ?? "0",
      description: json['description'] ?? "",
      notifiid: json['notifid'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    final _dos = <String, dynamic>{};
    _dos['_id'] = reminderId;
    _dos['userId'] = userID;
    _dos['remindertitre'] = remindertitre;
    _dos['datedebutReminder'] = datedebutReminder;
    _dos['datefinReminder'] = datefinReminder;
    _dos['nombrederappelparjour'] = nombrederappelparjour;
    _dos['color'] = color;
    _dos['time'] = time;
    _dos['description'] = description;
    _dos['notifid'] = notifiid;
    return _dos;
  }
}
