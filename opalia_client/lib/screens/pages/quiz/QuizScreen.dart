import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opalia_client/screens/pages/quiz/ListQuiz.dart';

import '../../../services/apiService.dart';
import '../../../services/sharedprefutils.dart';
import '../menu/MenuScreen.dart';
import '../menu/SettingsScreen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  bool v = false;
  Future<bool> verify() async {
    final x = await ApiService.getResultUserId(PreferenceUtils.getuserid());
    if (x == true) {
      setState(() {
        v = x;
      });

      print("ok");
      print(v);
      return v;
    } else {
      print("error");
      return v;
    }
  }

  @override
  void initState() {
    verify();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  stops: [1, 0.1],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.red.shade50, Colors.white])),
        ),
        leading: Text(''),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Get.to(
                  MenuScreen(),
                );
              },
              icon: const Icon(
                Icons.person,
                color: Colors.red,
              ))
        ],
        title: const Text(
          'OPALIA RECORDATI',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          const Center(
            child: const Text(
              'Quiz',
              style: const TextStyle(
                  fontSize: 35, fontWeight: FontWeight.bold, color: Colors.red),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Image.asset(
            'assets/images/quizimage.jpg',
            scale: 1.0,
          ),
          SizedBox(
            height: 50,
          ),
          v
              ? Text(
                  'Tu a deja partcipé au quiz',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )
              : ElevatedButton(
                  onPressed: () async {
                    Get.to(ListQuizScreen());
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: Text(
                    'Lets get Started',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
        ],
      ),
    );
  }
}
