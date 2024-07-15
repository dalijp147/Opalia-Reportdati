import 'dart:convert';

class Farma {
  String? id;
  String? nompatient;
  String? prenompatient;
  String? villepatient;
  int? codepostal;
  DateTime? dateNaissance;
  int? poids;
  int? age;
  int? taille;
  String? sexe;
  String? nouveaune;
  String? produit;
  String? grosses;
  String? arret;
  String? disparition;
  String? reintroduits;
  String? reapparition;
  String? nomdeclarent;
  String? prenomdeclarent;
  String? villedeclarent;
  int? codepostaldeclarent;
  int? telephonedeclarent;
  String? qualite;
  String? medcineclarent;
  String? nomdeclarentmedecoin;
  String? prenomdeclarentmedecoin;
  int? telephonedeclarentmedein;
  String? qualitemedecindeclartent;
  String? villeeffet;
  DateTime? dateeffet;
  int? duree;
  String? description;
  String? gravite;
  DateTime? dategravite;
  String? evolution;

  Farma({
    this.id,
    this.nompatient,
    this.prenompatient,
    this.villepatient,
    this.codepostal,
    this.dateNaissance,
    this.poids,
    this.age,
    this.taille,
    this.sexe,
    this.nouveaune,
    this.produit,
    this.grosses,
    this.arret,
    this.disparition,
    this.reintroduits,
    this.reapparition,
    this.nomdeclarent,
    this.prenomdeclarent,
    this.villedeclarent,
    this.codepostaldeclarent,
    this.telephonedeclarent,
    this.qualite,
    this.medcineclarent,
    this.nomdeclarentmedecoin,
    this.prenomdeclarentmedecoin,
    this.telephonedeclarentmedein,
    this.qualitemedecindeclartent,
    this.villeeffet,
    this.dateeffet,
    this.duree,
    this.description,
    this.gravite,
    this.dategravite,
    this.evolution,
  });

  Farma copyWith({
    String? id,
    String? nompatient,
    String? prenompatient,
    String? villepatient,
    int? codepostal,
    DateTime? dateNaissance,
    int? poids,
    int? age,
    int? taille,
    String? sexe,
    String? nouveaune,
    String? produit,
    String? grosses,
    String? arret,
    String? disparition,
    String? reintroduits,
    String? reapparition,
    String? nomdeclarent,
    String? prenomdeclarent,
    String? villedeclarent,
    int? codepostaldeclarent,
    int? telephonedeclarent,
    String? qualite,
    String? medcineclarent,
    String? nomdeclarentmedecoin,
    String? prenomdeclarentmedecoin,
    int? telephonedeclarentmedein,
    String? qualitemedecindeclartent,
    String? villeeffet,
    DateTime? dateeffet,
    int? duree,
    String? description,
    String? gravite,
    DateTime? dategravite,
    String? evolution,
  }) {
    return Farma(
      id: id ?? this.id,
      nompatient: nompatient ?? this.nompatient,
      prenompatient: prenompatient ?? this.prenompatient,
      villepatient: villepatient ?? this.villepatient,
      codepostal: codepostal ?? this.codepostal,
      dateNaissance: dateNaissance ?? this.dateNaissance,
      poids: poids ?? this.poids,
      age: age ?? this.age,
      taille: taille ?? this.taille,
      sexe: sexe ?? this.sexe,
      nouveaune: nouveaune ?? this.nouveaune,
      produit: produit ?? this.produit,
      grosses: grosses ?? this.grosses,
      arret: arret ?? this.arret,
      disparition: disparition ?? this.disparition,
      reintroduits: reintroduits ?? this.reintroduits,
      reapparition: reapparition ?? this.reapparition,
      nomdeclarent: nomdeclarent ?? this.nomdeclarent,
      prenomdeclarent: prenomdeclarent ?? this.prenomdeclarent,
      villedeclarent: villedeclarent ?? this.villedeclarent,
      codepostaldeclarent: codepostaldeclarent ?? this.codepostaldeclarent,
      telephonedeclarent: telephonedeclarent ?? this.telephonedeclarent,
      qualite: qualite ?? this.qualite,
      medcineclarent: medcineclarent ?? this.medcineclarent,
      nomdeclarentmedecoin: nomdeclarentmedecoin ?? this.nomdeclarentmedecoin,
      prenomdeclarentmedecoin:
          prenomdeclarentmedecoin ?? this.prenomdeclarentmedecoin,
      telephonedeclarentmedein:
          telephonedeclarentmedein ?? this.telephonedeclarentmedein,
      qualitemedecindeclartent:
          qualitemedecindeclartent ?? this.qualitemedecindeclartent,
      villeeffet: villeeffet ?? this.villeeffet,
      dateeffet: dateeffet ?? this.dateeffet,
      duree: duree ?? this.duree,
      description: description ?? this.description,
      gravite: gravite ?? this.gravite,
      dategravite: dategravite ?? this.dategravite,
      evolution: evolution ?? this.evolution,
    );
  }

