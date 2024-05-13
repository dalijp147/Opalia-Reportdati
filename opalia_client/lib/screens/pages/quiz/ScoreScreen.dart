import 'package:flutter/material.dart';

import '../../../models/question.dart';
import '../../../services/apiService.dart';

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
  List<Question> ques = [];

  Future<void> _fetchQuestion() async {
    try {
      final events = await ApiService.fetchQuestion();
      setState(() {
        ques = events!;
      });
    } catch (e) {
      print('Failed to fetch events: $e');
    }
  }

  @override
  void initState() {
    _fetchQuestion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
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
                widget.score == 3
                    ? Column(
                        children: [
                          Text(
                            widget.score.toString(),
                            style: const TextStyle(fontSize: 80),
                          ),
                          Text(
                            'Félicitation',
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
                            'Bien',
                            style: const TextStyle(fontSize: 20),
                          ),
                        ],
                      )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
