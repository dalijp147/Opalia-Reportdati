import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:opalia_client/models/categories.dart';
import '../config.dart';

final apiService = Provider((ref) => ApiService());

class ApiService {
  static var client = http.Client();
  static Future<List<Categorie>?> getAllCategory() async {
    Map<String, String> requestHandler = {'Content-Type': 'application/json'};
    var url = Uri.http(Config.apiUrl, Config.categorieAPI);
    var response = await client.get(url, headers: requestHandler);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      return categorieFromJson(data["data"]);
    } else {
      throw Exception('Failed to load data');
    }
  }
}
