import 'package:opalia_client/models/medecin.dart';
import 'package:opalia_client/models/particpant.dart';

import 'events.dart';

List<Feeddback> FeedbackFromJson(dynamic str) =>
    List<Feeddback>.from((str).map((x) => Feeddback.fromMap(x)));

class Feeddback {
  late Events? EventId;
  late String? FeedbackId;
  late Medecin? participantId;
  late String? comment;
  late int? etoile;
  Feeddback({
    this.EventId,
    this.participantId,
    this.comment,
    this.etoile,
    this.FeedbackId,
  });
  factory Feeddback.fromMap(Map<String, dynamic> json) {
    // List<Medecin> participantsList = [];
    // if (json['participant'] != null) {
    //   var participantsJson = json['participant'] as List? ?? [];
    //   for (var participant in participantsJson) {
    //     if (participant is Map<String, dynamic>) {
    //       participantsList.add(Medecin.fromMap(participant));
    //     }
    //   }
    // }

    return Feeddback(
      FeedbackId: json['_id'],
      EventId: json['eventId'] != null
          ? Events.fromMap(json['eventId'] as Map<String, dynamic>)
          : null,
      participantId: json['participantId'] != null
          ? Medecin.fromMap(json['participantId'] as Map<String, dynamic>)
          : null,
      comment: json['comment'] ?? 'no comment',
      etoile: json['etoile'] ?? 0,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      '_id': FeedbackId,
      'eventId': EventId,
      'participantId': participantId,
      'comment': comment,
      'etoile': etoile,
    };
  }
}
