import 'dart:convert';

class News {
  late String? newsId;
  late String? newsTitle;
  late String? newsDetail;
  late String? newsImage;
  late DateTime? newsPublication;
  News({
    this.newsId,
    this.newsTitle,
    this.newsDetail,
    this.newsImage,
    this.newsPublication,
  });

  factory News.fromMap(Map<String, dynamic> json) {
    return News(
        newsId: json['_id'],
        newsTitle: json['newsTitle'],
        newsDetail: json['newsDetail'],
        newsImage: json['newsImage'],
        newsPublication: DateTime.parse(json['newsPublication'].toString()));
  }
  Map<String, dynamic> toMap() {
    return {
      '_id': newsId,
      'newsTitle': newsTitle,
      'newsDetail': newsDetail,
      'newsImage': newsImage,
      'newsPublication': newsPublication,
    };
  }

  String toJson() => json.encode(toMap());
}
