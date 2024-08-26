import 'package:opalia_client/models/medecin.dart';

List<CadeauPro> CadeauProromJson(dynamic str) =>
    List<CadeauPro>.from((str).map((x) => CadeauPro.fromMap(x)));

class CadeauPro {
  late String? id;
  late String? cadeau;

  CadeauPro({
    this.id,
    this.cadeau,
  });
  factory CadeauPro.fromMap(Map<String, dynamic> json) {
    return CadeauPro(
      id: json['_id'],
      cadeau: json['cadeau'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'cadeau': cadeau,
    };
  }
}
