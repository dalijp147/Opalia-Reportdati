import 'package:opalia_client/models/user.dart';

import 'medecin.dart';

List<PoseQuestion> APoseQuestionfromJson(dynamic str) =>
    List<PoseQuestion>.from((str).map((x) => PoseQuestion.fromMap(x)));

class PoseQuestion {
  late String? id;
  late User? patientId;
  late String? question;
  PoseQuestion({
    this.id,
    this.patientId,
    this.question,
  });
  factory PoseQuestion.fromMap(Map<String, dynamic> json) {
    return PoseQuestion(
      id: json['_id'],
      patientId: json['patientId'] != null
          ? User.fromMap(json['patientId'] as Map<String, dynamic>)
          : null,
      question: json['question'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'patientId': patientId,
      'question': question,
    };
  }
}
