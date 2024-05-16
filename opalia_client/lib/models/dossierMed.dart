List<DossierMed> dossierFromJson(dynamic str) =>
    List<DossierMed>.from((str).map((x) => DossierMed.fromJson(x)));

class DossierMed {
  late String? dosID;
  late String? userID;
  late int? age;
  late int? poids;
  late List<dynamic>? maladies;
  DossierMed({
    this.dosID,
    this.userID,
    this.age,
    this.poids,
    this.maladies,
  });
  factory DossierMed.fromJson(Map<String, dynamic> json) {
    return DossierMed(
      dosID: json['_id'],
      userID: json['userId'],
      age: json['age'],
      poids: json['poids'],
      maladies: json['maladie'],
    );
  }

  Map<String, dynamic> toJson() {
    final _dos = <String, dynamic>{};
    _dos['_id'] = dosID;
    _dos['userId'] = userID;
    _dos['age'] = age;
    _dos['poids'] = poids;
    _dos['maladie'] = maladies;
    return _dos;
  } 
}
