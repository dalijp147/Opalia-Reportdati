List<Categorie> categorieFromJson(dynamic str) =>
    List<Categorie>.from((str).map((x) => Categorie.fromJson(x)));

class Categorie {
  late String? id;
  late String? categorienom;
  late String? categorieImage;

  Categorie({
    this.id,
    this.categorienom,
    this.categorieImage,
  });

  Categorie.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    categorienom = json['categorienom'];
    categorieImage = json['categorieImage'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['categorienom'] = categorienom;
    _data['categorieImage'] = categorieImage;

    return _data;
  }
}
