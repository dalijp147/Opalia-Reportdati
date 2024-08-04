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
  late bool? gagner;
  late String? cadeau;
  Score({
    this.scoreId,
    this.userID,
    this.attempts,
    this.points,
    this.gagner,
    this.cadeau,
  });

  factory Score.fromMap(Map<String, dynamic> json) {
    return Score(
      scoreId: json['_id'] ?? "",
      cadeau: json['cadeau'] ?? "no cadeau",
      userID: json['userid'],
      attempts: json['attempts'],
      points: json['points'] ?? 0,
      gagner: json['gagner'] ?? false,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      '_id': scoreId,
      'userid': userID,
      'attempts': attempts,
      'points': points,
      'gagner': gagner,
      'cadeau': cadeau,
    };
  }

  factory Score.fromJson(String source) => Score.fromMap(json.decode(source));
  String toJson() => json.encode(toMap());
}
