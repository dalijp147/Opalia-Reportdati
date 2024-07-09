import 'package:opalia_client/models/events.dart';
import 'package:opalia_client/models/medecin.dart';

List<Particpant> ParticpantFromJson(dynamic str) =>
    List<Particpant>.from((str).map((x) => Particpant.fromMap(x)));
List<Particpant> ParticipantFromJson(List<dynamic> data) {
  return data
      .map((json) => Particpant.fromMap(json as Map<String, dynamic>))
      .toList();
}

class Particpant {
  late String? participantId;
  late Medecin? doctorId;
  late Events? eventId;
  late bool? participon;
  late bool? speaker;
  late String? description;
  Particpant({
    this.participantId,
    this.doctorId,
    this.eventId,
    this.participon,
    this.speaker,
    this.description,
  });
  factory Particpant.fromMap(Map<String, dynamic> json) {
    return Particpant(
      participantId: json['_id'],
      doctorId: json['doctorId'] != null
          ? Medecin.fromMap(json['doctorId'] as Map<String, dynamic>)
          : null,
      eventId: json['eventId'] != null
          ? Events.fromMap(json['eventId'] as Map<String, dynamic>)
          : null,
      participon: json['participon'],
      speaker: json['speaker'],
      description: json['description'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      '_id': participantId,
      'doctorId': doctorId,
      'eventId': eventId,
      'participon': participon,
      'description': description,
      'speaker': speaker,
    };
  }
}
