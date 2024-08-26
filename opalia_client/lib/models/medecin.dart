List<Medecin> MedecinFromJson(dynamic str) =>
    List<Medecin>.from((str).map((x) => Medecin.fromMap(x)));

class Medecin {
  late String? doctorId;
  late String? email;
  late String? password;
  late String? name;
  late String? familyname;
  late int? numeroTel;

  late String? image;
  late String? specialite;
  // late String? description;
  Medecin({
    this.doctorId,
    this.email,
    this.password,
    this.name,
    this.familyname,
    this.numeroTel,
    this.image,
    this.specialite,
    // this.description,
  });

  factory Medecin.fromMap(Map<String, dynamic> json) {
    return Medecin(
      doctorId: json['_id'],
      email: json['email'],
      password: json['password'],
      name: json['username'],
      familyname: json['familyname'],
      numeroTel: json['numeroTel'] ?? 0,
      image: json['image'],
      specialite: json['specialite'],
      //   description: json['description'] ?? 'Pas de description',
    );
  }
  Map<String, dynamic> toMap() {
    return {
      '_id': doctorId,
      'email': email,
      'password': password,
      'familyname': familyname,
      'username': name,
      'image': image,
      'numeroTel': numeroTel,
      'specialite': specialite,
      //  'description': description,
    };
  }
}
