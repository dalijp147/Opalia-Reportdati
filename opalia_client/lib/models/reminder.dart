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
      time: json['time'] ?? "",
      description: json['description'] ?? "",
    );
  }
  Map<String, dynamic> toMap() {
    return {
      '_id': reminderId,
      'remindertitre': remindertitre,
      'datedebutReminder': datedebutReminder,
      'datefinReminder': datefinReminder,
      'nombrederappelparjour': nombrederappelparjour,
      'color': color,
      'time': time,
      'description': description,
    };
  }

  factory Reminder.fromJson(String source) =>
      Reminder.fromMap(json.decode(source));
  String toJson() => json.encode(toMap());
}
