import 'dart:convert';

List<Medicament> mediFromJson(dynamic str) =>
    List<Medicament>.from((str).map((x) => Medicament.fromMap(x)));

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

  factory Medicament.fromMap(Map<String, dynamic> json) {
    return Medicament(
      mediId: json['_id'],
      mediname: json['mediname'],
      medidesc: json['medidesc'],
      mediImage: json['mediImage'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      '_id': mediId,
      'mediname': mediname,
      'medidesc': medidesc,
      'mediImage': mediImage,
    };
  }

  String toJson() => json.encode(toMap());
}
