List<CategoriePro> categorieProFromJson(dynamic str) =>
    List<CategoriePro>.from((str).map((x) => CategoriePro.fromJson(x)));

class CategoriePro {
  late String? id;
  late String? categorienompro;
  late String? categorieImagepro;
  CategoriePro({
    this.id,
    this.categorienompro,
    this.categorieImagepro,
  });
  CategoriePro.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    categorienompro = json['categorienompro'];
    categorieImagepro = json['categorieImagepro'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['categorienompro'] = categorienompro;
    _data['categorieImagepro'] = categorieImagepro;

    return _data;
  }
}
