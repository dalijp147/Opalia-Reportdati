import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:opalia_client/models/categoriePro.dart';
import 'package:opalia_client/models/mediacment.dart';

import '../../config/config.dart';
import '../../models/events.dart';

class ApiServicePro {
  static var client = http.Client();
  static var urls = Config.apiUrl;

  //Categorie
  static Future<List<CategoriePro>?> getAllCategoryPro() async {
    Map<String, String> requestHandler = {'Content-Type': 'application/json'};
    var url = Uri.http(Config.apiUrl, Config.categorieProAPI + '/');
    print(url);
    var response = await client.get(url, headers: requestHandler);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print('sucess load Categorie Pro');
      return categorieProFromJson(data["data"]);
    } else {
      throw Exception('Failed to load  Categorie Pro');
    }
  }

  ///Medicament
  static Future<List<Medicament>> getMedicamentBycategoriePro(id) async {
    Map<String, String> requestHandler = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    var url = Uri.http(Config.apiUrl, Config.medicaCategorieAPI + 'cat/' + id);
    print(url);
    var response = await client.get(url, headers: requestHandler);
    if (response.statusCode == 200) {
      var dataprod = jsonDecode(response.body);
      print('sucess load medicament');

      return mediFromJson(dataprod["data"]);
    } else {
      throw Exception('Failed to load medicament');
    }
  }

  ///Event
  static Future<List<Events>?> getAllEvents() async {
    Map<String, String> requestHandler = {'Content-Type': 'application/json'};
    var url = Uri.http(Config.apiUrl, Config.eventApi + '/');
    print(url);
    var response = await client.get(url, headers: requestHandler);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print('sucess load Event');
      return EventsFromJson(data["data"]);
    } else {
      throw Exception('Failed to load Event');
    }
  }
}
