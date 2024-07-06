import 'dart:convert';

class User {
  late String? userId;
  late String? email;
  late String? password;
  late String? name;
  late String? familyname;
  late String? image;
  User({
    this.userId,
    this.email,
    this.password,
    this.name,
    this.familyname,
    this.image,
  });
  List<User> userFromJson(dynamic str) =>
      List<User>.from((str).map((x) => User.fromMap(x)));
  factory User.fromMap(Map<String, dynamic> json) {
    return User(
      userId: json['_id'],
      name: json['familyname'],
      familyname: json['username'],
      email: json['email'],
      password: json['password'],
      image: json['image'] ?? '',
    );
  }
  Map<String, dynamic> toMap() {
    return {
      '_id': userId,
      'username': name,
      'familyname': familyname,
      'email': email,
      'password': password,
      'image': image,
    };
  }

  String toJson() => json.encode(toMap());
}
