import 'dart:convert';
import 'dart:ffi';
import 'dart:ui';

List<Score> scoreFromJson(dynamic str) =>
    List<Score>.from((str).map((x) => Score.fromMap(x)));

class Score {
  late String? scoreId;
  late String? userID;
  late int? attempts;
  late int? points;

  Score({
    this.scoreId,
    this.userID,
    this.attempts,
    this.points,
  });

  factory Score.fromMap(Map<String, dynamic> json) {
    return Score(
      scoreId: json['_id'] ?? "",
      userID: json['userId'],
      attempts: json['attempts'],
      points: json['points'] ?? 0,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      '_id': scoreId,
      'userId': userID,
      'attempts': attempts,
      'points': points,
    };
  }

  factory Score.fromJson(String source) => Score.fromMap(json.decode(source));
  String toJson() => json.encode(toMap());
}
