import 'package:equatable/equatable.dart';

class Question {
  late String? question;
  late String? answer;
  late List<String>? options;

  Question({
    this.question,
    this.answer,
    this.options,
  });

  factory Question.fromMap(Map<String, dynamic> json) {
    return Question(
      question: json['questions'] ?? 'hello',
      answer: json['answers'] ?? 'hello',
      options: List<String>.from(json['options'] ?? []),
    );
  }
}
