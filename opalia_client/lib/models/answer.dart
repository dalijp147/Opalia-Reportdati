import 'package:opalia_client/models/medecin.dart';

List<Answer> AnswerromJson(dynamic str) =>
    List<Answer>.from((str).map((x) => Answer.fromMap(x)));

class Answer {
  late String? id;
  late String? questionId;
  late Medecin? doctorId;
  late String? answer;
  late DateTime? Publication;
  Answer({
    this.id,
    this.questionId,
    this.doctorId,
    this.answer,
    this.Publication,
  });
  factory Answer.fromMap(Map<String, dynamic> json) {
    return Answer(
      id: json['_id'],
      doctorId: json['doctorId'] != null
          ? Medecin.fromMap(json['doctorId'] as Map<String, dynamic>)
          : null,
      answer: json['answer'],
      questionId: json['questionId'],
      Publication: DateTime.parse(
        json['createdAt'].toString(),
      ),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'doctorId': doctorId,
      'answer': answer,
      'questionId': questionId,
    };
  }
}
