import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opalia_client/screens/widegts/quiz/ListQuiz.dart';

import '../../../services/local/sharedprefutils.dart';
import '../../../services/remote/apiService.dart';
import '../../widegts/Allappwidgets/AppbarWidegts.dart';
import '../../widegts/Allappwidgets/Drawerwidgets.dart';
import '../menu/MenuScreen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  bool verif = false;
  Future<bool> verify() async {
    final x = await ApiService.getResultUserId(PreferenceUtils.getuserid());
    if (x == true) {
      setState(() {
        verif = x;
      });

      print("ok");
      print(verif);
      return verif;
    } else {
      print("error");
      return verif;
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
      drawer: DrawerWidget(),
      appBar: AppbarWidgets(),
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
          verif
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Tu a deja partcipé au quiz , passer nous voire une prochaine fois.',
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : ElevatedButton(
                  onPressed: () async {
                    //Get.to(ListQuizScreen());
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
