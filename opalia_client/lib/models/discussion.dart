import 'package:opalia_client/models/events.dart';

import 'medecin.dart';

List<Discussion> DiscussionFromJson(dynamic str) =>
    List<Discussion>.from((str).map((x) => Discussion.fromMap(x)));

class Discussion {
  late String? discussionId;
  late String? subject;
  late Events? eventId;
  late Medecin? author;

  late DateTime? postedat;

  Discussion({
    this.discussionId,
    this.author,
    this.eventId,
    this.subject,
    this.postedat,
  });
  factory Discussion.fromMap(Map<String, dynamic> json) {
    return Discussion(
      discussionId: json['_id'],
      author: json['author'] != null
          ? Medecin.fromMap(json['author'] as Map<String, dynamic>)
          : null,
      eventId: json['eventId'] != null
          ? Events.fromMap(json['eventId'] as Map<String, dynamic>)
          : null,
      subject: json['subject'],
      postedat: DateTime.parse(json['createdAt'].toString()),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      '_id': discussionId,
      'doctorId': author,
      'eventId': eventId,
      'subject': subject,
      'createdAt': postedat,
    };
  }
}

class Like {
  final String participantId; // ObjectId in Mongoose
  final DateTime date;

  Like({
    required this.participantId,
    required this.date,
  });

  factory Like.fromJson(Map<String, dynamic> json) {
    return Like(
      participantId: json['participantId'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'participantId': participantId,
      'date': date.toIso8601String(),
    };
  }
}