  factory Farma.fromJson(Map<String, dynamic> json) {
    return Farma(
      id: json['_id'],
      nompatient: json['nompatient'],
      prenompatient: json['prenompatient'],
      villepatient: json['villepatient'],
      codepostal: json['codepostal'],
      dateNaissance: json['dateNaissance'] != null
          ? DateTime.parse(json['dateNaissance'])
          : null,
      poids: json['poids'],
      age: json['age'],
      taille: json['taille'],
      sexe: json['sexe'],
      nouveaune: json['nouveaune'],
      produit: json['produit'],
      grosses: json['grosses'],
      arret: json['arret'],
      disparition: json['disparition'],
      reintroduits: json['reintroduits'],
      reapparition: json['reapparition'],
      nomdeclarent: json['nomdeclarent'],
      prenomdeclarent: json['prenomdeclarent'],
      villedeclarent: json['villedeclarent'],
      codepostaldeclarent: json['codepostaldeclarent'],
      telephonedeclarent: json['telephonedeclarent'],
      qualite: json['qualite'],
      medcineclarent: json['medcineclarent'],
      nomdeclarentmedecoin: json['nomdeclarentmedecoin'],
      prenomdeclarentmedecoin: json['prenomdeclarentmedecoin'],
      telephonedeclarentmedein: json['telephonedeclarentmedein'],
      qualitemedecindeclartent: json['qualitemedecindeclartent'],
      villeeffet: json['villeeffet'],
      dateeffet:
          json['dateeffet'] != null ? DateTime.parse(json['dateeffet']) : null,
      duree: json['duree'],
      description: json['description'],
      gravite: json['gravite'],
      dategravite: json['dategravité'] != null
          ? DateTime.parse(json['dategravité'])
          : null,
      evolution: json['evolution'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'nompatient': nompatient,
      'prenompatient': prenompatient,
      'villepatient': villepatient,
      'codepostal': codepostal,
      'dateNaissance': dateNaissance?.toIso8601String(),
      'poids': poids,
      'age': age,
      'taille': taille,
      'sexe': sexe,
      'nouveaune': nouveaune,
      'produit': produit,
      'grosses': grosses,
      'arret': arret,
      'disparition': disparition,
      'reintroduits': reintroduits,
      'reapparition': reapparition,
      'nomdeclarent': nomdeclarent,
      'prenomdeclarent': prenomdeclarent,
      'villedeclarent': villedeclarent,
      'codepostaldeclarent': codepostaldeclarent,
      'telephonedeclarent': telephonedeclarent,
      'qualite': qualite,
      'medcineclarent': medcineclarent,
      'nomdeclarentmedecoin': nomdeclarentmedecoin,
      'prenomdeclarentmedecoin': prenomdeclarentmedecoin,
      'telephonedeclarentmedein': telephonedeclarentmedein,
      'qualitemedecindeclartent': qualitemedecindeclartent,
      'villeeffet': villeeffet,
      'dateeffet': dateeffet?.toIso8601String(),
      'duree': duree,
      'description': description,
      'gravite': gravite,
      'dategravité': dategravite?.toIso8601String(),
      'evolution': evolution,
    };
  }
}
