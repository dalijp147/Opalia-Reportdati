import 'dart:convert';

import 'medecin.dart';

List<Events> EventsFromJson(dynamic str) =>
    List<Events>.from((str).map((x) => Events.fromMap(x)));

class Events {
  late String? EventId;
  late String? eventLocation;
  late String? eventname;
  late DateTime? dateEvent;
  late String? eventdescription;
  late String? eventimage;
  late int? nombreparticipant;
  Events({
    this.dateEvent,
    this.eventdescription,
    this.eventimage,
    this.eventname,
    this.EventId,
    this.eventLocation,
    this.nombreparticipant,
  });
  factory Events.fromMap(Map<String, dynamic> json) {
    // List<Medecin> participantsList = [];
    // if (json['participant'] != null) {
    //   var participantsJson = json['participant'] as List? ?? [];
    //   for (var participant in participantsJson) {
    //     if (participant is Map<String, dynamic>) {
    //       participantsList.add(Medecin.fromMap(participant));
    //     }
    //   }
    // }

    return Events(
      EventId: json['_id'],
      dateEvent: DateTime.parse(json['dateEvent'].toString()),
      eventdescription: json['eventdescription'],
      eventimage: json['eventimage'],
      eventname: json['eventname'],
      nombreparticipant: json['nombreparticipant'],
      eventLocation: json['eventLocalisation'] ?? 'unkown',
    );
  }
  Map<String, dynamic> toMap() {
    return {
      '_id': EventId,
      'dateEvent': dateEvent,
      'eventdescription': eventdescription,
      'eventimage': eventimage,
      'eventname': eventname,
      'eventLocalisation': eventLocation,
      'nombreparticipant': nombreparticipant,
      //'participant': partipants!.map((doctor) => doctor.toMap()).toList(),
    };
  }
}
