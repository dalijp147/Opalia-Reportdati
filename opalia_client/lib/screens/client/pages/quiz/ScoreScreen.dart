import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opalia_client/screens/client/pages/quiz/QuizScreen.dart';
import 'package:opalia_client/screens/pro/widgets/Allappwidgets/BottomNavPro.dart';

import '../../../../models/question.dart';
import '../../../../services/local/sharedprefutils.dart';
import '../../../../services/remote/apiService.dart';
import '../../widgets/Allappwidgets/BottomNav.dart';
import '../categorie/CategorieScreen.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({
    super.key,
    required this.score,
  });

  final int score;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  void initState() {
    // showDialog(
    //   context: context,
    //   builder: _buildPopupDialog(context),
    // );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.to(BottomNav());
          },
          icon: Icon(Icons.arrow_back),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              stops: [1, 0.1],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.red.shade50, Colors.white],
            ),
          ),
        ),
        title: Text('Ton Score' + ' ' + 'est' + ' ' + widget.score.toString()),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 50,
          ),
          SizedBox(
            height: 100,
          ),
          widget.score == 5
              ? Column(
                  children: [
                    Image.asset('assets/images/grop.png', scale: 0.5),
                    Text(
                      "Tu as gagné vérifie votre boîte mail",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              : Column(
                  children: [
                    Image.asset('assets/images/imageee.png'),
                    Text(
                      'Désole-vous avez perdu',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
