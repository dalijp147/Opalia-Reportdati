import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:opalia_client/models/categories.dart';
import 'package:opalia_client/models/dossierMed.dart';
import 'package:opalia_client/models/mediacment.dart';
import 'package:opalia_client/models/question.dart';
import '../config/config.dart';
import '../models/news.dart';
import '../models/reminder.dart';
import '../models/user.dart';

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
      print('sucess load categorie');
      return categorieFromJson(data["data"]);
    } else {
      throw Exception('Failed to load categorie');
    }
  }

  static Future<List<Reminder>> getAllReminder(String userId) async {
    Map<String, String> requestHandler = {'Content-Type': 'application/json'};
    var url = Uri.http(urls, Config.reminderAPI + '/' + userId);
    //print(url);
    var response = await client.get(url, headers: requestHandler);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print('sucess load reminder');

      return reminderFromJson(data);
    } else {
      throw Exception('Failed to load data reminder');
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
      print('sucess load medicament');

      return mediFromJson(dataprod["data"]);
    } else {
      throw Exception('Failed to load medicament');
    }
  }

  static Future<List<News>> getnewsbycategorie(String categoriname) async {
    Map<String, String> requestHandler = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    var url = Uri.http(Config.apiUrl, Config.newsAPI + '/' + categoriname);
    print(url);
    var response = await client.get(url, headers: requestHandler);
    if (response.statusCode == 200) {
      var dataprod = jsonDecode(response.body);
      print(response.body);
      return newsFromJson(dataprod);
    } else {
      throw Exception('Failed to load data news');
    }
  }

  static Future<bool> postDossierMedicale(
    String poid,
    String age,
    u,
    db,
  ) async {
    var url = Uri.http(Config.apiUrl, Config.dosserMedApi + '/newDoss');
    var response = await client.post(url, body: {
      "poids": poid,
      "age": age,
      "userId": u,
      "maladie": db,
    });
    print(url);
    if (response.statusCode == 200) {
      print("sucess adding dosiermedical");
      print(response.body);
      return true;
    } else {
      print('eroor failed adding dossiermed');
      return false;
    }
  }

  static Future<bool> postReminder(t, String n, u, String db, String df,
      String col, time, String desc, String notifid) async {
    var url = Uri.http(Config.apiUrl, Config.reminderAPI + '/newReminder');
    String timesString = time.join(',');
    //String jsonData = jsonEncode({'time': timesString});
    var response = await client.post(
      url,
      body: {
        "remindertitre": t,
        "nombrederappelparjour": n,
        "userId": u,
        "datedebutReminder": db,
        "datefinReminder": df,
        "color": col,
        "time": timesString,
        "description": desc,
        "notifid": notifid,
      },
    );
    print(u);
    print(url);
    print(response.body);
    if (response.statusCode == 200) {
      print("sucess adding reminder");
      print(response.body);
      return true;
    } else {
      print("failed adding reminder");
      return false;
    }
  }

  static Future<bool> deleteReminder(n) async {
    var url = Uri.http(Config.apiUrl, Config.reminderAPI + '/delete/' + n);
    var response = await client.delete(url);
    print(url);
    if (response.statusCode == 200) {
      print("sucess deleting reminder");
      return true;
    } else {
      print('eroor failed deleting reminder');

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
      return questions;
    } else {
      print('eroor ');
      throw Exception('Failed to load data question');
    }
  }

  static Future<List<User>> getusername(String userid) async {
    Map<String, String> requestHandler = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    var url = Uri.http(Config.apiUrl, Config.userApi);
    print(url);
    var response = await client.get(url, headers: requestHandler);
    if (response.statusCode == 200) {
      var dataprod = jsonDecode(response.body);
      return (dataprod);
    } else {
      throw Exception('Failed to load data  users name');
    }
  }

  static Future<bool> getDossierUserId(String id) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    var url = Uri.http(Config.apiUrl, Config.dosserMedApi + '/' + id);

    var response = await client.get(url, headers: requestHeaders);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data != null) {
        print('This user has a medical dossier.');
        return true;
      } else {
        print('Error: Empty response body.');
        return false;
      }
    } else {
      print('Error: HTTP ${response.statusCode}');
      return false;
    }
  }

  static Future<List<Reminder>> fetchReminder(String userid) async {
    Map<String, String> requestHandler = {'Content-Type': 'application/json'};
    List<Reminder> reminder = [];

    var url = Uri.http(Config.apiUrl, Config.reminderAPI + '/' + userid);
    print(url);
    var response = await client.get(url, headers: requestHandler);
    try {
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);

        for (int i = 0; i < data.length; i++) {
          Reminder remind = Reminder.fromMap(data[i] as Map<String, dynamic>);
          reminder.add(remind);
        }
      }
      return reminder;
    } catch (e) {
      print('eroor  fetch reminder');
      throw ('error');
    }
  }

  static Future<List<DossierMed>> fetchDossserMed(String userid) async {
    Map<String, String> requestHandler = {
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8'
    };
    List<DossierMed> dossier = [];

    var url =
        Uri.http(Config.apiUrl, Config.dosserMedApi + '/byUser/' + userid);
    print(url);
    var response = await client.get(url, headers: requestHandler);
    try {
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);

        for (int i = 0; i < data.length; i++) {
          DossierMed dos = DossierMed.fromJson(data[i] as Map<String, dynamic>);
          dossier.add(dos);
        }
      }
      return dossier;
    } catch (e) {
      print('eroor fetch dossier');
      throw (e);
    }
  }

  static Future<bool> updateReminder(
      t, u, String db, String df, String time, String desc) async {
    var url = Uri.http(Config.apiUrl, Config.reminderAPI + '/update/' + u);
    var response = await client.patch(
      url,
      body: {
        "remindertitre": t,
        "datedebutReminder": db,
        "datefinReminder": df,
        "description": desc,
        "time": time,
      },
    );

    print(url);
    if (response.statusCode == 200) {
      print("sucess updating reminder");
      print(response.body);
      return true;
    } else {
      print("failed updating reminder");

      return false;
    }
  }

  static Future<bool> postScore(String t, String u, String i) async {
    var url = Uri.http(Config.apiUrl, Config.scoreApi);
    var response = await client.post(
      url,
      body: {
        "userid": t,
        "attempts": u,
        "points": i,
      },
    );

    print(url);
    if (response.statusCode == 200) {
      print("sucess adding score");
      return true;
    } else {
      print("failed adding score");

      return false;
    }
  }

  static Future<bool> getResultUserId(String id) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    var url = Uri.http(Config.apiUrl, Config.scoreApi + '/' + id);

    var response = await client.get(url, headers: requestHeaders);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(url);
      if (data != null) {
        print('This user has a score.');
        return true;
      } else {
        print('Error: Empty response body.');
        return false;
      }
    } else {
      print('Error: HTTP ${response.statusCode}');
      return false;
    }
  }
}
