import 'dart:convert';

List<News> newsFromJson(dynamic str) =>
    List<News>.from((str).map((x) => News.fromMap(x)));

class News {
  late String? newsId;
  late String? newsTitle;
  late String? newsDetail;
  late String? newsImage;
  late String? author;
  late DateTime? newsPublication;
  late String? categorienews;
  News({
    this.newsId,
    this.newsTitle,
    this.newsDetail,
    this.newsImage,
    this.newsPublication,
    this.categorienews,
    this.author,
  });

  factory News.fromMap(Map<String, dynamic> json) {
    return News(
      newsId: json['_id'],
      newsTitle: json['newsTitle'],
      newsDetail: json['newsDetail'],
      newsImage: json['newsImage'],
      author: json['newsAuthor'],
      newsPublication: DateTime.parse(
        json['newsPublication'].toString(),
      ),
      categorienews: json['categorienews'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      '_id': newsId,
      'newsTitle': newsTitle,
      'newsDetail': newsDetail,
      'newsImage': newsImage,
      'newsAuthor': author,
      'newsPublication': newsPublication,
      'categorienews': categorienews,
    };
  }

  String toJson() => json.encode(toMap());
}
