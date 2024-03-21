import 'dart:convert';
import 'dart:ffi';

List<Reminder> reminderFromJson(dynamic str) =>
    List<Reminder>.from((str).map((x) => Reminder.fromMap(x)));

class Reminder {
  late String? reminderId;
  late String? remindertitre;
  late DateTime? datedebutReminder;
  late DateTime? datefinReminder;
  late num? nombrederappelparjour;
  Reminder({
    this.reminderId,
    this.remindertitre,
    this.datedebutReminder,
    this.datefinReminder,
    this.nombrederappelparjour,
  });

  factory Reminder.fromMap(Map<String, dynamic> json) {
    return Reminder(
      reminderId: json['_id'],
      remindertitre: json['remindertitre'],
      datedebutReminder: DateTime.parse(json['datedebutReminder'].toString()),
      datefinReminder: DateTime.parse(json['datefinReminder'].toString()),
      nombrederappelparjour: json['nombrederappelparjour'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      '_id': reminderId,
      'remindertitre': remindertitre,
      'datedebutReminder': datedebutReminder,
      'datefinReminder': datefinReminder,
      'nombrederappelparjour': nombrederappelparjour,
    };
  }

  factory Reminder.fromJson(String source) =>
      Reminder.fromMap(json.decode(source));
  String toJson() => json.encode(toMap());
}
