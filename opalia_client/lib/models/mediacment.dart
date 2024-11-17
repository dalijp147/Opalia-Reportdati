import 'dart:convert';

List<Medicament> mediFromJson(dynamic str) =>
    List<Medicament>.from((str).map((x) => Medicament.fromMap(x)));

class Medicament {
  late String? mediId;
  late String? mediname;
  late String? medidesc;
  late String? mediImage;
  late String? forme;
  late String? sousclassemedi;
  late String? dci;
  late String? presentationmedi;
  late String? classeparamedicalemedi;

  // ignore: non_constant_identifier_names
  //late String? classeparamédicalemedi;  late String? présentationmedi;
  Medicament({
    this.mediId,
    this.mediname,
    this.medidesc,
    this.mediImage,
    this.sousclassemedi,
    this.classeparamedicalemedi,
    this.dci,
    this.forme,
    this.presentationmedi,
  });

  factory Medicament.fromMap(Map<String, dynamic> json) {
    return Medicament(
      mediId: json['_id'],
      mediname: json['mediname'],
      medidesc: json['medidesc'],
      mediImage: json['mediImage'],
      sousclassemedi: json['sousclassemedi'] ?? "pas spécifier",
      classeparamedicalemedi: json['classeparamedicalemedi'] ?? "pas spécifier",
      dci: json['dci'] ?? "pas spécifier",
      forme: json['forme'] ?? "pas spécifier",
      presentationmedi: json['presentationmedi'] ?? "pas spécifier",
    );
  }
  Map<String, dynamic> toMap() {
    return {
      '_id': mediId,
      'mediname': mediname,
      'medidesc': medidesc,
      'mediImage': mediImage,
      'sousclassemedi': sousclassemedi,
    };
  }

  String toJson() => json.encode(toMap());
}
