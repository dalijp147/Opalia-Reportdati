import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:opalia_client/models/categoriePro.dart';
import 'package:opalia_client/models/comment.dart';
import 'package:opalia_client/models/mediacment.dart';

import '../../config/config.dart';
import '../../models/AnswerToQuestion.dart';
import '../../models/answer.dart';
import '../../models/cadeauPro.dart';
import '../../models/categorieNews.dart';
import '../../models/discussion.dart';
import '../../models/events.dart';
import '../../models/farma.dart';
import '../../models/feedback.dart';
import '../../models/particpant.dart';
import '../../models/posequestion.dart';
import '../../models/programme.dart';

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
      print('sucess load medicament categoriePro');

      return mediFromJson(dataprod["data"]);
    } else {
      throw Exception('Failed to load medicament categoriePro');
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
      print(response.body);
      print('sucess load Event');
      return EventsFromJson(data["data"]);
    } else {
      throw Exception('Failed to load Event');
    }
  }

  static Future<bool> deletePastEvent() async {
    var url = Uri.http(Config.apiUrl, Config.eventApi + '/deletePastevent');
    var response = await client.delete(url);
    print(url);
    if (response.statusCode == 200) {
      print("sucess deleting All pass events");
      return true;
    } else {
      print('eroor failed deleting  All pass events');

      return false;
    }
  }

  ///Participant
  static Future<bool> postParticipant(
    bool participe,
    doctor,
    event,
  ) async {
    var url = Uri.http(
      Config.apiUrl,
      Config.ParticpantApi + '/create',
    );
    var response = await client.post(
      url,
      body: {
        "participon": participe.toString(),
        "doctorId": doctor,
        "eventId": event,
      },
    );
    print(url);
    if (response.statusCode == 200) {
      print("sucess adding Participant");
      print(response.body);
      return true;
    } else {
      print('eroor failed adding Participant');
      return false;
    }
  }

  static Future<List<Particpant>> fetchParticipant() async {
    Map<String, String> requestHandler = {
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8'
    };
    List<Particpant> partipants = [];
    var url = Uri.http(Config.apiUrl, Config.ParticpantApi + '/');
    var response = await client.get(url, headers: requestHandler);
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);

      for (int i = 0; i < data.length; i++) {
        Particpant ques = Particpant.fromMap(data[i] as Map<String, dynamic>);
        partipants.add(ques);
      }
      print('Sucess fetch partipant');
      return partipants;
    } else {
      print('eroor ');
      throw Exception('Failed to load data partipants');
    }
  }

  static Future<List<Particpant>> fetchspeakerbyevent(bool b, event) async {
    Map<String, String> requestHandler = {'Content-Type': 'application/json'};
    var url = Uri.http(Config.apiUrl,
        Config.ParticpantApi + '/speaker/' + b.toString() + '/' + event);
    print(url);
    var response = await client.get(url, headers: requestHandler);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      print('sucess load fetchParticipantbyevent');
      return ParticpantFromJson(data);
    } else {
      throw Exception('Failed to load fetchParticipantbyevent');
    }
  }

  static Future<List<Particpant>> fetchparticipantbyevent(bool b, event) async {
    Map<String, String> requestHandler = {'Content-Type': 'application/json'};
    var url = Uri.http(Config.apiUrl,
        Config.ParticpantApi + '/participon/' + b.toString() + '/' + event);
    print(url);
    var response = await client.get(url, headers: requestHandler);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      print('sucess load fetchParticipantbyevent');
      return ParticpantFromJson(data);
    } else {
      throw Exception('Failed to load fetchParticipantbyevent');
    }
  }

  static Future<Particpant> fetchparticipantbyId(id) async {
    Map<String, String> requestHandler = {'Content-Type': 'application/json'};
    var url =
        Uri.http(Config.apiUrl, Config.ParticpantApi + '/participant/' + id);
    print(url);
    try {
      final response = await client.get(url, headers: requestHandler);
      print('API request URL: $url'); // Debugging print
      print('API response status: ${response.statusCode}'); // Debugging print
      print(
          'API response body for participant ID $id: ${response.body}'); // Debugging print

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Decoded JSON for participant ID $id: $data'); // Debugging print

        return Particpant.fromMap(data);
      } else {
        throw Exception('Failed to load participant with ID $id');
      }
    } catch (e) {
      print('Error during fetchParticipantById: $e'); // Debugging print
      throw e;
    }
  }

  static Future<List<Particpant>> fetchParticipantsByIds(
      List<String> ids) async {
    List<Particpant> participants = [];
    for (var id in ids) {
      try {
        final participant = await fetchparticipantbyId(id);
        participants.add(participant);
      } catch (e) {
        print('Error fetching participant with ID $id: $e');
      }
    }
    return participants;
  }

  static Future<bool> deleteParticipant(n) async {
    var url = Uri.http(Config.apiUrl, Config.ParticpantApi + '/delete/' + n);
    var response = await client.delete(url);
    print(url);
    if (response.statusCode == 200) {
      print("sucess deleting participant");
      return true;
    } else {
      print('eroor failed deleting participant');

      return false;
    }
  }

  static Future<bool> deleteParticipantbydoctorid(n) async {
    var url = Uri.http(
        Config.apiUrl, Config.ParticpantApi + '/deletebydoctorid/' + n);
    var response = await client.delete(url);
    print(url);
    if (response.statusCode == 200) {
      print("sucess deleting participant");
      return true;
    } else {
      print('eroor failed deleting participant');

      return false;
    }
  }

  static Future<bool> getParticipanttExist(String id) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    var url = Uri.http(Config.apiUrl, Config.ParticpantApi + '/byid/' + id);

    var response = await client.get(url, headers: requestHeaders);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(url);
      if (data != null) {
        print('This user has a Participant.');
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

  static Future<bool> isParticipant(String userId, String eventId) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    var url = Uri.http(Config.apiUrl,
        Config.ParticpantApi + '/byiddoc/' + userId + '/' + eventId);

    var response = await http.get(url, headers: requestHeaders);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print('API Response Data: $data');
      if (data != null) {
        print('This user is a Participant.');
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

  static Future<List<Particpant>> fetchparticipantbyeventSPEAKERS(docId) async {
    Map<String, String> requestHandler = {'Content-Type': 'application/json'};
    var url = Uri.http(
        Config.apiUrl, Config.ParticpantApi + '/' + docId + '/speaker');
    print(url);
    var response = await client.get(url, headers: requestHandler);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      print('sucess load fetchParticipantbyevent');
      return ParticpantFromJson(data);
    } else {
      throw Exception('Failed to load fetchParticipantbyevent');
    }
  }

  ///Programme
  static Future<List<Programme>?> getAllProgramme(String event) async {
    Map<String, String> requestHandler = {'Content-Type': 'application/json'};
    var url = Uri.http(Config.apiUrl, Config.ProgramApi + '/sort/' + event);
    print(url);
    var response = await client.get(url, headers: requestHandler);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(response.body);
      print('Success load Programme');
      return programmeFromJson(data);
    } else {
      throw Exception('Failed to load Programme');
    }
  }

  ////Discussion
  static Future<List<Discussion>?> getAllDiscussion() async {
    Map<String, String> requestHandler = {'Content-Type': 'application/json'};
    var url = Uri.http(Config.apiUrl, Config.DiscussionApi);
    print(url);
    var response = await client.get(url, headers: requestHandler);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(response.body);
      print('Success load Discussion');
      return DiscussionFromJson(data);
    } else {
      throw Exception('Failed to load Discussion');
    }
  }

  static Future<bool> postDiscussion(
    String subject,
    doctor,
    event,
  ) async {
    var url = Uri.http(
      Config.apiUrl,
      Config.DiscussionApi + '/create',
    );
    var response = await client.post(
      url,
      body: {
        "subject": subject,
        "author": doctor,
        "eventId": event,
      },
    );
    print(url);
    if (response.statusCode == 200) {
      print("sucess adding Discussion");
      print(response.body);
      return true;
    } else {
      print('eroor failed adding Discussion');
      return false;
    }
  }

  static Future<List<Discussion>?> getAllDiscussionbyEvent(
      String eventId) async {
    Map<String, String> requestHandler = {'Content-Type': 'application/json'};
    var url =
        Uri.http(Config.apiUrl, Config.DiscussionApi + '/byeventID/' + eventId);
    print(url);
    var response = await client.get(url, headers: requestHandler);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(response.body);
      print('Success load Discussion');
      return DiscussionFromJson(data);
    } else {
      throw Exception('Failed to load Discussion');
    }
  }

  static Future<bool> deleteDiscussion(n) async {
    var url = Uri.http(Config.apiUrl, Config.DiscussionApi + '/delete/' + n);
    var response = await client.delete(url);
    print(url);
    if (response.statusCode == 200) {
      print("sucess deleting Discussion");
      return true;
    } else {
      print('eroor failed deleting Discussion');

      return false;
    }
  }

  static Future<dynamic> likePost(String postId, String userId) async {
    var url = Uri.http(Config.apiUrl, Config.DiscussionApi + '/like');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'postId': postId, 'userId': userId}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to like post');
    }
  }

  // Function to unlike a discussion
  static Future<dynamic> unlikePost(String postId, String userId) async {
    var url = Uri.http(Config.apiUrl, Config.DiscussionApi + '/unlike');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'postId': postId, 'userId': userId}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to unlike post');
    }
  }

  ///Comment
  static Future<List<Comment>?> getAllCommentsbyDiscussion(discussionId) async {
    Map<String, String> requestHandler = {'Content-Type': 'application/json'};
    var url = Uri.http(
        Config.apiUrl, Config.CommentApi + '/getbypost/' + discussionId);
    print(url);
    var response = await client.get(url, headers: requestHandler);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      print('Success load Comment');
      return CommentFromJson(data);
    } else {
      throw Exception('Failed to load Comment');
    }
  }

  static Future<bool> postComment(
    String subject,
    doctor,
    discussion,
  ) async {
    var url = Uri.http(
      Config.apiUrl,
      Config.CommentApi + '/create',
    );
    var response = await client.post(
      url,
      body: {
        "comment": subject,
        "doc": doctor,
        "post": discussion,
      },
    );
    print(url);
    if (response.statusCode == 200) {
      print("sucess adding Comment");
      print(response.body);
      return true;
    } else {
      print('eroor failed adding Comment');
      return false;
    }
  }

  static Future<bool> deleteComment(n) async {
    var url = Uri.http(Config.apiUrl, Config.CommentApi + '/delete/' + n);
    var response = await client.delete(url);
    print(url);
    if (response.statusCode == 200) {
      print("sucess deleting Comment");
      return true;
    } else {
      print('eroor failed deleting Comment');

      return false;
    }
  }
  ////FArma

  static Future<bool> postFarma(Farma farma) async {
    var url = Uri.http(Config.apiUrl, Config.farmaApi + '/farma');
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(farma.toJson()),
    );

    if (response.statusCode == 201) {
      print("Success adding Farma");
      print(response.body);
      return true;
    } else {
      print('Error failed adding Farma');
      print(response.body);
      return false;
    }
  }

  static Future<bool> putFarma(String id, Farma farma) async {
    var url = Uri.http(Config.apiUrl, Config.farmaApi + '/farma/' + id);
    var response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(farma.toJson()),
    );

    if (response.statusCode == 200) {
      print("Success updating Farma");
      print(response.body);
      return true;
    } else {
      print('Error failed updating Farma');
      print(response.body);
      return false;
    }
  }

  ////Feedback
  static Future<bool> postFeedback(
    String subject,
    String etoile,
    participant,
    event,
  ) async {
    var url = Uri.http(
      Config.apiUrl,
      Config.FeedbackApi + '/',
    );
    var response = await client.post(
      url,
      body: {
        "eventId": event,
        "participantId": participant,
        "comment": subject,
        "etoile": etoile,
      },
    );
    print(url);
    if (response.statusCode == 200) {
      print("sucess adding Feedback");
      print(response.body);
      return true;
    } else {
      print(Error().toString());
      print('eroor failed adding Feedback');
      return false;
    }
  }

  static Future<bool> doesFeedbackExist(
      String participantId, String eventId) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    var url = Uri.http(
        Config.apiUrl, '${Config.FeedbackApi}/$eventId/$participantId');

    try {
      var response = await client.get(url, headers: requestHeaders);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(url);
        if (data != null && data.isNotEmpty) {
          print('This Feedback has a score.');
          return true;
        } else {
          print('No feedback found.');
          return false;
        }
      } else {
        print('Error: HTTP ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  // ignore: non_constant_identifier_names
  static Future<List<Feeddback>?> getFeeds(EventId) async {
    Map<String, String> requestHandler = {'Content-Type': 'application/json'};
    var url = Uri.http(Config.apiUrl, Config.FeedbackApi + '/' + EventId);
    print(url);
    var response = await client.get(url, headers: requestHandler);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      print('Success load Feeddback');
      return FeedbackFromJson(data);
    } else {
      throw Exception('Failed to load Feeddback');
    }
  }

  ///CategorieNews

  static Future<List<CategorieNews>?> getAllCategoryNews() async {
    Map<String, String> requestHandler = {'Content-Type': 'application/json'};
    var url = Uri.http(Config.apiUrl, Config.categorieNewsAPI + '/');
    print(url);
    var response = await client.get(url, headers: requestHandler);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print('sucess load categorie');
      return categorieNewsromJson(data);
    } else {
      throw Exception('Failed to load categorie News');
    }
  }

  ///question
  static Future<List<PoseQuestion>?> getAllQuestions() async {
    Map<String, String> requestHandler = {'Content-Type': 'application/json'};
    var url = Uri.http(Config.apiUrl, Config.questionAPI + '/get-questions');
    print(url);
    var response = await client.get(url, headers: requestHandler);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print('sucess loadPoseQuestion');
      return APoseQuestionfromJson(data);
    } else {
      throw Exception('Failed to PoseQuestion');
    }
  }

  static Future<bool> postQuestion(String patientId, String question) async {
    Map<String, String> requestHandler = {'Content-Type': 'application/json'};
    var url = Uri.http(Config.apiUrl, Config.questionAPI + '/post-question');
    print(url);
    var response = await client.post(
      url,
      headers: requestHandler,
      body: json.encode({
        'patientId': patientId,
        'question': question,
      }),
    );

    if (response.statusCode == 201) {
      print('Successfully posted question');
      return true;
    } else {
      print('Failed to post question');
      return false;
    }
  }

  static Future<bool> deleteQuestion(String id) async {
    var url = Uri.http(Config.apiUrl, Config.questionAPI + '/delete/' + id);
    var response = await client.delete(url);
    print(url);
    if (response.statusCode == 200) {
      print("sucess deleting question");
      return true;
    } else {
      print('eroor failed deleting  question');

      return false;
    }
  }

  ///Answer
  static Future<List<Answer>?> getAllAnswerss(String questionId) async {
    Map<String, String> requestHandler = {'Content-Type': 'application/json'};
    var url = Uri.http(
        Config.apiUrl, Config.anwserAPI + '/get-answers/' + questionId);
    print(url);
    var response = await client.get(url, headers: requestHandler);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print('sucess load Answer');
      return AnswerromJson(data);
    } else {
      throw Exception('Failed to load Answer');
    }
  }

  static Future<bool> postAnswer(
      String doctorId, String answer, String questionId) async {
    Map<String, String> requestHandler = {'Content-Type': 'application/json'};
    var url = Uri.http(Config.apiUrl, Config.anwserAPI + '/post-answer');
    print(url);
    var response = await client.post(
      url,
      headers: requestHandler,
      body: json.encode(
        {
          'doctorId': doctorId,
          'answer': answer,
          'questionId': questionId,
        },
      ),
    );

    if (response.statusCode == 201) {
      print('Successfully posted Answer');
      return true;
    } else {
      print('Failed to post Answer');
      return false;
    }
  }

  static Future<bool> deleteAnswer(String id) async {
    var url = Uri.http(Config.apiUrl, Config.anwserAPI + '/delete/' + id);
    var response = await client.delete(url);
    print(url);
    if (response.statusCode == 200) {
      print("sucess deleting question");
      return true;
    } else {
      print('eroor failed deleting  question');

      return false;
    }
  }

  ///AnswerToQuestion
  static Future<List<AnswerToQuestion>?> getAllAnswerbyDoctor(id) async {
    Map<String, String> requestHandler = {'Content-Type': 'application/json'};
    var url = Uri.http(
        Config.apiUrl, Config.AnswerToQuestionApi + '/getbypost/' + id);
    print(url);
    var response = await client.get(url, headers: requestHandler);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      print('Success load AnswerToQuestion');
      return AnswerToQuestionfromJson(data);
    } else {
      throw Exception('Failed to load AnswerToQuestion');
    }
  }

  static Future<bool> postAnswerToQuestionDoc(
    String subject,
    doctor,
    discussion,
  ) async {
    var url = Uri.http(
      Config.apiUrl,
      Config.AnswerToQuestionApi + '/createDocReponse',
    );
    var response = await client.post(
      url,
      body: {
        "comment": subject,
        "doc": doctor,
        "question": discussion,
      },
    );
    print(url);
    if (response.statusCode == 200) {
      print("sucess adding createDocReponse");
      print(response.body);
      return true;
    } else {
      print('eroor failed adding createDocReponse');
      return false;
    }
  }

  static Future<bool> postAnswerToQuestionPateint(
    String subject,
    doctor,
    discussion,
  ) async {
    var url = Uri.http(
      Config.apiUrl,
      Config.AnswerToQuestionApi + '/createUserReponse',
    );
    var response = await client.post(
      url,
      body: {
        "comment": subject,
        "user": doctor,
        "question": discussion,
      },
    );
    print(url);
    if (response.statusCode == 200) {
      print("sucess adding createDocReponse");
      print(response.body);
      return true;
    } else {
      print('eroor failed adding createDocReponse');
      return false;
    }
  }

  static Future<bool> deleteAnswerToQuestion(n) async {
    var url =
        Uri.http(Config.apiUrl, Config.AnswerToQuestionApi + '/delete/' + n);
    var response = await client.delete(url);
    print(url);
    if (response.statusCode == 200) {
      print("sucess deleting AnswerToQuestionApi");
      return true;
    } else {
      print('eroor failed deleting AnswerToQuestionApi');

      return false;
    }
  }

  //medecin
  static Future<bool> updateMedecin(
    String id, {
    required String username,
    required String familyname,
    int? numeroTel,
    String? description,
    required String email,
    String? specialite,
    String? password,
    String? licenseNumber,
    bool? isApproved,
    bool? isVerified,
    String? imagePath, // Optional image path
  }) async {
    var url = Uri.http(Config.apiUrl, Config.medecinApi + '/update/' + id);

    // Create a map of the updated data
    Map<String, dynamic> updateData = {
      "username": username,
      "familyname": familyname,
      "numeroTel": numeroTel,
      "description": description,
      "email": email,
      "specialite": specialite,
      "password": password,
      "licenseNumber": licenseNumber,
      "isApproved": isApproved,
      "isVerified": isVerified,
    };

    // Add image path if provided
    if (imagePath != null) {
      updateData["image"] = imagePath;
    }

    // Make the PUT request
    var response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(updateData),
    );

    if (response.statusCode == 200) {
      // Handle successful response
      print("Medecin updated successfully: ${response.body}");
      return true; // Return true indicating success
    } else {
      // Handle error response
      print("Failed to update Medecin: ${response.body}");
      return false; // Return false indicating failure
    }
  }

  //cadeau
  static Future<List<CadeauPro>?> getAllCadeauPro() async {
    Map<String, String> requestHandler = {'Content-Type': 'application/json'};
    var url = Uri.http(Config.apiUrl, Config.CAdeauProApi + '/');
    print(url);
    var response = await client.get(url, headers: requestHandler);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      print('Success load CAdeauProApi');
      return CadeauProromJson(data);
    } else {
      throw Exception('Failed to load CAdeauProApi');
    }
  }

  static Future<String> getMedilinkAssistantResponse(String userInput) async {
    final url = Uri.parse('http://127.0.0.1:5000/chat');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'message': userInput}),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['response'];
    } else {
      throw Exception('Failed to connect to the Medilink Assistant');
    }
  }
}
