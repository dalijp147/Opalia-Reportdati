import 'dart:convert';

List<Events> EventsFromJson(dynamic str) =>
    List<Events>.from((str).map((x) => Events.fromMap(x)));

class Events {
  late String? EventId;
  late String? doctorId;
  late String? eventname;
  late DateTime? dateEvent;

  late String? eventdescription;
  late String? eventimage;

  Events({
    this.dateEvent,
    this.doctorId,
    this.eventdescription,
    this.eventimage,
    this.eventname,
    this.EventId,
  });
  factory Events.fromMap(Map<String, dynamic> json) {
    return Events(
      EventId: json['_id'],
      dateEvent: DateTime.parse(json['dateEvent'].toString()),
      doctorId: json['doctorId'],
      eventdescription: json['eventdescription'],
      eventimage: json['eventimage'],
      eventname: json['eventname'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      '_id': EventId,
      'dateEvent': dateEvent,
      'doctorId': doctorId,
      'eventdescription': eventdescription,
      'eventimage': eventimage,
      'eventname': eventname,
    };
  }
}
