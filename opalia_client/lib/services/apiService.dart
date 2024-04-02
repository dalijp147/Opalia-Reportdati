import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:opalia_client/models/categories.dart';
import 'package:opalia_client/models/mediacment.dart';
import 'package:opalia_client/models/question.dart';
import '../config/config.dart';
import '../models/reminder.dart';

final apiService = Provider((ref) => ApiService());

class ApiService {
  static var client = http.Client();
  static var urls = Config.apiUrl;
  static Future<List<Categorie>?> getAllCategory() async {
    Map<String, String> requestHandler = {'Content-Type': 'application/json'};
    var url = Uri.http(urls, Config.categorieAPI);
    var response = await client.get(url, headers: requestHandler);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      return categorieFromJson(data["data"]);
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<List<Medicament>> getMedicamentBycategorie(String name) async {
    Map<String, String> requestHandler = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    var url = Uri.http(Config.apiUrl, Config.medicaCategorieAPI + name);
    print(url);
    var response = await client.get(url, headers: requestHandler);
    if (response.statusCode == 200) {
      var dataprod = jsonDecode(response.body);
      print(response.body);
      return mediFromJson(dataprod["data"]);
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  static Future<Reminder> fetchDetails(
      String remindertitre, num nombrederappelparjour) async {
    var url = Uri.http(Config.apiUrl, Config.reminderAPI + "newReminder");
    final response = await http.post(Uri.parse("$url"), body: {
      "remindertitre": remindertitre,
      "nombrederappelparjour": nombrederappelparjour
    });

    if (response.statusCode == 201) {
      var dataprod = jsonDecode(response.body);
      return Reminder.fromJson(dataprod);
    } else {
      throw Exception('Failed to load API data');
    }
  }

  static Future<bool> postReminder(t, String n, String u) async {
    var url = Uri.http(Config.apiUrl, Config.reminderAPI + '/newReminder');
    var response = await client.post(url,
        body: {"remindertitre": t, "nombrederappelparjour": n, "userId": u});
    print(u);
    print(url);
    print(response.body);
    if (response.statusCode == 200) {
      print("sucess");
      print(response.body);
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> deleteReminder(n) async {
    var url = Uri.http(Config.apiUrl, Config.reminderAPI + '/delete/' + n);
    var response = await client.delete(url);
    print(url);
    if (response.statusCode == 200) {
      print("sucess");
      return true;
    } else {
      return false;
    }
  }

  static Future<List<Question>> fetchQuestion() async {
    Map<String, String> requestHandler = {'Content-Type': 'application/json'};
    List<Question> questions = [];

    var url = Uri.http(Config.apiUrl, Config.quizApi);
    var response = await client.get(url, headers: requestHandler);
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);

      for (int i = 0; i < data.length; i++) {
        Question ques = Question.fromMap(data[i] as Map<String, dynamic>);
        questions.add(ques);
      }
      print(data);
      return questions;
    } else {
      print('eroor');
      throw Exception('Failed to load data reminder');
    }
  }
}
