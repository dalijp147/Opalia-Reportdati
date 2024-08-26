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
        title: Text('Ton Score'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 50,
          ),
          widget.score == 5
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Félicitaion ${PreferenceUtils.getuserName()} vous venez de gagnez un produit .',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                  ),
                )
              : Text(''),
          SizedBox(
            height: 100,
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 300,
                width: 300,
                child: CircularProgressIndicator(
                  strokeWidth: 3.0,
                  value: widget.score / 3.0,
                  color: Colors.green,
                  backgroundColor: Colors.white,
                ),
              ),
              widget.score == 5
                  ? Column(
                      children: [
                        Text(
                          widget.score.toString(),
                          style: const TextStyle(fontSize: 80),
                        ),
                        Text(
                          "tu as gagné",
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Text(
                          widget.score.toString(),
                          style: const TextStyle(fontSize: 80),
                        ),
                        Text(
                          'desole tu na pas ganer',
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
                    )
            ],
          ),
        ],
      ),
    );
  }
}
