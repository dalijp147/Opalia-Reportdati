List<Medicament> medicamentFromJson(dynamic str) =>
    List<Medicament>.from((str).map((x) => Medicament.fromJson(x)));


class Medicament {
  late String? mediId;
  late String? mediname;
  late String? medidesc;
  late String? mediImage;
  Medicament({
    this.mediId,
    this.mediname,
    this.medidesc,
    this.mediImage,
  });

  Medicament.fromJson(Map<String, dynamic> json) {
    mediId = json['_id'];
    mediname = json['mediname'];
    medidesc = json['medidesc'];
    mediImage = json['mediImage'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = mediId;
    _data['mediname'] = mediname;
    _data['medidesc'] = medidesc;
    _data['mediImage'] = mediImage;
    return _data;
  }
}
