import 'package:opalia_client/models/answer.dart';
import 'package:opalia_client/models/medecin.dart';
import 'package:opalia_client/models/posequestion.dart';
import 'package:opalia_client/models/user.dart';

List<AnswerToQuestion> AnswerToQuestionfromJson(dynamic str) =>
    List<AnswerToQuestion>.from((str).map((x) => AnswerToQuestion.fromMap(x)));

class AnswerToQuestion {
  late String? id;
  late Medecin? doc;
  late User? user;
  late String? comment;
  late String? question;
  AnswerToQuestion({
    this.id,
    this.doc,
    this.user,
    this.comment,
    this.question,
  });
  factory AnswerToQuestion.fromMap(Map<String, dynamic> json) {
    return AnswerToQuestion(
      id: json['_id'] ?? "",
      doc: json['doc'] != null
          ? Medecin.fromMap(json['doc'] as Map<String, dynamic>)
          : null,
      user: json['user'] != null
          ? User.fromMap(json['user'] as Map<String, dynamic>)
          : null,
      comment: json['comment'] ?? "",
      question: json['question'] ?? "",
    );
  }
  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'doc': doc,
      'user': user,
      'comment': comment,
      'question': question,
    };
  }
}
