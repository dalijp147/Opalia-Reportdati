List<CategorieNews> categorieNewsromJson(dynamic str) =>
    List<CategorieNews>.from((str).map((x) => CategorieNews.fromJson(x)));

class CategorieNews {
  late String? id;
  late String? categorienewsnom;

  CategorieNews({
    this.id,
    this.categorienewsnom,
  });
  CategorieNews.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    categorienewsnom = json['categorienewsnom'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['categorienewsnom'] = categorienewsnom;

    return _data;
  }
}
